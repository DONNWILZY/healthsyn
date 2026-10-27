import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import appConfig from './config/app.config';
import authConfig from './config/auth.config';
import databaseConfig from './config/database.config';
import emailConfig from './config/email.config';
import storageConfig from './config/storage.config';
import throttlingConfig from './config/throttling.config';
import { validateEnv } from './config/env.validation';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      expandVariables: true,
      validate: validateEnv,
      load: [
        appConfig,
        authConfig,
        databaseConfig,
        emailConfig,
        storageConfig,
        throttlingConfig,
      ],
    }),
    ThrottlerModule.forRootAsync({
      inject: [throttlingConfig.KEY],
      useFactory: (config: ReturnType<typeof throttlingConfig>) => [
        {
          ttl: config.ttlMs,
          limit: config.limit,
        },
      ],
    }),
    PrismaModule,
    NotificationsModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule {}
