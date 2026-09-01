import assert from 'node:assert/strict';
import { createServer } from 'node:http';
import { test } from 'node:test';
import {
  readOptions,
  runBatch,
  scenarioForRound,
  scenarios,
  summarize,
  toCsvCell,
} from '../scripts/benchmark.mjs';

test('benchmark counts boundary violations and errors; rejects unsafe continuous settings', () => {
  const summary = summarize([
    { ok: true, elapsedMs: 199 }, { ok: true, elapsedMs: 200 }, { ok: false, elapsedMs: 1 },
  ], 200);
  assert.equal(summary.avgMs, 199.5);
  assert.equal(summary.p95Ms, 200);
  assert.equal(summary.atOrAboveTarget, 1);
  assert.equal(summary.errors, 1);
  assert.equal(summary.pass, false);
  assert.equal(summarize([], 200).pass, false);
  assert.equal(readOptions(['--continuous']).intervalMs, 12000);
  assert.throws(() => readOptions(['--continuous', '--interval', '0']));
  assert.throws(() => readOptions(['--base', 'http://user:secret@localhost']));
  assert.throws(() => readOptions(['--rounds', 'NaN']));
});

test('benchmark rotates valid inputs between rounds instead of repeating one URL', () => {
  for (const scenario of scenarios) {
    const first = scenarioForRound(scenario, 1);
    const second = scenarioForRound(scenario, 2);
    assert.notDeepEqual({ path: first.path, body: first.body }, { path: second.path, body: second.body });
  }
  const secondDirect = scenarioForRound(scenarios.find(({ name }) => name === 'route-direct'), 2);
  assert.equal(secondDirect.body.passengerCount, 2);
  assert.equal(secondDirect.body.passengers, undefined);
});

test('benchmark escapes nested JSON as one valid CSV cell', () => {
  assert.equal(toCsvCell({ from: 'Bogor', to: 'Jakarta Kota' }), '"{""from"":""Bogor"",""to"":""Jakarta Kota""}"');
});

test('benchmark includes body wait, rejects dummy/empty data, stops on 429 and body timeout', async (t) => {
  let mode = 'valid';
  let calls = 0;
  const server = createServer(async (req, res) => {
    calls++;
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Server-Timing', 'handler;dur=1.234');
    if (mode === 'limited') { res.writeHead(429); res.end('{}'); return; }
    res.writeHead(200);
    res.flushHeaders();
    if (mode === 'timeout') return;
    const requestUrl = new URL(req.url ?? '/', 'http://localhost');
    let data;
    if (req.method === 'POST') {
      const chunks: Buffer[] = [];
      for await (const chunk of req) chunks.push(chunk);
      const body = JSON.parse(Buffer.concat(chunks).toString('utf8'));
      data = {
        from: body.from === 'dukuh-atas' ? 'Dukuh Atas BNI' : body.from,
        to: body.to, passengerCount: body.passengerCount,
        preference: body.preference,
        stationSequence: [{ name: body.from === 'dukuh-atas' ? 'Dukuh Atas BNI' : body.from }, { name: body.to }],
        steps: [{ kind: 'board' }, { kind: 'arrive' }],
      };
      if (mode === 'dummy-route') data = { stationSequence: [{}, {}], steps: [{}, {}] };
    } else if (requestUrl.pathname.includes('schedules')) {
      data = [{ station: { name: requestUrl.searchParams.get('station') }, departureTime: '06:00', dayOffset: 0 }];
    } else {
      const name = requestUrl.searchParams.get('q') ?? 'Manggarai';
      data = [{
        id: 'station-1', name, shortName: name, officialName: name,
        operationalCode: null, isBoardingAllowed: true,
        isKrl: true, isLrt: false, isMrt: false,
        aliases: [], publicCodes: [], lines: [], nodes: [],
      }];
      if (mode === 'dummy-station') data = [{ id: 'station-1', name }];
    }
    setTimeout(() => res.end(JSON.stringify({
      success: true, data: mode === 'empty' ? [] : data,
      meta: { datasetVersion: mode === 'dummy' ? undefined : '2026-02' },
    })), 20);
  });
  server.listen(0, '127.0.0.1');
  await new Promise<void>((resolve) => server.once('listening', resolve));
  t.after(() => { server.closeAllConnections(); server.close(); });
  const address = server.address();
  assert.ok(address && typeof address !== 'string');
  const options = readOptions(['--base', `http://127.0.0.1:${address.port}`, '--rounds', '1', '--interval', '0', '--threshold', '5']);
  const logs: string[] = [];
  const run = () => runBatch(options, new AbortController().signal, (message) => logs.push(message));
  const report = await run();
  assert.equal(report.samples.length, scenarios.length);
  assert.ok(report.samples.every((s) => s.ok && s.elapsedMs >= 15 && s.timings.handler === 1.234));
  assert.ok(report.summary.every((s) => !s.pass && s.atOrAboveTarget === 1));
  assert.match(logs[0], /handler=1\.234ms/);

  mode = 'dummy';
  assert.equal((await run()).samples.at(-1).error, 'INVALID_OR_EMPTY_DATA');
  mode = 'empty';
  assert.ok((await run()).samples.every((s) => !s.ok));
  mode = 'dummy-route';
  assert.ok((await run()).samples.filter((s) => s.scenario.startsWith('route-')).every((s) => s.error === 'INVALID_OR_EMPTY_DATA'));
  mode = 'dummy-station';
  assert.ok((await run()).samples.filter((s) => s.scenario.startsWith('station-')).every((s) => s.error === 'INVALID_OR_EMPTY_DATA'));
  mode = 'limited'; calls = 0;
  assert.equal((await run()).stoppedBy, 'rate-limited');
  assert.equal(calls, 1);
  mode = 'timeout'; calls = 0; options.timeoutMs = 100;
  assert.equal((await run()).stoppedBy, 'connection-or-timeout');
  assert.equal(calls, 1);
});
