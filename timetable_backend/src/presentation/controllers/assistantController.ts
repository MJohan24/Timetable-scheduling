import { NextFunction, Request, Response } from 'express';
import { z } from 'zod';
import { ApiError } from '../../domain/errors/ApiError';
import {
  AssistantProviderError,
  AssistantService,
} from '../../domain/services/assistantService';
import { VisionService } from '../../domain/services/visionService';

const assistantHistoryTurnSchema = z.object({
  role: z.enum(['user', 'assistant']),
  text: z.string().trim().min(1).max(1000),
});

export const assistantMessageSchema = z.object({
  message: z.string().trim().min(1).max(1000),
  history: z.array(assistantHistoryTurnSchema).max(6).default([]),
});

const assistantService = new AssistantService();
const visionService = new VisionService();

export const askAssistant = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  const parsed = assistantMessageSchema.safeParse(req.body);
  if (!parsed.success) {
    next(new ApiError(400, 'Message must contain 1-1000 characters.', 'VALIDATION_ERROR'));
    return;
  }

  try {
    const reply = await assistantService.reply(parsed.data.message, parsed.data.history);
    res.json({ success: true, data: { reply } });
  } catch (error) {
    if (error instanceof AssistantProviderError) {
      const status = error.code === 'AI_NOT_CONFIGURED' ? 503 : 502;
      next(new ApiError(status, error.message, error.code));
      return;
    }
    next(error);
  }
};

export const analyzeVision = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  if (!Buffer.isBuffer(req.body) || req.body.length === 0) {
    next(new ApiError(400, 'Kirim gambar JPEG pada request body.', 'VALIDATION_ERROR'));
    return;
  }
  if (req.body.length > 1_048_576) {
    next(new ApiError(413, 'Ukuran gambar maksimal 1 MB.', 'PAYLOAD_TOO_LARGE'));
    return;
  }

  try {
    const result = await visionService.analyzeJpeg(req.body);
    res.json({ success: true, data: result });
  } catch (error) {
    if (error instanceof AssistantProviderError) {
      const status = error.code === 'AI_NOT_CONFIGURED' ? 503 : 502;
      next(new ApiError(status, error.message, error.code));
      return;
    }
    next(error);
  }
};
