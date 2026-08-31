const rawBaseUrl = process.env.API_BASE_URL ?? process.argv[2];
if (!rawBaseUrl) {
  console.error('Usage: npm run smoke:production -- https://<host>/api/v1');
  process.exit(2);
}

const apiBase = rawBaseUrl.replace(/\/+$/, '');
const apiUrl = new URL(`${apiBase}/`);
const serviceBase = new URL('/', apiUrl);
const requireAi = process.env.REQUIRE_AI === 'true';
const requirePayment = process.env.REQUIRE_PAYMENT === 'true';

const requestJson = async (label, url, options = {}) => {
  const response = await fetch(url, {
    ...options,
    headers: {
      Accept: 'application/json',
      ...(options.body ? { 'Content-Type': 'application/json' } : {}),
      ...options.headers,
    },
    signal: AbortSignal.timeout(35_000),
  });
  const payload = await response.json().catch(() => null);
  return { label, response, payload };
};

const assertSuccess = ({ label, response, payload }) => {
  if (!response.ok || payload?.success !== true) {
    const code = payload?.error?.code ?? `HTTP_${response.status}`;
    throw new Error(`${label} failed (${code}).`);
  }
  console.log(`PASS ${label}`);
  return payload;
};

const run = async () => {
  const ready = assertSuccess(
    await requestJson('readiness', new URL('ready', serviceBase)),
  );
  if (ready.data?.database !== 'connected') {
    throw new Error('readiness failed (database is not connected).');
  }
  if (requireAi && ready.data?.features?.assistant !== true) {
    throw new Error('readiness failed (assistant is not configured).');
  }
  if (requirePayment && ready.data?.features?.payment !== true) {
    throw new Error('readiness failed (payment is not configured).');
  }

  const stations = assertSuccess(
    await requestJson('stations', `${apiBase}/stations?limit=5`),
  );
  if (!Array.isArray(stations.data) || stations.data.length === 0) {
    throw new Error('stations failed (catalog is empty).');
  }

  const schedules = assertSuccess(
    await requestJson('February 2026 schedules', `${apiBase}/schedules?station=Manggarai&limit=5`),
  );
  if (!Array.isArray(schedules.data) || schedules.data.length === 0) {
    throw new Error('schedules failed (timetable is empty).');
  }
  if (!String(schedules.meta?.datasetVersion ?? '').startsWith('2026-02')) {
    throw new Error('schedules failed (February 2026 dataset is not active).');
  }

  assertSuccess(
    await requestJson('route Dukuh Atas to Cikoko', `${apiBase}/routes/plan`, {
      method: 'POST',
      body: JSON.stringify({
        from: 'Dukuh Atas',
        to: 'Cikoko',
        preference: 'FASTEST',
      }),
    }),
  );

  const assistant = await requestJson('assistant', `${apiBase}/assistant/chat`, {
    method: 'POST',
    body: JSON.stringify({ message: 'Bagaimana menuju Manggarai?' }),
  });
  if (assistant.response.ok && assistant.payload?.success === true) {
    console.log('PASS assistant');
  } else if (
    !requireAi &&
    assistant.response.status === 503 &&
    assistant.payload?.error?.code === 'AI_NOT_CONFIGURED'
  ) {
    console.log('PASS assistant (structured AI_NOT_CONFIGURED fallback)');
  } else {
    const code = assistant.payload?.error?.code ?? `HTTP_${assistant.response.status}`;
    throw new Error(`assistant failed (${code}).`);
  }
};

run().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
