import { prisma } from '../../infrastructure/database/prismaClient';
import { AsyncValueCache } from '../../infrastructure/cache/asyncValueCache';
import { choosePlatformRule } from './platformRuleService';

export interface TimetableDeparture {
  id: string;
  trainNumber: string;
  continuationTrainNumber: string | null;
  route: string;
  departureMinute: number;
  arrivalMinute: number;
  platform: string;
  calendarCode: string;
  lineSlug: string;
}

export interface TimetableReadModel {
  datasetId: string;
  datasetVersion: string;
  dateKey: string;
  departuresByStationId: Map<string, TimetableDeparture[]>;
}

export interface TimetableReadModelIdentity {
  datasetId: string;
  datasetUpdatedAt: string;
  sourceSha256: string;
  timetableFingerprint: string;
  platformFingerprint: string;
  dateKey: string;
}

export interface TimetableReadQuery {
  isWeekend: boolean;
  departureFromMinute?: number;
  departureToMinute?: number;
  page: number;
  limit: number;
}

const readModelCache = new AsyncValueCache<TimetableReadModel | null>();
let loadedIdentity: TimetableReadModelIdentity | null = null;
let refreshInFlight: Promise<void> | null = null;

export function jakartaDateKey(date = new Date()) {
  const parts = new Intl.DateTimeFormat('en', {
    timeZone: 'Asia/Jakarta', year: 'numeric', month: '2-digit', day: '2-digit',
  }).formatToParts(date);
  const part = (type: Intl.DateTimeFormatPartTypes) => (
    parts.find((entry) => entry.type === type)?.value ?? ''
  );
  return `${part('year')}-${part('month')}-${part('day')}`;
}

export function timetableIdentityChanged(
  current: TimetableReadModelIdentity | null,
  next: TimetableReadModelIdentity | null,
) {
  return JSON.stringify(current) !== JSON.stringify(next);
}

const platformRuleWhere = (now: Date) => ({
  AND: [
    { OR: [{ validFrom: null }, { validFrom: { lte: now } }] },
    { OR: [{ validTo: null }, { validTo: { gte: now } }] },
  ],
});

async function readTimetableIdentity(): Promise<TimetableReadModelIdentity | null> {
  const now = new Date();
  const dataset = await prisma.timetableDataset.findFirst({
    where: { isActive: true },
    select: {
      id: true, updatedAt: true, sourceSha256: true,
    },
  });
  if (!dataset) return null;
  const [timetableRows, platformRows] = await Promise.all([
    prisma.$queryRaw<Array<{ fingerprint: string }>>`
      SELECT md5(COALESCE(string_agg(concat_ws('|',
        service."trainNumber", COALESCE(service."continuationTrainNumber", ''),
        service."lineSlug", service."relation", service."direction",
        COALESCE(service."loopNumber"::text, ''), service."sourcePage"::text,
        service."sourceRow"::text, service."isFullRacket"::text, service."notes",
        calendar."code", calendar."monday"::text, calendar."tuesday"::text,
        calendar."wednesday"::text, calendar."thursday"::text,
        calendar."friday"::text, calendar."saturday"::text,
        calendar."sunday"::text, calendar."excludesPublicHolidays"::text,
        stop."sequence"::text, stop."stationId", stop."stationCode",
        COALESCE(stop."arrivalMinute"::text, ''),
        COALESCE(stop."departureMinute"::text, ''), stop."isPassThrough"::text
      ), E'\n' ORDER BY service."trainNumber", stop."sequence"), '')) AS fingerprint
      FROM "TrainService" service
      JOIN "ServiceCalendar" calendar ON calendar."id" = service."calendarId"
      LEFT JOIN "TrainStopTime" stop ON stop."serviceId" = service."id"
      WHERE service."datasetId" = ${dataset.id}
    `,
    prisma.$queryRaw<Array<{ fingerprint: string }>>`
      SELECT md5(COALESCE(string_agg(concat_ws('|',
        rule."stationId", rule."lineSlug", rule."direction",
        COALESCE(rule."destination", ''), rule."platform", rule."sourceName",
        rule."sourceUrl", COALESCE(rule."validFrom"::text, ''),
        COALESCE(rule."validTo"::text, ''), rule."verifiedAt"::text,
        rule."updatedAt"::text
      ), E'\n' ORDER BY rule."stationId", rule."lineSlug", rule."direction",
        rule."destination"), '')) AS fingerprint
      FROM "StationPlatformRule" rule
    `,
  ]);
  return {
    datasetId: dataset.id,
    datasetUpdatedAt: dataset.updatedAt.toISOString(),
    sourceSha256: dataset.sourceSha256,
    timetableFingerprint: timetableRows[0]?.fingerprint ?? '',
    platformFingerprint: platformRows[0]?.fingerprint ?? '',
    dateKey: jakartaDateKey(now),
  };
}

