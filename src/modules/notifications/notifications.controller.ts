import { Body, Controller, Post } from '@nestjs/common';
import { SendPasswordResetEmailDto } from './dto/send-password-reset-email.dto';
import { TransactionalEmailService } from './email/services/transactional-email.service';

@Controller('notifications')
export class NotificationsController {
  constructor(
    private readonly transactionalEmailService: TransactionalEmailService,
  ) {}

  @Post('password-reset')
  async sendPasswordResetEmail(@Body() body: SendPasswordResetEmailDto) {
    const logId = await this.transactionalEmailService.sendPasswordResetEmail({
      to: body.to,
      firstName: body.firstName,
      resetCode: body.resetCode,
      organizationId: body.organizationId,
    });

    return {
      status: 'queued',
      logId,
    };
  }
}
