import { mkdir, writeFile } from 'node:fs/promises';
import { randomUUID } from 'node:crypto';
import { performance } from 'node:perf_hooks';
import { setTimeout as delay } from 'node:timers/promises';
import { parseArgs } from 'node:util';
import { pathToFileURL } from 'node:url';
import path from 'node:path';

// Read-only scenarios; route planning does not book tickets or call payment providers.
const routeVariant = (
  from,
  to,
  passengerCount = 1,
  preference = 'FASTEST',
  fromDisplay = from,
  toDisplay = to,
) => ({
  path: '/routes/plan',
  body: { from, to, passengerCount, preference },
  expect: { kind: 'route', from: fromDisplay, to: toDisplay, passengerCount, preference },
});
export const scenarios = [
  { name: 'station-list', variants: [
    { path: '/stations?page=1&limit=40', expect: { kind: 'station-list' } },
    { path: '/stations?page=2&limit=40', expect: { kind: 'station-list' } },
    { path: '/stations?page=3&limit=40', expect: { kind: 'station-list' } },
  ] },
  { name: 'station-search', variants: [
    { path: '/stations/search?q=mang&limit=20', expect: { kind: 'station-search', query: 'mang' } },
    { path: '/stations/search?q=bog&limit=20', expect: { kind: 'station-search', query: 'bog' } },
    { path: '/stations/search?q=cik&limit=20', expect: { kind: 'station-search', query: 'cik' } },
  ] },
  { name: 'route-direct', variants: [
    routeVariant('bogor', 'jakarta-kota'),
    routeVariant('depok', 'jayakarta', 2),
    routeVariant('manggarai', 'bogor', 1, 'MIN_TRANSFERS'),
  ] },
  { name: 'route-interchange', variants: [
    routeVariant('cikini', 'bni-city'),
    routeVariant('bogor', 'tangerang', 2, 'MIN_TRANSFERS'),
    routeVariant('manggarai', 'rangkasbitung'),
  ] },
  { name: 'route-walking', variants: [
    routeVariant('cikoko', 'tebet'),
    routeVariant('dukuh-atas', 'cawang', 1, 'FASTEST', 'Dukuh Atas BNI', 'Cawang'),
    routeVariant('cikoko', 'manggarai', 2),
  ] },
  { name: 'schedule-krl', variants: [
    {
      path: '/schedules?station=Manggarai&trainType=KRL&isWeekend=false&page=1&limit=40',
      expect: { kind: 'schedule', station: 'Manggarai' },
    },
    {
      path: '/schedules?station=Bogor&trainType=KRL&isWeekend=false&departureFrom=05%3A00&page=1&limit=30',
      expect: { kind: 'schedule', station: 'Bogor', departureFromMinute: 300 },
    },
    {
      path: '/schedules?station=Tanah%20Abang&trainType=KRL&isWeekend=false&departureTo=12%3A00&page=2&limit=20',
      expect: { kind: 'schedule', station: 'Tanah Abang', departureToMinute: 720 },
    },
  ] },
];

export function scenarioForRound(scenario, round) {
  const variant = scenario.variants[(round - 1) % scenario.variants.length];
  return { name: scenario.name, ...variant };
}

const roundMs = (value) => Number(value.toFixed(3));
const normalize = (value) => String(value ?? '').toLowerCase().replace(/[^a-z0-9]/g, '');
const scheduleMinute = (entry) => {
  const [hour, minute] = String(entry.departureTime ?? '').split(':').map(Number);
  return hour * 60 + minute + Number(entry.dayOffset ?? 0) * 1440;
};
const isStationDto = (entry) => entry && typeof entry.id === 'string' && entry.id.length > 0
  && typeof entry.name === 'string' && entry.name.trim().length > 0
  && typeof entry.officialName === 'string' && entry.officialName.trim().length > 0
  && typeof entry.isBoardingAllowed === 'boolean'
  && typeof entry.isKrl === 'boolean' && typeof entry.isLrt === 'boolean'
  && typeof entry.isMrt === 'boolean'
  && Array.isArray(entry.aliases) && Array.isArray(entry.publicCodes)
  && Array.isArray(entry.lines) && Array.isArray(entry.nodes);
const stationSearchValues = (entry) => [
  entry.name, entry.shortName, entry.officialName, entry.operationalCode,
  ...(entry.aliases ?? []),
  ...(entry.publicCodes ?? []).map(({ code }) => code),
];

