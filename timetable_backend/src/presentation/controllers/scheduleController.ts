import { NextFunction, Request, Response } from 'express';
import { z } from 'zod';
import { prisma } from '../../infrastructure/database/prismaClient';
import { ApiError } from '../../domain/errors/ApiError';
import {
  publicCodeForLine,
  stationDisplayName,
} from '../../domain/services/stationIdentity';
import { beginTiming, measurePhase } from '../../infrastructure/observability/requestTiming';
import { findStationInCatalog, getStationCatalog } from '../../domain/services/stationCatalogService';
import { getTimetableReadModel, queryTimetableReadModel } from '../../domain/services/timetableReadModel';

const querySchema = z.object({
  stationId: z.string().uuid().optional(),
  station: z.string().trim().min(1).optional(),
  trainType: z.enum(['KRL', 'LRT', 'MRT']).optional(),
  isWeekend: z.enum(['true', 'false']).optional(),
  departureFrom: z.string().regex(/^\d{2}:\d{2}$/).optional(),
  departureTo: z.string().regex(/^\d{2}:\d{2}$/).optional(),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(30),
});

const normalize = (value: string) => value.toLowerCase().replace(/[^a-z0-9]/g, '');
const toMinute = (value: string) => {
  const [hour, minute] = value.split(':').map(Number);
  return hour * 60 + minute;
};
const formatMinute = (value: number) =>
  `${String(Math.floor((value % 1440) / 60)).padStart(2, '0')}:${String(value % 60).padStart(2, '0')}`;

export const getSchedules = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const parsed = querySchema.safeParse(req.query);
    if (!parsed.success || (!parsed.data.stationId && !parsed.data.station)) {
      throw new ApiError(
        400,
        'stationId or station name/code is required',
        'VALIDATION_ERROR',
        parsed.success ? undefined : parsed.error.issues,
      );
    }
    const { stationId, station, trainType, isWeekend, departureFrom, departureTo, page, limit } = parsed.data;
    const finishCatalog = beginTiming('schedule_catalog');
    const [catalog, readModel] = await Promise.all([
      getStationCatalog(),
      trainType !== 'LRT' && trainType !== 'MRT' ? getTimetableReadModel() : null,
    ]);
    const timetableStation = findStationInCatalog(catalog, stationId ?? station!);
    finishCatalog();

    const expectsCommuterTimetable = timetableStation?.isKrl
      && trainType !== 'LRT'
      && trainType !== 'MRT';
    if (expectsCommuterTimetable && !readModel) {
      throw new ApiError(503, 'Commuter timetable is unavailable.', 'TIMETABLE_UNAVAILABLE');
    }

    if (expectsCommuterTimetable && readModel) {
      const result = await measurePhase('schedule_query', async () => queryTimetableReadModel(
        readModel,
        timetableStation.id,
        {
          isWeekend: isWeekend === 'true',
          departureFromMinute: departureFrom ? toMinute(departureFrom) : undefined,
          departureToMinute: departureTo ? toMinute(departureTo) : undefined,
          page,
          limit,
        },
      ));
      res.json({
        success: true,
        data: result.departures.map((departure) => ({
          id: departure.id,
          trainName: `KA ${departure.trainNumber}`,
          trainNumber: departure.trainNumber,
          continuationTrainNumber: departure.continuationTrainNumber,
          route: departure.route,
          departureTime: formatMinute(departure.departureMinute),
          arrivalTime: formatMinute(departure.arrivalMinute),
          dayOffset: Math.floor(departure.departureMinute / 1440),
          platform: departure.platform,
          trainType: 'KRL',
          isWeekend: isWeekend === 'true',
          calendarCode: departure.calendarCode,
          lineSlug: departure.lineSlug,
          station: {
            id: timetableStation.id,
            slug: timetableStation.slug,
            name: stationDisplayName(timetableStation),
            operationalCode: timetableStation.operationalCode,
          },
        })),
        meta: {
          page,
          limit,
          total: result.total,
          datasetVersion: readModel.datasetVersion,
        },
      });
      return;
    }

    const where = {
      ...(stationId ? { stationId } : {}),
      ...(station
        ? {
            station: {
              OR: [
                { name: { contains: station, mode: 'insensitive' as const } },
                { officialName: { contains: station, mode: 'insensitive' as const } },
                { operationalCode: { equals: station, mode: 'insensitive' as const } },
                { aliases: { some: { normalized: normalize(station) } } },
                { publicCodes: { some: { code: { equals: station } } } },
              ],
            },
          }
        : {}),
      ...(trainType ? { trainType } : {}),
      ...(isWeekend ? { isWeekend: isWeekend === 'true' } : {}),
      ...(departureFrom || departureTo
        ? {
            departureTime: {
              ...(departureFrom ? { gte: departureFrom } : {}),
              ...(departureTo ? { lte: departureTo } : {}),
            },
          }
        : {}),
    };
    const [schedules, total] = await measurePhase('schedule_query', () => prisma.$transaction([
      prisma.schedule.findMany({
        where,
        include: {
          station: { include: { nodes: true, lines: true, publicCodes: true } },
        },
        orderBy: { departureTime: 'asc' },
        skip: (page - 1) * limit,
        take: limit,
      }),
      prisma.schedule.count({ where }),
    ]));
    res.json({
      success: true,
      data: schedules.map(({ station: scheduleStation, ...schedule }) => ({
        ...schedule,
        station: {
          id: scheduleStation.id,
          slug: scheduleStation.slug,
          name: stationDisplayName(scheduleStation),
          shortName: scheduleStation.name,
          officialName: stationDisplayName(scheduleStation),
          operationalCode: scheduleStation.operationalCode,
          isBoardingAllowed: scheduleStation.isBoardingAllowed,
          isTransit: scheduleStation.isTransit,
          isAccessible: scheduleStation.isAccessible,
          isLrt: scheduleStation.isLrt,
          isKrl: scheduleStation.isKrl,
          isMrt: scheduleStation.isMrt,
          lineInfo: scheduleStation.lineInfo,
          statusText: scheduleStation.statusText,
          statusColor: scheduleStation.statusColor,
          lines: scheduleStation.lines,
          publicCodes: scheduleStation.publicCodes,
          nodes: scheduleStation.nodes.map(({ nodeKey: _nodeKey, ...node }) => {
            const publicCode = publicCodeForLine(scheduleStation, node.lineId);
            return { ...node, code: publicCode, publicCode };
          }),
        },
      })),
      meta: { page, limit, total },
    });
  } catch (error) {
    next(error);
  }
};
