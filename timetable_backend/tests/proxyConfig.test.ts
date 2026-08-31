import assert from 'node:assert/strict';
import test from 'node:test';

import app from '../src/app';

test('trusts the single Render proxy used for client IP rate limiting', () => {
  assert.equal(app.get('trust proxy'), 1);
});
