import assert from 'node:assert/strict';
import { test } from 'node:test';
import {
  TimetableDeparture,
  TimetableReadModel,
  TimetableReadModelIdentity,
  queryTimetableReadModel,
  timetableIdentityChanged,
} from '../src/domain/services/timetableReadModel';

const departure = (overrides: Partial<TimetableDeparture>): TimetableDeparture => ({
  id: 'service-1', trainNumber: '1001', continuationTrainNumber: null,
  route: 'Bogor - Jakarta Kota', departureMinute: 360, arrivalMinute: 420,
  platform: '10', calendarCode: 'DAILY', lineSlug: 'bogor',
  ...overrides,
});

test('timetable read model filters calendar and time before pagination', () => {
  const model: TimetableReadModel = {
    datasetId: 'dataset-1', datasetVersion: '2026-02', dateKey: '2026-09-01',
    departuresByStationId: new Map([
      ['mri', [
        departure({ id: 'daily', departureMinute: 360 }),
        departure({ id: 'weekday', calendarCode: 'WEEKDAY', departureMinute: 370 }),
        departure({ id: 'late', departureMinute: 900 }),
      ]],
    ]),
  };

  const weekday = queryTimetableReadModel(model, 'mri', {
    isWeekend: false, departureFromMinute: 350, departureToMinute: 400, page: 1, limit: 10,
  });
  const weekend = queryTimetableReadModel(model, 'mri', {
    isWeekend: true, page: 1, limit: 10,
  });

  assert.deepEqual(weekday.departures.map(({ id }) => id), ['daily', 'weekday']);
  assert.equal(weekday.total, 2);
  assert.deepEqual(weekend.departures.map(({ id }) => id), ['daily', 'late']);
});

const identity = (overrides: Partial<TimetableReadModelIdentity> = {}): TimetableReadModelIdentity => ({
  datasetId: 'dataset-1', datasetUpdatedAt: '2026-09-01T00:00:00.000Z',
  sourceSha256: 'abc', timetableFingerprint: 'timetable-a',
  platformFingerprint: 'platform-a',
  dateKey: '2026-09-01',
  ...overrides,
});

test('timetable identity detects dataset, stop-time, platform, and date changes', () => {
  const current = identity();

  assert.equal(timetableIdentityChanged(current, identity()), false);
  assert.equal(timetableIdentityChanged(current, identity({ timetableFingerprint: 'timetable-b' })), true);
  assert.equal(timetableIdentityChanged(current, identity({ platformFingerprint: 'platform-b' })), true);
  assert.equal(timetableIdentityChanged(current, identity({ dateKey: '2026-09-02' })), true);
});
