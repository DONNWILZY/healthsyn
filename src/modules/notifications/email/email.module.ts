import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { EMAIL_TRANSPORT } from './email.constants';
import { SmtpEmailProvider } from './providers/smtp.provider';
import { EmailDispatcherService } from './services/email-dispatcher.service';
import { EmailLogService } from './services/email-log.service';
import { EmailRendererService } from './services/email-renderer.service';
import { EmailTemplateService } from './services/email-template.service';
import { TransactionalEmailService } from './services/transactional-email.service';
import { PrismaModule } from '../../../prisma/prisma.module';

@Module({
  imports: [ConfigModule, PrismaModule],
  providers: [
    SmtpEmailProvider,
    EmailTemplateService,
    EmailRendererService,
    EmailDispatcherService,
    EmailLogService,
    TransactionalEmailService,
    {
      provide: EMAIL_TRANSPORT,
      useExisting: SmtpEmailProvider,
    },
  ],
  exports: [
    EmailDispatcherService,
    EmailRendererService,
    EmailTemplateService,
    TransactionalEmailService,
  ],
})
export class EmailModule {}
