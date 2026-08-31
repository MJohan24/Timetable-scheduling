type Environment = Record<string, string | undefined>;

export interface ProductionConfigReport {
  errors: string[];
  warnings: string[];
}

export interface FeatureReadiness {
  assistant: boolean;
  payment: boolean;
  realtimeTracking: boolean;
}

const isLocalHost = (hostname: string) =>
  hostname === 'localhost' ||
  hostname === '127.0.0.1' ||
  hostname === '::1' ||
  hostname.endsWith('.local');

const isHttpsUrl = (value: string | undefined) => {
  if (!value) return false;
  try {
    return new URL(value).protocol === 'https:';
  } catch {
    return false;
  }
};

export const getFeatureReadiness = (
  environment: Environment = process.env,
): FeatureReadiness => ({
  assistant: (environment.GEMINI_API_KEY?.trim().length ?? 0) >= 10,
  payment:
    (environment.XENDIT_SECRET_KEY?.trim().length ?? 0) >= 20 &&
    Boolean(environment.XENDIT_WEBHOOK_TOKEN?.trim()),
  realtimeTracking: Boolean(environment.KAI_REALTIME_API_URL?.trim()),
});

export const inspectProductionConfig = (
  environment: Environment,
): ProductionConfigReport => {
  const errors: string[] = [];
  const warnings: string[] = [];
  const databaseUrl = environment.DATABASE_URL?.trim();
  const jwtSecret = environment.JWT_SECRET?.trim();
  const ticketSecret = environment.TICKET_QR_SECRET?.trim();
  const corsOrigins = environment.CORS_ORIGINS?.trim();
  const geminiApiKey = environment.GEMINI_API_KEY?.trim();
  const xenditSecret = environment.XENDIT_SECRET_KEY?.trim();

  if (!databaseUrl) {
    errors.push('DATABASE_URL is required.');
  } else {
    try {
      const parsed = new URL(databaseUrl);
      if (!['postgres:', 'postgresql:'].includes(parsed.protocol)) {
        errors.push('DATABASE_URL must use the PostgreSQL protocol.');
      }
      if (isLocalHost(parsed.hostname)) {
        errors.push('DATABASE_URL must not point to a local host in production.');
      }
      if (parsed.searchParams.get('sslmode') !== 'require') {
        warnings.push('DATABASE_URL should require TLS with sslmode=require.');
      }
    } catch {
      errors.push('DATABASE_URL must be a valid PostgreSQL URL.');
    }
  }

  if (!jwtSecret || jwtSecret.length < 32) {
    errors.push('JWT_SECRET must contain at least 32 characters.');
  }

  if (!ticketSecret) {
    warnings.push('TICKET_QR_SECRET is missing; ticket QR signing will fall back to JWT_SECRET.');
  } else if (ticketSecret.length < 32) {
    errors.push('TICKET_QR_SECRET must contain at least 32 characters.');
  }

  if (!corsOrigins) {
    warnings.push('CORS_ORIGINS is not set; the API will accept every origin.');
  } else if (corsOrigins.split(',').some((origin) => origin.trim() === '*')) {
    warnings.push('CORS_ORIGINS allows every origin; restrict it before a production launch.');
  }

  if (!geminiApiKey || geminiApiKey.length < 10) {
    warnings.push('GEMINI_API_KEY is missing; chat and vision will return AI_NOT_CONFIGURED.');
  }

  if (!xenditSecret) {
    warnings.push('XENDIT_SECRET_KEY is missing; payment checkout will be unavailable.');
  } else {
    if (!environment.XENDIT_WEBHOOK_TOKEN?.trim()) {
      errors.push('XENDIT_WEBHOOK_TOKEN is required when Xendit payment is enabled.');
    }
    if (!isHttpsUrl(environment.XENDIT_SUCCESS_RETURN_URL?.trim())) {
      warnings.push('XENDIT_SUCCESS_RETURN_URL should be a public HTTPS URL.');
    }
    if (!isHttpsUrl(environment.XENDIT_CANCEL_RETURN_URL?.trim())) {
      warnings.push('XENDIT_CANCEL_RETURN_URL should be a public HTTPS URL.');
    }
  }

  return { errors, warnings };
};

export const validateProductionConfig = (
  environment: Environment = process.env,
): ProductionConfigReport => {
  const report = inspectProductionConfig(environment);
  if (report.errors.length > 0) {
    throw new Error(`Production configuration invalid: ${report.errors.join(' ')}`);
  }
  return report;
};
