import { Prisma } from '@prisma/client';
import { prisma } from '../../infrastructure/database/prismaClient';
import { AsyncValueCache } from '../../infrastructure/cache/asyncValueCache';

const stationCatalogInclude = {
  aliases: { select: { name: true, normalized: true } },
  lines: {
    select: { id: true, slug: true, name: true, color: true, serviceType: true },
  },
  publicCodes: {
    select: {
      code: true,
      lineId: true,
      line: { select: { slug: true, name: true, serviceType: true } },
    },
    orderBy: { code: 'asc' as const },
  },
  nodes: {
    select: {
      id: true,
      nodeKey: true,
      mapId: true,
      sequence: true,
      mapX: true,
      mapY: true,
      lineId: true,
    },
  },
} satisfies Prisma.StationInclude;

export type CatalogStation = Prisma.StationGetPayload<{
  include: typeof stationCatalogInclude;
}>;

export interface StationCatalogFilter {
  q?: string;
  service?: 'KRL' | 'LRT' | 'MRT';
  accessible?: boolean;
  transit?: boolean;
  page: number;
  limit: number;
}

const catalogCache = new AsyncValueCache<CatalogStation[]>();
const normalize = (value: string) => value.toLowerCase().replace(/[^a-z0-9]/g, '');

function loadStationCatalog() {
  return prisma.station.findMany({
    include: stationCatalogInclude,
    orderBy: { name: 'asc' },
  });
}

export function getStationCatalog() {
  return catalogCache.get(loadStationCatalog);
}

export function clearStationCatalog() {
  catalogCache.clear();
}

export function findStationInCatalog(
  catalog: readonly CatalogStation[],
  identifier: string,
  routeScope = false,
) {
  const lower = identifier.toLowerCase();
  const normalized = normalize(identifier);
  const scoped = routeScope
    ? catalog.filter((station) => station.slug != null && station.isBoardingAllowed)
    : catalog;
  return scoped.find((station) => (
    station.id === identifier
    || station.slug?.toLowerCase() === lower
    || station.operationalCode?.toLowerCase() === lower
    || station.publicCodes.some(({ code }) => code.toLowerCase() === lower)
  )) ?? scoped.find((station) => (
    station.name.toLowerCase() === lower
    || station.officialName?.toLowerCase() === lower
    || station.nodes.some(({ nodeKey }) => nodeKey.toLowerCase() === lower)
    || station.aliases.some((alias) => alias.normalized === normalized)
  ));
}

export function filterStationCatalog(
  catalog: readonly CatalogStation[],
  filter: StationCatalogFilter,
) {
  const normalizedQuery = filter.q ? normalize(filter.q) : undefined;
  const lowerQuery = filter.q?.toLowerCase();
  const stations = catalog.filter((station) => {
    if (station.slug == null || !station.isBoardingAllowed) return false;
    if (filter.service === 'KRL' && !station.isKrl) return false;
    if (filter.service === 'LRT' && !station.isLrt) return false;
    if (filter.service === 'MRT' && !station.isMrt) return false;
    if (filter.accessible !== undefined && station.isAccessible !== filter.accessible) return false;
    if (filter.transit !== undefined && station.isTransit !== filter.transit) return false;
    if (!lowerQuery || !normalizedQuery) return true;
    return station.name.toLowerCase().includes(lowerQuery)
      || station.officialName?.toLowerCase().includes(lowerQuery) === true
      || station.operationalCode?.toLowerCase() === lowerQuery
      || station.aliases.some((alias) => alias.normalized.includes(normalizedQuery))
      || station.publicCodes.some(({ code }) => code.toLowerCase() === lowerQuery);
  });
  const start = (filter.page - 1) * filter.limit;
  return {
    stations: stations.slice(start, start + filter.limit),
    total: stations.length,
  };
}
