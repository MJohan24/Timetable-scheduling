import { AsyncLocalStorage } from 'node:async_hooks';
import { performance } from 'node:perf_hooks';
import type { RequestHandler } from 'express';

const requestMetrics = new AsyncLocalStorage<Map<string, number>>();

export function beginTiming(name: string) {
  const metrics = requestMetrics.getStore();
  if (!metrics) return () => {};
  const started = performance.now();
  return () => metrics.set(name, performance.now() - started);
}

export async function measurePhase<T>(name: string, action: () => PromiseLike<T>) {
  const finish = beginTiming(name);
  try {
    return await action();
  } finally {
    finish();
  }
}

// Opt-in diagnostics. Wall time includes awaits; this is not per-request CPU time.
export const requestTiming: RequestHandler = (_req, res, next) => {
  if (process.env.PERFORMANCE_METRICS !== 'true') return next();
  requestMetrics.run(new Map(), () => {
    const metrics = requestMetrics.getStore()!;
    const finish = beginTiming('handler');
    const originalJson = res.json;
    res.json = function (body) {
      finish();
      this.setHeader('Server-Timing', [...metrics]
        .map(([name, duration]) => `${name};dur=${duration.toFixed(3)}`).join(', '));
      return originalJson.call(this, body);
    };
    next();
  });
};
