import 'dotenv/config';
import assert from 'node:assert/strict';
import { after, test } from 'node:test';
import { RouteService } from '../src/domain/services/routeService';
import { prisma } from '../src/infrastructure/database/prismaClient';

after(() => prisma.$disconnect());

test('route planner can warm its computation path before accepting traffic', async () => {
  await assert.doesNotReject(RouteService.warmPlanning());
});

test('priority-queue Dijkstra follows mobile nodes and supports transfers', async () => {
  const fastest = await RouteService.planRoute('Bogor', 'Tangerang', 1, 'FASTEST');
  const minimumTransfers = await RouteService.planRoute(
    'Bogor',
    'Tangerang',
    1,
    'MIN_TRANSFERS',
  );

  for (const route of [fastest, minimumTransfers]) {
    assert.equal(route.stationSequence[0].name, 'Bogor');
    assert.equal(route.stationSequence.at(-1)?.name, 'Tangerang');
    assert.equal(route.hasTransit, true);
    assert.ok(route.travelTime > 0);
    assert.ok(route.stationSequence.some(({ line }) => line.slug === 'tangerang'));
    assert.equal(route.transferCount, route.steps.filter(({ isTransit }) => isTransit).length);
    assert.equal(route.steps[0].kind, 'board');
    assert.equal(route.steps.at(-1)?.kind, 'arrive');
    route.steps.forEach((step, index) => {
      if (step.kind === 'transfer') assert.equal(route.steps[index + 1]?.kind, 'continue');
    });
  }
  assert.equal(fastest.preference, 'FASTEST');
  assert.equal(minimumTransfers.preference, 'MIN_TRANSFERS');
  assert.ok(minimumTransfers.transferCount <= fastest.transferCount);
  if (minimumTransfers.transferCount === fastest.transferCount) {
    assert.ok(minimumTransfers.travelTime >= fastest.travelTime);
  }
});

test('Dijkstra models Cikoko to KRL Cawang as a five-minute pedestrian transfer', async () => {
  const route = await RouteService.planRoute('Cikoko', 'Tebet', 1, 'FASTEST');
  const walkingStep = route.steps.find(({ icon }) => icon === 'directions_walk');

  assert.equal(route.stationSequence[0].name, 'Cikoko');
  assert.equal(route.stationSequence.at(-1)?.name, 'Tebet');
  assert.equal(route.transferCount, 1);
  assert.equal(walkingStep?.text, 'Berjalan dari Cikoko menuju Stasiun Cawang');
  assert.equal(walkingStep?.durationText, '5 menit');
  assert.equal(walkingStep?.detailNote, 'Pindah ke KRL Lin Bogor');
  assert.equal(walkingStep?.kind, 'transfer');
  assert.equal(walkingStep?.isWalking, true);
  assert.deepEqual(route.steps.map(({ kind }) => kind), [
    'board',
    'transfer',
    'continue',
    'arrive',
  ]);
  assert.match(route.steps[2].text, /^Lanjut naik KRL Lin Bogor/);
  assert.ok(route.stationSequence.some(({ line }) => line.slug === 'bogor'));
});

test('Dijkstra distinguishes a same-station platform transfer from walking', async () => {
  const route = await RouteService.planRoute('Cikini', 'BNI City', 1, 'FASTEST');
  const transferStep = route.steps.find(({ isTransit }) => isTransit);

  assert.equal(transferStep?.kind, 'transfer');
  assert.equal(transferStep?.isWalking, false);
  assert.equal(transferStep?.icon, 'sync_alt');
  assert.match(transferStep?.text ?? '', /^Pindah peron di /);
});
