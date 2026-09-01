import assert from 'node:assert/strict';
import { test } from 'node:test';
import {
  assertTransitReadModelsLoaded,
  RuntimeReadiness,
} from '../src/infrastructure/readiness/runtimeReadiness';

test('runtime readiness stays unavailable until every read model is warm', () => {
  const readiness = new RuntimeReadiness(['routeGraph', 'stationCatalog', 'timetable']);

  readiness.markReady('routeGraph');
  readiness.markReady('stationCatalog');
  assert.equal(readiness.isReady(), false);
  assert.deepEqual(readiness.missing(), ['timetable']);

  readiness.markReady('timetable');
  assert.equal(readiness.isReady(), true);
  readiness.markUnavailable('stationCatalog');
  assert.equal(readiness.isReady(), false);
});

test('runtime warm-up rejects empty transit read models', () => {
  assert.throws(() => assertTransitReadModelsLoaded({
    routeConnections: [], stations: [{}], timetableStationCount: 1,
  }), /route graph/i);
  assert.throws(() => assertTransitReadModelsLoaded({
    routeConnections: [{}], stations: [], timetableStationCount: 1,
  }), /station catalog/i);
  assert.throws(() => assertTransitReadModelsLoaded({
    routeConnections: [{}], stations: [{}], timetableStationCount: 0,
  }), /timetable/i);
});
