import { registerAs } from '@nestjs/config';

export default registerAs('throttling', () => ({
  ttlMs: Number(process.env.THROTTLE_TTL_MS ?? 60_000),
  limit: Number(process.env.THROTTLE_LIMIT ?? 100),
}));
