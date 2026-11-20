import { Injectable } from '@nestjs/common';
import { EmailProvider } from '@prisma/client';
import { EmailDispatcherService } from './email-dispatcher.service';
import { EmailLogService } from './email-log.service';
import { EMAIL_TEMPLATES } from '../email.templates';

@Injectable()
export class TransactionalEmailService {
  constructor(
    private readonly dispatcher: EmailDispatcherService,
    private readonly emailLogService: EmailLogService,
  ) {}

  async sendWelcomeEmail(params: {
    to: string;
    firstName: string;
    organizationId?: string;
  }) {
    const descriptor = EMAIL_TEMPLATES.auth.welcome;
    return this.sendLoggedEmail({
      to: params.to,
      organizationId: params.organizationId,
      subject: descriptor.subject,
      template: descriptor.template,
      context: {
        firstName: params.firstName,
      },
    });
  }

  async sendPasswordResetEmail(params: {
    to: string;
    firstName: string;
    resetCode: string;
    organizationId?: string;
  }) {
    const descriptor = EMAIL_TEMPLATES.auth.passwordReset;
    return this.sendLoggedEmail({
      to: params.to,
      organizationId: params.organizationId,
      subject: descriptor.subject,
      template: descriptor.template,
      context: {
        firstName: params.firstName,
        resetCode: params.resetCode,
      },
      sensitive: true,
    });
  }

  async sendAppointmentReminderEmail(params: {
    to: string;
    firstName: string;
    providerName: string;
    appointmentDate: string;
    organizationName: string;
    organizationId?: string;
  }) {
    const descriptor = EMAIL_TEMPLATES.clinical.appointmentReminder;
    return this.sendLoggedEmail({
      to: params.to,
      organizationId: params.organizationId,
      subject: descriptor.subject,
      template: descriptor.template,
      context: {
        firstName: params.firstName,
        providerName: params.providerName,
        appointmentDate: params.appointmentDate,
        organizationName: params.organizationName,
      },
    });
  }

  async sendPaymentReceivedEmail(params: {
    to: string;
    firstName: string;
    amount: string;
    invoiceNumber: string;
    paymentStatus: string;
    organizationId?: string;
  }) {
    const descriptor = EMAIL_TEMPLATES.billing.paymentReceived;
    return this.sendLoggedEmail({
      to: params.to,
      organizationId: params.organizationId,
      subject: descriptor.subject,
      template: descriptor.template,
      context: {
        firstName: params.firstName,
        amount: params.amount,
        invoiceNumber: params.invoiceNumber,
        paymentStatus: params.paymentStatus,
      },
    });
  }

  private async sendLoggedEmail(params: {
    to: string;
    subject: string;
    template: string;
    organizationId?: string;
    context: Record<string, unknown>;
    sensitive?: boolean;
  }) {
    const log = await this.emailLogService.createPendingLog({
      toEmail: params.to,
      subject: params.subject,
      body: JSON.stringify({
        template: params.template,
        context: params.sensitive ? undefined : params.context,
      }),
      provider: EmailProvider.SMTP,
      organizationId: params.organizationId,
    });

    try {
      await this.dispatcher.send({
        to: params.to,
        subject: params.subject,
        template: params.template,
        context: params.context,
      });
    } catch (error) {
      await this.emailLogService.markFailed(log.id, 'Email dispatch failed');
      throw error;
    }

    await this.emailLogService.markSent(log.id);
    return log.id;
  }
}
