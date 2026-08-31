import assert from 'node:assert/strict';
import test from 'node:test';
import {
  getFeatureReadiness,
  inspectProductionConfig,
  validateProductionConfig,
} from '../src/config/productionConfig';

const validEnvironment = {
  DATABASE_URL:
    'postgresql://user:database-password@ep-example.ap-southeast-1.aws.neon.tech/app?sslmode=require',
  JWT_SECRET: 'jwt-secret-that-is-at-least-thirty-two-characters',
  TICKET_QR_SECRET: 'ticket-secret-that-is-at-least-thirty-two-characters',
  CORS_ORIGINS: '*',
  GEMINI_API_KEY: 'gemini-example-key',
  XENDIT_SECRET_KEY: 'xnd_development_example_secret_key',
  XENDIT_WEBHOOK_TOKEN: 'xendit-example-webhook-token',
  XENDIT_SUCCESS_RETURN_URL: 'https://example.com/payment/success',
  XENDIT_CANCEL_RETURN_URL: 'https://example.com/payment/cancel',
};

test('production config accepts a complete Neon deployment', () => {
  const result = inspectProductionConfig(validEnvironment);

  assert.deepEqual(result.errors, []);
  assert.deepEqual(result.warnings, [
    'CORS_ORIGINS allows every origin; restrict it before a production launch.',
  ]);
});

test('production config rejects local database and weak JWT without exposing values', () => {
  const environment = {
    DATABASE_URL: 'postgresql://postgres:private-password@localhost:5432/app',
    JWT_SECRET: 'short-secret',
  };

  const result = inspectProductionConfig(environment);
  const report = [...result.errors, ...result.warnings].join(' ');

  assert.match(report, /DATABASE_URL/);
  assert.match(report, /JWT_SECRET/);
  assert.doesNotMatch(report, /private-password/);
  assert.doesNotMatch(report, /short-secret/);
  assert.throws(() => validateProductionConfig(environment), /DATABASE_URL.*JWT_SECRET/s);
});

test('production config keeps optional AI and payment gaps as warnings', () => {
  const result = inspectProductionConfig({
    DATABASE_URL: validEnvironment.DATABASE_URL,
    JWT_SECRET: validEnvironment.JWT_SECRET,
    CORS_ORIGINS: 'https://app.example.com',
  });

  assert.deepEqual(result.errors, []);
  assert.ok(result.warnings.some((warning) => warning.includes('TICKET_QR_SECRET')));
  assert.ok(result.warnings.some((warning) => warning.includes('GEMINI_API_KEY')));
  assert.ok(result.warnings.some((warning) => warning.includes('XENDIT_SECRET_KEY')));
});

test('production config requires a webhook token when Xendit is enabled', () => {
  const result = inspectProductionConfig({
    ...validEnvironment,
    XENDIT_WEBHOOK_TOKEN: '',
  });

  assert.ok(result.errors.some((error) => error.includes('XENDIT_WEBHOOK_TOKEN')));
});

test('feature readiness exposes booleans without secret values', () => {
  assert.deepEqual(getFeatureReadiness(validEnvironment), {
    assistant: true,
    payment: true,
    realtimeTracking: false,
  });
  assert.deepEqual(getFeatureReadiness({}), {
    assistant: false,
    payment: false,
    realtimeTracking: false,
  });
});
