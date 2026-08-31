import { prisma } from '../../infrastructure/database/prismaClient';
import { ApiError } from '../errors/ApiError';
import { FareService } from './fareService';
import { publicCodeForLine, stationDisplayName } from './stationIdentity';
import { beginTiming, measurePhase } from '../../infrastructure/observability/requestTiming';

type RouteStepKind = 'board' | 'transfer' | 'continue' | 'arrive';

interface RouteStep {
  kind: RouteStepKind;
  isWalking: boolean;
  text: string;
  durationText: string;
  detailNote: string;
  icon: string;
  color: string;
  isHeader: boolean;
  isTransit: boolean;
  isDestination: boolean;
}

export interface RoutePlanResult {
  from: string;
  to: string;
  travelTime: number;
  fare: number;
  unitFare: number;
  currency: 'IDR';
  passengerCount: number;
  stops: number;
  serviceInfo: string;
  hasTransit: boolean;
  transferCount: number;
  preference: RoutePreference;
  steps: RouteStep[];
  stationSequence: Array<{
    stationId: string;
    name: string;
    nodeCode: string | null;
    line: { id: string; slug: string | null; name: string; color: string; serviceType: string };
  }>;
  exitGateA: string;
  exitGateB: string;
}

const normalize = (value: string) => value.toLowerCase().replace(/[^a-z0-9]/g, '');

export type RoutePreference = 'FASTEST' | 'MIN_TRANSFERS';
type RouteCost = { minutes: number; transfers: number };
type QueueItem = { id: string; cost: RouteCost };
const compareCost = (a: RouteCost, b: RouteCost, preference: RoutePreference) =>
  preference === 'MIN_TRANSFERS'
    ? a.transfers - b.transfers || a.minutes - b.minutes
    : a.minutes - b.minutes || a.transfers - b.transfers;
const pushQueue = (heap: QueueItem[], item: QueueItem, preference: RoutePreference) => {
  heap.push(item);
  for (let index = heap.length - 1; index > 0; ) {
    const parent = Math.floor((index - 1) / 2);
    if (compareCost(heap[parent].cost, heap[index].cost, preference) <= 0) break;
    [heap[parent], heap[index]] = [heap[index], heap[parent]];
    index = parent;
  }
};
const popQueue = (heap: QueueItem[], preference: RoutePreference) => {
  const first = heap[0];
  const last = heap.pop();
  if (!first || !last || heap.length === 0) return first;
  heap[0] = last;
  for (let index = 0; ; ) {
    const left = index * 2 + 1;
    const right = left + 1;
    let smallest = index;
    if (left < heap.length && compareCost(heap[left].cost, heap[smallest].cost, preference) < 0) {
      smallest = left;
    }
    if (right < heap.length && compareCost(heap[right].cost, heap[smallest].cost, preference) < 0) {
      smallest = right;
    }
    if (smallest === index) break;
    [heap[index], heap[smallest]] = [heap[smallest], heap[index]];
    index = smallest;
  }
  return first;
};

export class RouteService {
  static async resolveStation(identifier: string) {
    const identityScope = { slug: { not: null }, isBoardingAllowed: true } as const;
    const include = { nodes: true, publicCodes: true } as const;
    const exactStation = await prisma.station.findFirst({
      where: {
        ...identityScope,
        OR: [
          { id: identifier },
          { slug: identifier.toLowerCase() },
          { operationalCode: { equals: identifier, mode: 'insensitive' } },
          { publicCodes: { some: { code: { equals: identifier } } } },
        ],
      },
      include,
    });
    if (exactStation) return exactStation;

    const station = await prisma.station.findFirst({
      where: {
        ...identityScope,
        OR: [
          { name: { equals: identifier, mode: 'insensitive' } },
          { officialName: { equals: identifier, mode: 'insensitive' } },
          { nodes: { some: { nodeKey: { equals: identifier } } } },
          { aliases: { some: { normalized: normalize(identifier) } } },
        ],
      },
      include,
    });
    if (!station) {
      throw new ApiError(404, `Station not found: ${identifier}`, 'STATION_NOT_FOUND');
    }
    return station;
  }

