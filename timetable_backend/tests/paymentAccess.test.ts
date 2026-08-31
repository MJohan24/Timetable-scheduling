import assert from 'node:assert/strict';
import test from 'node:test';
import { ApiError } from '../src/domain/errors/ApiError';
import { assertTicketPaymentAccess } from '../src/domain/services/ticketAccessService';

const ownerAuth = {
  userId: '3f98079f-51f9-4422-9f65-b733150c29e7',
  role: 'REGISTERED' as const,
  sessionId: '86c97d13-e769-43da-aef3-91f8ab0ad40c',
};

const otherAuth = {
  userId: 'f6a113d8-39d6-483d-829c-6ac969a4e974',
  role: 'REGISTERED' as const,
  sessionId: 'ec02faee-b917-494e-a75e-d18657ea02ca',
};

test('registered owner can access ticket payment state', () => {
  assert.doesNotThrow(() =>
    assertTicketPaymentAccess(
      { userId: ownerAuth.userId, contactEmail: null },
      ownerAuth,
    ),
  );
});

test('different registered account cannot access ticket payment state', () => {
  assert.throws(
    () =>
      assertTicketPaymentAccess(
        { userId: ownerAuth.userId, contactEmail: null },
        otherAuth,
      ),
    (error: unknown) =>
      error instanceof ApiError &&
      error.statusCode === 403 &&
      error.code === 'TICKET_FORBIDDEN',
  );
});

test('guest email must match the ticket contact case-insensitively', () => {
  const ticket = { userId: null, contactEmail: 'Guest@Example.com' };

  assert.doesNotThrow(() =>
    assertTicketPaymentAccess(ticket, undefined, 'guest@example.com'),
  );
  assert.throws(
    () => assertTicketPaymentAccess(ticket, undefined, 'other@example.com'),
    (error: unknown) =>
      error instanceof ApiError && error.code === 'TICKET_FORBIDDEN',
  );
});

test('guest ticket rejects missing contact proof', () => {
  assert.throws(
    () =>
      assertTicketPaymentAccess(
        { userId: null, contactEmail: 'guest@example.com' },
        undefined,
      ),
    (error: unknown) =>
      error instanceof ApiError && error.code === 'TICKET_FORBIDDEN',
  );
});
