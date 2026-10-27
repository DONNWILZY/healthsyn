import { registerAs } from '@nestjs/config';

export default registerAs('storage', () => ({
  bucket: process.env.STORAGE_BUCKET,
  region: process.env.STORAGE_REGION,
  endpoint: process.env.STORAGE_ENDPOINT,
}));