function hasValidData(payload, expected) {
  if (payload.success !== true || !Array.isArray(payload.data) && expected.kind !== 'route') return false;
  if (expected.kind === 'route') {
    const data = payload.data;
    return data && Array.isArray(data.stationSequence) && data.stationSequence.length > 1
      && Array.isArray(data.steps) && data.steps.length > 1
      && normalize(data.from) === normalize(expected.from)
      && normalize(data.to) === normalize(expected.to)
      && data.passengerCount === expected.passengerCount
      && data.preference === expected.preference
      && normalize(data.stationSequence[0]?.name) === normalize(expected.from)
      && normalize(data.stationSequence.at(-1)?.name) === normalize(expected.to);
  }
  if (payload.data.length === 0) return false;
  if (expected.kind === 'station-search') {
    return payload.data.every(isStationDto) && payload.data.some((entry) => (
      stationSearchValues(entry).some((value) => normalize(value).includes(normalize(expected.query)))
    ));
  }
  if (expected.kind === 'schedule') {
    return payload.meta?.datasetVersion === '2026-02' && payload.data.every((entry) => {
      const minute = scheduleMinute(entry);
      return normalize(entry.station?.name) === normalize(expected.station)
        && Number.isFinite(minute)
        && (expected.departureFromMinute === undefined || minute >= expected.departureFromMinute)
        && (expected.departureToMinute === undefined || minute <= expected.departureToMinute);
    });
  }
  return payload.data.every(isStationDto);
}

export function summarize(rows, thresholdMs) {
  const successful = rows.filter((row) => row.ok);
  const times = successful.map((row) => row.elapsedMs).sort((a, b) => a - b);
  const exceeded = times.filter((ms) => ms >= thresholdMs).length;
  return {
    attempts: rows.length,
    errors: rows.length - successful.length,
    atOrAboveTarget: exceeded,
    firstMs: rows[0]?.ok ? roundMs(rows[0].elapsedMs) : null,
    avgMs: times.length ? roundMs(times.reduce((a, b) => a + b, 0) / times.length) : null,
    p95Ms: times.length ? roundMs(times[Math.ceil(times.length * 0.95) - 1]) : null,
    maxMs: times.length ? roundMs(times.at(-1)) : null,
    pass: times.length > 0 && successful.length === rows.length && exceeded === 0,
  };
}

export function readOptions(args) {
  const { values } = parseArgs({ args, options: {
    base: { type: 'string', default: 'http://127.0.0.1:3000/api/v1' },
    rounds: { type: 'string', default: '5' },
    interval: { type: 'string' },
    timeout: { type: 'string', default: '15000' },
    threshold: { type: 'string', default: '200' },
    out: { type: 'string', default: 'reports/performance' },
    continuous: { type: 'boolean', default: false },
    help: { type: 'boolean', default: false },
  } });
  const base = new URL(values.base);
  if (!['http:', 'https:'].includes(base.protocol) || base.username || base.password || base.search || base.hash) {
    throw new Error('--base must be an HTTP(S) API URL without credentials, query, or fragment.');
  }
  const numeric = (name, value, min, max) => {
    const number = Number(value);
    if (!Number.isInteger(number) || number < min || number > max) throw new Error(`--${name} must be ${min}..${max}.`);
    return number;
  };
  return {
    base: base.href.replace(/\/+$/, ''),
    rounds: numeric('rounds', values.rounds, 1, 100),
    intervalMs: numeric('interval', values.interval ?? (values.continuous ? '12000' : '1000'), values.continuous ? 10000 : 0, 60000),
    timeoutMs: numeric('timeout', values.timeout, 1, 60000),
    thresholdMs: numeric('threshold', values.threshold, 1, 60000),
    out: values.out, continuous: values.continuous, help: values.help,
  };
}

async function request(scenario, options, signal) {
  const started = performance.now();
  const result = {
    scenario: scenario.name,
    target: scenario.path,
    parameters: scenario.body ?? null,
    status: null,
    ok: false,
    timings: {},
  };
  try {
    const response = await fetch(`${options.base}${scenario.path}`, {
      method: scenario.body ? 'POST' : 'GET',
      headers: { Accept: 'application/json', ...(scenario.body ? { 'Content-Type': 'application/json' } : {}) },
      body: scenario.body ? JSON.stringify(scenario.body) : undefined,
      redirect: 'error',
      signal: AbortSignal.any([signal, AbortSignal.timeout(options.timeoutMs)]),
    });
    result.status = response.status;
    for (const entry of response.headers.get('server-timing')?.split(',') ?? []) {
      const match = entry.trim().match(/^([a-z_]+);dur=([\d.]+)$/);
      if (match && Number.isFinite(Number(match[2]))) result.timings[match[1]] = Number(match[2]);
    }
    const text = await response.text();
    if (!response.ok) throw new Error(`HTTP_${response.status}`);
    const payload = JSON.parse(text);
    if (!hasValidData(payload, scenario.expect)) throw new Error('INVALID_OR_EMPTY_DATA');
    result.ok = true;
  } catch (error) {
    // Do not persist response bodies, request credentials, or connection error details.
    result.error = signal.aborted ? 'INTERRUPTED' : result.status && result.status >= 400
      ? `HTTP_${result.status}` : ['INVALID_OR_EMPTY_DATA', 'EXPECTED_COMMUTER_DATASET_2026_02'].includes(error.message)
        ? error.message : error.name;
  }
  result.elapsedMs = performance.now() - started;
  return result;
}

