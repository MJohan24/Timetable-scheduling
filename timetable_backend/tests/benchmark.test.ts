import assert from 'node:assert/strict';
import { createServer } from 'node:http';
import { test } from 'node:test';
import { readOptions, runBatch, scenarios, summarize } from '../scripts/benchmark.mjs';

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
  assert.equal(readOptions(['--continuous']).intervalMs, 10000);
  assert.throws(() => readOptions(['--continuous', '--interval', '0']));
  assert.throws(() => readOptions(['--base', 'http://user:secret@localhost']));
  assert.throws(() => readOptions(['--rounds', 'NaN']));
});

test('benchmark includes body wait, rejects dummy/empty data, stops on 429 and body timeout', async (t) => {
  let mode = 'valid';
  let calls = 0;
  const server = createServer((req, res) => {
    calls++;
    req.resume();
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Server-Timing', 'handler;dur=1.234');
    if (mode === 'limited') { res.writeHead(429); res.end('{}'); return; }
    res.writeHead(200);
    res.flushHeaders();
    if (mode === 'timeout') return;
    const data = req.method === 'POST' ? { stationSequence: [{}, {}], steps: [{}, {}] } : [{}];
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
  const run = () => runBatch(options, new AbortController().signal, () => {});
  const report = await run();
  assert.equal(report.samples.length, scenarios.length);
  assert.ok(report.samples.every((s) => s.ok && s.elapsedMs >= 15 && s.timings.handler === 1.234));
  assert.ok(report.summary.every((s) => !s.pass && s.atOrAboveTarget === 1));

  mode = 'dummy';
  assert.equal((await run()).samples.at(-1).error, 'EXPECTED_COMMUTER_DATASET_2026_02');
  mode = 'empty';
  assert.ok((await run()).samples.every((s) => !s.ok));
  mode = 'limited'; calls = 0;
  assert.equal((await run()).stoppedBy, 'rate-limited');
  assert.equal(calls, 1);
  mode = 'timeout'; calls = 0; options.timeoutMs = 100;
  assert.equal((await run()).stoppedBy, 'connection-or-timeout');
  assert.equal(calls, 1);
});
