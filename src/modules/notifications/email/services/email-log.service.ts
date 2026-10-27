import { DeliveryStatus, EmailProvider } from '@prisma/client';
import { createHash } from 'crypto';
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../prisma/prisma.service';

@Injectable()
export class EmailLogService {
  constructor(private readonly prisma: PrismaService) {}

  async createPendingLog(params: {
    toEmail: string;
    subject: string;
    body: string;
    provider?: string;
    organizationId?: string;
  }) {
    const emailConfig = params.organizationId
      ? await this.prisma.emailProviderConfig.findFirst({
          where: {
            organizationId: params.organizationId,
            isActive: true,
          },
          select: {
            id: true,
            provider: true,
          },
        })
      : null;

    return this.prisma.emailLog.create({
      data: {
        organizationId: params.organizationId,
        emailConfigId: emailConfig?.id,
        toEmail: params.toEmail,
        subject: params.subject,
        bodyHash: createHash('sha256').update(params.body).digest('hex'),
        provider: this.asEmailProvider(emailConfig?.provider ?? params.provider),
        status: DeliveryStatus.PENDING,
      },
    });
  }

  async markSent(id: string) {
    return this.prisma.emailLog.update({
      where: { id },
      data: {
        status: DeliveryStatus.SENT,
        sentAt: new Date(),
      },
    });
  }

  async markFailed(id: string, errorMessage: string) {
    return this.prisma.emailLog.update({
      where: { id },
      data: {
        status: DeliveryStatus.FAILED,
        errorMessage,
      },
    });
  }

  private asEmailProvider(provider?: string | EmailProvider | null): EmailProvider | undefined {
    if (!provider) {
      return undefined;
    }

    if (Object.values(EmailProvider).includes(provider as EmailProvider)) {
      return provider as EmailProvider;
    }

    return undefined;
  }
}
