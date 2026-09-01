import { NextFunction, Request, Response } from 'express';
import { z } from 'zod';
import { prisma } from '../../infrastructure/database/prismaClient';
import { ApiError } from '../../domain/errors/ApiError';
import { measurePhase } from '../../infrastructure/observability/requestTiming';
import {
  publicCodeForLine,
  stationDisplayName,
} from '../../domain/services/stationIdentity';
import {
  CatalogStation,
  filterStationCatalog,
  getStationCatalog,
} from '../../domain/services/stationCatalogService';

const stationQuerySchema = z.object({
  q: z.string().trim().min(1).optional(),
  service: z.enum(['KRL', 'LRT', 'MRT']).optional(),
  accessible: z.enum(['true', 'false']).optional(),
  transit: z.enum(['true', 'false']).optional(),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(200).default(50),
});

const stationDto = (station: CatalogStation) => ({
  id: station.id,
  slug: station.slug,
  name: stationDisplayName(station),
  shortName: station.name,
  officialName: stationDisplayName(station),
  operationalCode: station.operationalCode,
  isBoardingAllowed: station.isBoardingAllowed,
  isTransit: station.isTransit,
  isAccessible: station.isAccessible,
  isLrt: station.isLrt,
  isKrl: station.isKrl,
  isMrt: station.isMrt,
  lineInfo: station.lineInfo,
  statusText: station.statusText,
  statusColor: station.statusColor,
  aliases: station.aliases.map(({ name }) => name),
  publicCodes: station.publicCodes.map(({ code, lineId, line }) => ({
    code,
    lineId,
    line,
  })),
  lines: station.lines,
  nodes: station.nodes.map((node) => {
    const publicCode = publicCodeForLine(station, node.lineId);
    return { ...node, code: publicCode, publicCode };
  }),
});

export const getStations = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const parsed = stationQuerySchema.safeParse(req.query);
    if (!parsed.success) {
      throw new ApiError(400, 'Invalid station filters', 'VALIDATION_ERROR', parsed.error.issues);
    }
    const { q, service, accessible, transit, page, limit } = parsed.data;
    const result = await measurePhase('station_query', async () => {
      const catalog = await getStationCatalog();
      const { stations, total } = filterStationCatalog(catalog, {
        q,
        service,
        accessible: accessible === undefined ? undefined : accessible === 'true',
        transit: transit === undefined ? undefined : transit === 'true',
        page,
        limit,
      });
      return { data: stations.map(stationDto), meta: { page, limit, total } };
    });
    res.json({
      success: true,
      ...result,
    });
  } catch (error) {
    next(error);
  }
};

export const searchStation = getStations;

export const getNetwork = async (_req: Request, res: Response, next: NextFunction) => {
  try {
    const lines = await prisma.line.findMany({
      where: { slug: { not: null } },
      include: {
        nodes: {
          include: {
            station: {
              select: {
                id: true,
                slug: true,
                name: true,
                officialName: true,
                isTransit: true,
                isAccessible: true,
                publicCodes: { select: { lineId: true, code: true } },
              },
            },
          },
          orderBy: { sequence: 'asc' },
        },
      },
      orderBy: { name: 'asc' },
    });
    res.json({
      success: true,
      data: {
        lines: lines.map((line) => ({
          ...line,
          nodes: line.nodes.map(({ station, ...node }) => {
            const publicCode = publicCodeForLine(station, node.lineId);
            return {
              id: node.id,
              mapId: node.mapId,
              code: publicCode,
              publicCode,
              sequence: node.sequence,
              mapX: node.mapX,
              mapY: node.mapY,
              stationId: node.stationId,
              lineId: node.lineId,
              station: {
                id: station.id,
                slug: station.slug,
                name: stationDisplayName(station),
                shortName: station.name,
                isTransit: station.isTransit,
                isAccessible: station.isAccessible,
              },
            };
          }),
        })),
      },
    });
  } catch (error) {
    next(error);
  }
};