  static async planRoute(
    fromIdentifier: string,
    toIdentifier: string,
    passengerCount = 1,
    preference: RoutePreference = 'FASTEST',
  ): Promise<RoutePlanResult> {
    const [fromStation, toStation] = await measurePhase('station_lookup', () => Promise.all([
      this.resolveStation(fromIdentifier),
      this.resolveStation(toIdentifier),
    ]));
    if (fromStation.id === toStation.id) {
      throw new ApiError(
        400,
        'Origin and destination cannot be the same',
        'SAME_ORIGIN_DESTINATION',
      );
    }

    const connections = await measurePhase('graph_load', () => prisma.routeConnection.findMany({
      include: {
        fromNode: {
          include: { station: { include: { publicCodes: true } }, line: true },
        },
        toNode: {
          include: { station: { include: { publicCodes: true } }, line: true },
        },
      },
    }));
    const finishDijkstra = beginTiming('dijkstra');
    const adjacency = new Map<string, typeof connections>();
    for (const connection of connections) {
      const outgoing = adjacency.get(connection.fromNodeId) ?? [];
      outgoing.push(connection);
      adjacency.set(connection.fromNodeId, outgoing);
    }

    const distance = new Map<string, RouteCost>();
    const previous = new Map<string, (typeof connections)[number]>();
    const visited = new Set<string>();
    const queue: QueueItem[] = [];
    for (const node of fromStation.nodes) {
      const cost = { minutes: 0, transfers: 0 };
      distance.set(node.id, cost);
      pushQueue(queue, { id: node.id, cost }, preference);
    }
    const destinationIds = new Set(toStation.nodes.map((node) => node.id));
    let reachedId: string | null = null;

    while (queue.length > 0) {
      const current = popQueue(queue, preference)!;
      const currentId = current.id;
      if (visited.has(currentId)) continue;
      visited.add(currentId);
      if (destinationIds.has(currentId)) {
        reachedId = currentId;
        break;
      }
      for (const connection of adjacency.get(currentId) ?? []) {
        if (visited.has(connection.toNodeId)) continue;
        const nextCost = {
          minutes: current.cost.minutes + connection.travelTime,
          transfers: current.cost.transfers + Number(connection.isTransfer),
        };
        const knownCost = distance.get(connection.toNodeId);
        if (!knownCost || compareCost(nextCost, knownCost, preference) < 0) {
          distance.set(connection.toNodeId, nextCost);
          previous.set(connection.toNodeId, connection);
          pushQueue(queue, { id: connection.toNodeId, cost: nextCost }, preference);
        }
      }
    }

    if (!reachedId) {
      finishDijkstra();
      throw new ApiError(
        422,
        `No connected route from ${stationDisplayName(fromStation)} to ${stationDisplayName(toStation)}`,
        'ROUTE_NOT_FOUND',
      );
    }

    const path: typeof connections = [];
    let cursor = reachedId;
    while (previous.has(cursor)) {
      const connection = previous.get(cursor)!;
      path.unshift(connection);
      cursor = connection.fromNodeId;
    }
    finishDijkstra();
    const originNode = path[0]?.fromNode;
    if (!originNode) {
      throw new ApiError(422, 'Route has no traversable connection', 'ROUTE_NOT_FOUND');
    }

    const sequenceNodes = [originNode, ...path.map((connection) => connection.toNode)];
    const stationSequence = sequenceNodes
      .filter((node, index, array) => index === 0 || node.stationId !== array[index - 1].stationId)
      .map((node) => ({
        stationId: node.station.id,
        name: stationDisplayName(node.station),
        nodeCode: publicCodeForLine(node.station, node.lineId),
        line: {
          id: node.line.id,
          slug: node.line.slug,
          name: node.line.name,
          color: node.line.color,
          serviceType: node.line.serviceType,
        },
      }));
    const travelTime = path.reduce((total, connection) => total + connection.travelTime, 0);
    const serviceConnections = path.filter((connection) => !connection.isTransfer).length;
    const fare = FareService.quote(Math.max(1, serviceConnections), passengerCount);
    const transferConnections = path.filter((connection) => connection.isTransfer);
    const steps: RouteStep[] = [];
    let legStartNode = originNode;
    let pathIndex = 0;
    let isFirstLeg = true;

    while (pathIndex < path.length) {
      const relativeTransferIndex = path
        .slice(pathIndex)
        .findIndex((connection) => connection.isTransfer);
      const transferIndex =
        relativeTransferIndex < 0 ? path.length : pathIndex + relativeTransferIndex;
      const legConnections = path.slice(pathIndex, transferIndex);
      const legEndNode = legConnections.at(-1)?.toNode ?? legStartNode;
      const legMinutes = legConnections.reduce(
        (total, connection) => total + connection.travelTime,
        0,
      );
      const startName = stationDisplayName(legStartNode.station);
      const endName = stationDisplayName(legEndNode.station);

      steps.push({
        kind: isFirstLeg ? 'board' : 'continue',
        isWalking: false,
        text: isFirstLeg ? `Naik dari ${startName}` : `Lanjut naik ${legStartNode.line.name}`,
        durationText: `${legMinutes} menit`,
        detailNote: isFirstLeg
          ? `${legStartNode.line.name} menuju ${endName}`
          : `Dari ${startName} menuju ${endName}`,
        icon: 'train',
        color: legStartNode.line.color,
        isHeader: isFirstLeg,
        isTransit: false,
        isDestination: false,
      });

      if (transferIndex === path.length) break;
      const transfer = path[transferIndex];
      const isWalking = transfer.fromNode.stationId !== transfer.toNode.stationId;
      steps.push({
        kind: 'transfer',
        isWalking,
        text: isWalking
          ? `Berjalan dari ${stationDisplayName(transfer.fromNode.station)} menuju Stasiun ${stationDisplayName(transfer.toNode.station)}`
          : `Pindah peron di ${stationDisplayName(transfer.fromNode.station)}`,
        durationText: `${transfer.travelTime} menit`,
        detailNote: `Pindah ke ${transfer.toNode.line.name}`,
        icon: isWalking ? 'directions_walk' : 'sync_alt',
        color: transfer.toNode.line.color,
        isHeader: false,
        isTransit: true,
        isDestination: false,
      });

      legStartNode = transfer.toNode;
      pathIndex = transferIndex + 1;
      isFirstLeg = false;
    }

    steps.push({
      kind: 'arrive',
      isWalking: false,
      text: `Tiba di ${stationDisplayName(toStation)}`,
      durationText: `${travelTime} menit`,
      detailNote: 'Tujuan',
      icon: 'place',
      color: '#DC2626',
      isHeader: false,
      isTransit: false,
      isDestination: true,
    });

    return {
      from: stationDisplayName(fromStation),
      to: stationDisplayName(toStation),
      travelTime,
      fare: fare.totalPrice,
      unitFare: fare.unitPrice,
      currency: fare.currency,
      passengerCount: fare.passengerCount,
      stops: stationSequence.length - 1,
      serviceInfo: 'Layanan normal',
      hasTransit: transferConnections.length > 0,
      transferCount: transferConnections.length,
      preference,
      steps,
      stationSequence,
      exitGateA: 'Pintu utama',
      exitGateB: 'Area antar-jemput',
    };
  }
}
