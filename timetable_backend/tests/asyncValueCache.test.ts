import assert from 'node:assert/strict';
import { test } from 'node:test';
import { AsyncValueCache } from '../src/infrastructure/cache/asyncValueCache';

test('async value cache shares one in-flight load and reuses its result', async () => {
  const cache = new AsyncValueCache<number>();
  let loads = 0;
  const load = async () => {
    loads++;
    return 42;
  };

  const [first, second] = await Promise.all([cache.get(load), cache.get(load)]);
  const third = await cache.get(load);

  assert.deepEqual([first, second, third], [42, 42, 42]);
  assert.equal(loads, 1);
});

test('async value cache retries after a failed load', async () => {
  const cache = new AsyncValueCache<number>();
  let loads = 0;
  const load = async () => {
    loads++;
    if (loads === 1) throw new Error('database unavailable');
    return 7;
  };

  await assert.rejects(cache.get(load), /database unavailable/);
  assert.equal(await cache.get(load), 7);
  assert.equal(loads, 2);
});

test('clearing an async value cache protects a newer load from an old rejection', async () => {
  const cache = new AsyncValueCache<number>();
  let rejectOld!: (error: Error) => void;
  let resolveNew!: (value: number) => void;
  const oldValue = new Promise<number>((_resolve, reject) => { rejectOld = reject; });
  const newValue = new Promise<number>((resolve) => { resolveNew = resolve; });

  const oldRequest = cache.get(() => oldValue);
  cache.clear();
  const newRequest = cache.get(() => newValue);
  rejectOld(new Error('old failure'));
  await assert.rejects(oldRequest, /old failure/);
  resolveNew(5);

  assert.equal(await newRequest, 5);
  assert.equal(await cache.get(async () => 99), 5);
});

test('replacing an async value cache swaps snapshots without an empty window', async () => {
  const cache = new AsyncValueCache<number>();
  assert.equal(await cache.get(async () => 1), 1);

  cache.replace(2);

  assert.equal(await cache.get(async () => 99), 2);
});
