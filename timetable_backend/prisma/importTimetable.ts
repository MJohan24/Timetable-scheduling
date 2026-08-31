import 'dotenv/config';

import { randomUUID } from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { Prisma, PrismaClient } from '@prisma/client';
import { operationalStationCodes } from './operationalStationCodes';

type Stop = {
  stationCode: string;
  sequence: number;
  arrivalMinute: number | null;
  departureMinute: number | null;
  isPassThrough: boolean;
};

type Service = {
  lineSlug: string;
  direction: string;
  sourcePage: number;
  sourceRow: number;
  loopNumber: number | null;
  trainNumber: string;
  continuationTrainNumber: string | null;
  relation: string;
  calendarCode: 'DAILY' | 'WEEKDAY';
  isFullRacket: boolean;
  notes: string;
  stops: Stop[];
};

type Snapshot = {
  meta: {
    version: string;
    sourceName: string;
    sourceSha256: string;
    timezone: string;
  };
  services: Service[];
};

const EXPECTED_LINE_TOTALS: Record<string, number> = {
  bogor: 392,
  cikarang: 365,
  rangkasbitung: 204,
  tangerang: 120,
  tanjung_priok: 64,
};
const SERVICE_GEOMETRY: Record<string, string[]> = {
  bogor: ['bogor', 'bogor_nambo'],
  cikarang: ['cikarang_loop', 'cikarang_east'],
  rangkasbitung: ['rangkasbitung'],
  tangerang: ['tangerang'],
  tanjung_priok: ['tanjung_priok'],
};

const fail = (message: string): never => {
  throw new Error(`Invalid timetable snapshot: ${message}`);
};

function readSnapshot(file: string): Snapshot {
  const snapshot = JSON.parse(fs.readFileSync(file, 'utf8')) as Snapshot;
  if (snapshot.meta?.version !== '2026-02') fail('expected version 2026-02');
  if (!/^[a-f0-9]{64}$/.test(snapshot.meta.sourceSha256)) fail('invalid source SHA-256');
  if (snapshot.meta.timezone !== 'Asia/Jakarta') fail('invalid timezone');
  if (snapshot.services?.length !== 1145) fail('expected 1,145 services');

  const codes = new Set<string>();
  const trainNumbers = new Set<string>();
  const lineTotals: Record<string, number> = {};
  let calls = 0;
  for (const service of snapshot.services) {
    if (trainNumbers.has(service.trainNumber)) fail(`duplicate KA ${service.trainNumber}`);
    trainNumbers.add(service.trainNumber);
    lineTotals[service.lineSlug] = (lineTotals[service.lineSlug] ?? 0) + 1;
    service.stops.forEach((stop, index) => {
      codes.add(stop.stationCode);
      calls += 1;
      if (stop.sequence !== index + 1) fail(`non-contiguous stop sequence for KA ${service.trainNumber}`);
      if (!(stop.stationCode in operationalStationCodes)) fail(`unknown station code ${stop.stationCode}`);
      if (stop.isPassThrough !== (stop.arrivalMinute == null && stop.departureMinute == null)) {
        fail(`invalid pass-through values for KA ${service.trainNumber}`);
      }
    });
  }
  if (calls !== 19328) fail(`expected 19,328 calls, got ${calls}`);
  if (codes.size !== 85) fail(`expected 85 station codes, got ${codes.size}`);
  if (JSON.stringify(lineTotals) !== JSON.stringify(EXPECTED_LINE_TOTALS)) fail('line totals differ from audited PDF');
  return snapshot;
}