async function loadTimetableReadModel(): Promise<TimetableReadModel | null> {
  const dateKey = jakartaDateKey();
  const now = new Date();
  const [dataset, platformRules] = await Promise.all([
    prisma.timetableDataset.findFirst({
      where: { isActive: true },
      select: {
        id: true,
        version: true,
        services: {
          select: {
            id: true,
            trainNumber: true,
            continuationTrainNumber: true,
            lineSlug: true,
            direction: true,
            calendar: { select: { code: true } },
            stops: {
              orderBy: { sequence: 'asc' },
              select: {
                stationId: true,
                arrivalMinute: true,
                departureMinute: true,
                isPassThrough: true,
                station: { select: { name: true, officialName: true } },
              },
            },
          },
        },
      },
    }),
    prisma.stationPlatformRule.findMany({
      where: platformRuleWhere(now),
      select: {
        stationId: true,
        lineSlug: true,
        direction: true,
        destination: true,
        platform: true,
      },
    }),
  ]);
  if (!dataset) return null;

  const rulesByStationLine = new Map<string, typeof platformRules>();
  for (const rule of platformRules) {
    const key = `${rule.stationId}:${rule.lineSlug}`;
    const rules = rulesByStationLine.get(key) ?? [];
    rules.push(rule);
    rulesByStationLine.set(key, rules);
  }

  const departuresByStationId = new Map<string, TimetableDeparture[]>();
  for (const service of dataset.services) {
    const timedStops = service.stops.filter(({ arrivalMinute }) => arrivalMinute != null);
    const first = timedStops[0];
    const last = timedStops.at(-1);
    const display = (stop: typeof first | undefined) => (
      stop?.station.officialName ?? stop?.station.name ?? ''
    );
    const destination = display(last);
    const route = `${display(first)} - ${destination}`;
    for (const stop of service.stops) {
      if (stop.isPassThrough || stop.departureMinute == null) continue;
      const rules = rulesByStationLine.get(`${stop.stationId}:${service.lineSlug}`) ?? [];
      const platform = choosePlatformRule(rules, {
        direction: service.direction,
        destination,
      })?.platform ?? '';
      const departures = departuresByStationId.get(stop.stationId) ?? [];
      departures.push({
        id: service.id,
        trainNumber: service.trainNumber,
        continuationTrainNumber: service.continuationTrainNumber,
        route,
        departureMinute: stop.departureMinute,
        arrivalMinute: last?.arrivalMinute ?? stop.departureMinute,
        platform,
        calendarCode: service.calendar.code,
        lineSlug: service.lineSlug,
      });
      departuresByStationId.set(stop.stationId, departures);
    }
  }
  for (const departures of departuresByStationId.values()) {
    departures.sort((left, right) => left.departureMinute - right.departureMinute);
  }
  return {
    datasetId: dataset.id,
    datasetVersion: dataset.version,
    dateKey,
    departuresByStationId,
  };
}

export function getTimetableReadModel() {
  return readModelCache.get(async () => {
    const identityBeforeLoad = await readTimetableIdentity();
    const model = await loadTimetableReadModel();
    const identityAfterLoad = await readTimetableIdentity();
    if (timetableIdentityChanged(identityBeforeLoad, identityAfterLoad)) {
      throw new Error('Timetable changed while the startup snapshot was loading.');
    }
    loadedIdentity = identityAfterLoad;
    return model;
  });
}

export function clearTimetableReadModel() {
  loadedIdentity = null;
  readModelCache.clear();
}

export function queryTimetableReadModel(
  model: TimetableReadModel,
  stationId: string,
  query: TimetableReadQuery,
) {
  const calendarCodes = query.isWeekend ? ['DAILY'] : ['DAILY', 'WEEKDAY'];
  const matching = (model.departuresByStationId.get(stationId) ?? []).filter((departure) => (
    calendarCodes.includes(departure.calendarCode)
    && (query.departureFromMinute === undefined || departure.departureMinute >= query.departureFromMinute)
    && (query.departureToMinute === undefined || departure.departureMinute <= query.departureToMinute)
  ));
  const start = (query.page - 1) * query.limit;
  return {
    departures: matching.slice(start, start + query.limit),
    total: matching.length,
  };
}

export function startTimetableReadModelRefresh(
  intervalMs = 60_000,
  onAvailabilityChange: (available: boolean) => void = () => {},
) {
  const timer = setInterval(() => {
    if (refreshInFlight) return;
    const refresh = (async () => {
      const nextIdentity = await readTimetableIdentity();
      if (!timetableIdentityChanged(loadedIdentity, nextIdentity)) return;
      const model = await loadTimetableReadModel();
      const confirmedIdentity = await readTimetableIdentity();
      if (timetableIdentityChanged(nextIdentity, confirmedIdentity)) {
        throw new Error('Timetable changed while a new snapshot was loading.');
      }
      readModelCache.replace(model);
      loadedIdentity = confirmedIdentity;
      onAvailabilityChange(model != null && model.departuresByStationId.size > 0);
    })();
    refreshInFlight = refresh;
    void refresh.catch((error) => {
      console.warn(`[timetable-cache] Refresh failed; previous snapshot retained: ${error instanceof Error ? error.message : 'unknown error'}`);
    }).finally(() => {
      if (refreshInFlight === refresh) refreshInFlight = null;
    });
  }, intervalMs);
  timer.unref();
  return timer;
}
