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
    provider: EmailProvider;
    organizationId?: string;
  }) {
    return this.prisma.emailLog.create({
      data: {
        organizationId: params.organizationId,
        toEmail: params.toEmail,
        subject: params.subject,
        bodyHash: createHash('sha256').update(params.body).digest('hex'),
        provider: params.provider,
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
}