async function importSnapshot(file: string) {
  const snapshot = readSnapshot(file);
  const prisma = new PrismaClient();
  try {
    const stationSlugs = Object.values(operationalStationCodes);
    const lineSlugs = Object.values(SERVICE_GEOMETRY).flat();
    const [stations, lines] = await Promise.all([
      prisma.station.findMany({ where: { slug: { in: stationSlugs } }, select: { id: true, slug: true } }),
      prisma.line.findMany({ where: { slug: { in: lineSlugs } }, select: { id: true, slug: true } }),
    ]);
    const stationBySlug = new Map(stations.map(({ slug, id }) => [slug!, id]));
    const availableLines = new Set(lines.map(({ slug }) => slug!));
    const missingStations = stationSlugs.filter((slug) => !stationBySlug.has(slug));
    const missingLines = lineSlugs.filter((slug) => !availableLines.has(slug));
    if (missingStations.length || missingLines.length) {
      throw new Error(`Missing catalog records: stations=[${missingStations}], lines=[${missingLines}]`);
    }

    const result = await prisma.$transaction(
      async (tx) => {
        await tx.timetableDataset.deleteMany({ where: { version: snapshot.meta.version } });
        const dataset = await tx.timetableDataset.create({
          data: {
            version: snapshot.meta.version,
            sourceName: snapshot.meta.sourceName,
            sourceSha256: snapshot.meta.sourceSha256,
            timezone: snapshot.meta.timezone,
            validFrom: new Date('2026-02-01T00:00:00.000Z'),
          },
        });

        const calendarIds = { DAILY: randomUUID(), WEEKDAY: randomUUID() };
        await tx.serviceCalendar.createMany({
          data: [
            { id: calendarIds.DAILY, datasetId: dataset.id, code: 'DAILY' },
            {
              id: calendarIds.WEEKDAY,
              datasetId: dataset.id,
              code: 'WEEKDAY',
              saturday: false,
              sunday: false,
              excludesPublicHolidays: true,
            },
          ],
        });

        const serviceIds = new Map(snapshot.services.map(({ trainNumber }) => [trainNumber, randomUUID()]));
        await tx.trainService.createMany({
          data: snapshot.services.map((service) => ({
            id: serviceIds.get(service.trainNumber)!,
            datasetId: dataset.id,
            calendarId: calendarIds[service.calendarCode],
            lineSlug: service.lineSlug,
            trainNumber: service.trainNumber,
            continuationTrainNumber: service.continuationTrainNumber,
            relation: service.relation,
            direction: service.direction,
            loopNumber: service.loopNumber,
            sourcePage: service.sourcePage,
            sourceRow: service.sourceRow,
            isFullRacket: service.isFullRacket,
            notes: service.notes,
          })),
        });

        const stopRows = snapshot.services.flatMap((service) =>
          service.stops.map((stop) => ({
            id: randomUUID(),
            serviceId: serviceIds.get(service.trainNumber)!,
            stationId: stationBySlug.get(operationalStationCodes[stop.stationCode as keyof typeof operationalStationCodes])!,
            ...stop,
          })),
        );
        for (let index = 0; index < stopRows.length; index += 1000) {
          await tx.trainStopTime.createMany({ data: stopRows.slice(index, index + 1000) });
        }

        const stationValues = Prisma.join(
          Object.entries(operationalStationCodes).map(([code, slug]) => Prisma.sql`(${slug}, ${code})`),
        );
        await tx.$executeRaw(
          Prisma.sql`UPDATE "Station" AS s SET "code" = v.code FROM (VALUES ${stationValues}) AS v(slug, code) WHERE s.slug = v.slug`,
        );
        await tx.timetableDataset.updateMany({ where: { isActive: true }, data: { isActive: false } });
        await tx.timetableDataset.update({ where: { id: dataset.id }, data: { isActive: true } });
        return { dataset, services: snapshot.services.length, stops: stopRows.length };
      },
      { maxWait: 10_000, timeout: 120_000 },
    );
    console.log(`Imported ${result.dataset.version}: ${result.services} services, ${result.stops} stops (active).`);
  } finally {
    await prisma.$disconnect();
  }
}

const input = process.argv[2] ?? path.join(process.cwd(), 'prisma/data/commuter-2026-02.json');
importSnapshot(path.resolve(input)).catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