export async function runBatch(options, signal, log = console.log) {
  const startedAt = new Date().toISOString();
  const samples = [];
  let stoppedBy = 'completed';
  batch: for (let round = 1; round <= options.rounds; round++) {
    for (const scenario of scenarios) {
      if (signal.aborted) { stoppedBy = 'interrupted'; break batch; }
      const activeScenario = scenarioForRound(scenario, round);
      const sample = { round, ...await request(activeScenario, options, signal) };
      samples.push(sample);
      const phases = Object.entries(sample.timings)
        .map(([name, duration]) => `${name}=${roundMs(duration)}ms`)
        .join(' ');
      log(`[${round}/${options.rounds}] ${scenario.name} ${roundMs(sample.elapsedMs)} ms | ${sample.error ?? (sample.elapsedMs < options.thresholdMs ? 'PASS' : 'SLOW')}${phases ? ` | ${phases}` : ''}`);
      if (sample.status === 429) { stoppedBy = 'rate-limited'; break batch; }
      if (sample.error === 'INTERRUPTED') { stoppedBy = 'interrupted'; break batch; }
      if (sample.status === null || sample.error === 'TimeoutError') { stoppedBy = 'connection-or-timeout'; break batch; }
      try { await delay(options.intervalMs, undefined, { signal }); } catch { stoppedBy = 'interrupted'; break batch; }
    }
  }
  return {
    startedAt, finishedAt: new Date().toISOString(), stoppedBy,
    node: process.version, platform: process.platform, concurrency: 1,
    base: options.base, rounds: options.rounds, intervalMs: options.intervalMs,
    thresholdMs: options.thresholdMs, timeoutMs: options.timeoutMs,
    scope: 'HTTP request through body read and JSON parse; not Flutter UI or device rendering. First requests are retained; not guaranteed cold starts.',
    metricsMissing: samples.filter((s) => s.ok && s.timings.handler === undefined).length,
    summary: scenarios.map(({ name }) => ({ scenario: name, ...summarize(samples.filter((s) => s.scenario === name), options.thresholdMs) })),
    samples,
  };
}

export function toCsvCell(value) {
  const serialized = value != null && typeof value === 'object' ? JSON.stringify(value) : String(value ?? '');
  return `"${serialized.replaceAll('"', '""')}"`;
}

async function saveReport(report, directory) {
  await mkdir(directory, { recursive: true });
  const stem = path.join(directory, `${report.startedAt.replace(/[:.]/g, '-')}-${randomUUID().slice(0, 8)}`);
  const metrics = [
    'handler', 'station_query', 'station_lookup', 'graph_load', 'dijkstra', 'route_format',
    'schedule_catalog', 'schedule_query', 'schedule_format',
  ];
  const columns = ['round', 'scenario', 'target', 'parameters', 'status', 'ok', 'elapsedMs', 'error', ...metrics];
  const csv = [columns.map(toCsvCell).join(','), ...report.samples.map((sample) => columns.map((key) =>
    toCsvCell(key === 'elapsedMs' ? roundMs(sample.elapsedMs) : sample[key] ?? sample.timings[key] ?? '')).join(','))].join('\n');
  await writeFile(`${stem}.json`, JSON.stringify(report, null, 2), { flag: 'wx' });
  await writeFile(`${stem}.csv`, csv + '\n', { flag: 'wx' });
  console.log(`Reports: ${stem}.{json,csv}`);
}

async function main() {
  const options = readOptions(process.argv.slice(2));
  if (options.help) {
    console.log('npm run benchmark -- [--base http://127.0.0.1:3000/api/v1] [--rounds 5] [--threshold 200] [--interval 1000] [--timeout 15000] [--out reports/performance] [--continuous]');
    console.log('Continuous: minimum 10000 ms between requests; Ctrl+C saves the partial batch. Stops on HTTP 429 or connection/timeout failure.');
    return;
  }
  const controller = new AbortController();
  const stop = () => controller.abort();
  process.once('SIGINT', stop);
  process.once('SIGTERM', stop);
  try {
    do {
      // ponytail: bounded batches (max 600 samples); continuous mode saves and resets each batch.
      const report = await runBatch(options, controller.signal);
      await saveReport(report, options.out);
      console.table(report.summary);
      if (report.metricsMissing) console.warn('Server metrics absent: enable PERFORMANCE_METRICS=true on the tested backend. HTTP timings remain valid.');
      if (report.stoppedBy !== 'completed' || report.summary.some((s) => !s.pass)) process.exitCode = 1;
      if (report.stoppedBy !== 'completed') { console.warn(`Stopped: ${report.stoppedBy}. No rate-limit bypass or automatic retry.`); break; }
    } while (options.continuous && !controller.signal.aborted);
  } finally {
    process.removeListener('SIGINT', stop);
    process.removeListener('SIGTERM', stop);
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(path.resolve(process.argv[1])).href) {
  main().catch((error) => { console.error(error.message); process.exitCode = 2; });
}
