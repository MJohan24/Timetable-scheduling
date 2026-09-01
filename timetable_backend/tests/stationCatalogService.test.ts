import assert from 'node:assert/strict';
import { test } from 'node:test';
import {
  CatalogStation,
  filterStationCatalog,
  findStationInCatalog,
} from '../src/domain/services/stationCatalogService';

const station = (overrides: Partial<CatalogStation>): CatalogStation => ({
  id: 'station-1', slug: 'manggarai', operationalCode: 'MRI', nodeCode: null,
  name: 'Manggarai', officialName: 'Manggarai', isBoardingAllowed: true,
  isTransit: true, isAccessible: true, isLrt: false, isKrl: true, isMrt: false,
  lineInfo: null, statusText: null, statusColor: null,
  createdAt: new Date(0), updatedAt: new Date(0),
  aliases: [{ name: 'Stasiun Manggarai', normalized: 'stasiunmanggarai' }],
  lines: [],
  publicCodes: [{ code: 'MRI', lineId: 'bogor', line: { slug: 'bogor', name: 'Bogor', serviceType: 'KRL' } }],
  nodes: [{ id: 'node-1', nodeKey: 'krl-mri', mapId: 'MRI', sequence: 1, mapX: 0, mapY: 0, lineId: 'bogor' }],
  ...overrides,
});

test('station catalog filters and paginates without a database query', () => {
  const catalog = [
    station({}),
    station({ id: 'station-2', slug: 'tebet', operationalCode: 'TEB', name: 'Tebet', officialName: 'Tebet', aliases: [], publicCodes: [] }),
    station({ id: 'station-3', slug: 'dukuh-atas', name: 'Dukuh Atas', officialName: 'Dukuh Atas', isKrl: false, isLrt: true, aliases: [], publicCodes: [] }),
  ];

  const result = filterStationCatalog(catalog, { q: 'mang', service: 'KRL', page: 1, limit: 20 });

  assert.equal(result.total, 1);
  assert.equal(result.stations[0].slug, 'manggarai');
});

test('station catalog resolves aliases and enforces route boarding scope', () => {
  const operational = station({
    id: 'station-2', slug: 'gambir', operationalCode: 'GMR', name: 'Gambir',
    officialName: 'Gambir', isBoardingAllowed: false,
    aliases: [{ name: 'Stasiun Gambir', normalized: 'stasiungambir' }], publicCodes: [],
  });
  const catalog = [station({}), operational];

  assert.equal(findStationInCatalog(catalog, 'Stasiun Manggarai')?.id, 'station-1');
  assert.equal(findStationInCatalog(catalog, 'GMR')?.id, 'station-2');
  assert.equal(findStationInCatalog(catalog, 'GMR', true), undefined);
});
