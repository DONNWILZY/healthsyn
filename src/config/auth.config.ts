import { registerAs } from '@nestjs/config';

export default registerAs('auth', () => ({
  jwtIssuer: process.env.JWT_ISSUER ?? 'health-syn',
  jwtAudience: process.env.JWT_AUDIENCE ?? 'health-syn-clients',
  accessTokenTtlMinutes: Number(process.env.ACCESS_TOKEN_TTL_MINUTES ?? 15),
  refreshTokenTtlDays: Number(process.env.REFRESH_TOKEN_TTL_DAYS ?? 30),
}));
