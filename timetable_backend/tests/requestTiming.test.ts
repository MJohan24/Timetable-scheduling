import assert from 'node:assert/strict';
import { test } from 'node:test';
import { setTimeout as delay } from 'node:timers/promises';
import express from 'express';
import { measurePhase, requestTiming } from '../src/infrastructure/observability/requestTiming';

test('opt-in timings preserve payloads and isolate concurrent requests, including errors', async (t) => {
  const previous = process.env.PERFORMANCE_METRICS;
  t.after(() => {
    if (previous === undefined) delete process.env.PERFORMANCE_METRICS;
    else process.env.PERFORMANCE_METRICS = previous;
  });
  const app = express();
  app.use(requestTiming);
  app.get('/:phase', async (req, res) => {
    const phase = String(req.params.phase);
    await measurePhase(phase, () => delay(phase === 'slow' ? 30 : 1));
    res.status(phase === 'failure' ? 500 : 200).json({ phase });
  });
  const server = app.listen(0, '127.0.0.1');
  await new Promise<void>((resolve) => server.once('listening', resolve));
  t.after(() => { server.closeAllConnections(); server.close(); });
  const address = server.address();
  assert.ok(address && typeof address !== 'string');
  const base = `http://127.0.0.1:${address.port}`;

  process.env.PERFORMANCE_METRICS = 'false';
  const disabled = await fetch(`${base}/disabled`);
  assert.equal(disabled.headers.get('server-timing'), null);
  assert.deepEqual(await disabled.json(), { phase: 'disabled' });

  process.env.PERFORMANCE_METRICS = 'true';
  const responses = await Promise.all(['slow', 'fast', 'failure'].map(async (phase) => {
    const response = await fetch(`${base}/${phase}`);
    assert.deepEqual(await response.json(), { phase });
    assert.equal(response.status, phase === 'failure' ? 500 : 200);
    const metrics = Object.fromEntries(response.headers.get('server-timing')!.split(', ').map((entry) => {
      const [name, duration] = entry.split(';dur=');
      return [name, Number(duration)];
    }));
    assert.deepEqual(Object.keys(metrics).sort(), ['handler', phase].sort());
    assert.ok(metrics.handler >= metrics[phase]);
    return metrics;
  }));
  assert.ok(responses[0].slow >= 15);
});
