import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { EmailModule } from './email/email.module';
import { NotificationsController } from './notifications.controller';

@Module({
  imports: [ConfigModule, EmailModule],
  controllers: [NotificationsController],
  exports: [EmailModule],
})
export class NotificationsModule {}
