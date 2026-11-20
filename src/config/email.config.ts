import { registerAs } from '@nestjs/config';
import { resolve } from 'path';

export default registerAs('email', () => ({
  enabled: ['true', '1', 'yes', 'on'].includes(
    (
      process.env.EMAIL_ENABLED?.trim() ||
      (process.env.SMTP_HOST?.trim() ? 'true' : 'false')
    ).toLowerCase(),
  ),
  provider: process.env.EMAIL_PROVIDER ?? 'SMTP',
  fromName:
    process.env.EMAIL_FROM_NAME ??
    process.env.SMTP_FROM_NAME ??
    'HealthSync Pro',
  fromAddress:
    process.env.EMAIL_FROM_ADDRESS ??
    process.env.SMTP_FROM_EMAIL ??
    'no-reply@healthsync.local',
  replyTo: process.env.EMAIL_REPLY_TO,
  host: process.env.EMAIL_HOST ?? process.env.SMTP_HOST,
  port: Number(process.env.EMAIL_PORT ?? process.env.SMTP_PORT ?? 587),
  secure: ['true', '1', 'yes', 'on'].includes(
    (process.env.EMAIL_SECURE ?? 'false').toLowerCase(),
  ),
  user: process.env.EMAIL_USER ?? process.env.SMTP_USERNAME,
  password: process.env.EMAIL_PASSWORD ?? process.env.SMTP_PASSWORD,
  templatesDir: process.env.EMAIL_TEMPLATES_DIR
    ? resolve(process.env.EMAIL_TEMPLATES_DIR)
    : resolve(__dirname, '../modules/notifications/email/templates'),
}));
