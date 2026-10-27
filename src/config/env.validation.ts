type EnvRecord = Record<string, string | undefined>;

function requireString(env: EnvRecord, key: string): string {
  const value = env[key]?.trim();
  if (!value) {
    throw new Error(`Missing required environment variable: ${key}`);
  }

  return value;
}

function optionalBoolean(env: EnvRecord, key: string, fallback: boolean): boolean {
  const value = env[key];
  if (value === undefined || value.trim() === '') {
    return fallback;
  }

  return ['true', '1', 'yes', 'on'].includes(value.toLowerCase());
}

function optionalNumber(env: EnvRecord, key: string, fallback: number): number {
  const value = env[key];
  if (value === undefined || value.trim() === '') {
    return fallback;
  }

  const parsed = Number(value);
  if (Number.isNaN(parsed)) {
    throw new Error(`Environment variable ${key} must be a number`);
  }

  return parsed;
}

export function validateEnv(env: EnvRecord): EnvRecord {
  requireString(env, 'DATABASE_URL');

  optionalNumber(env, 'PORT', 3000);
  optionalBoolean(env, 'EMAIL_ENABLED', false);
  optionalNumber(env, 'EMAIL_PORT', 587);
  optionalBoolean(env, 'EMAIL_SECURE', false);
  optionalNumber(env, 'THROTTLE_TTL_MS', 60_000);
  optionalNumber(env, 'THROTTLE_LIMIT', 100);

  return env;
}
