import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';
import { EmailTransport } from '../email.types';

@Injectable()
export class SmtpEmailProvider implements EmailTransport {
  private readonly logger = new Logger(SmtpEmailProvider.name);
  private readonly transporter: nodemailer.Transporter;

  constructor(private readonly configService: ConfigService) {
    const enabled = this.configService.get<boolean>('email.enabled', false);
    const host = this.configService.get<string>('email.host');
    const port = this.configService.get<number>('email.port', 587);
    const secure = this.configService.get<boolean>('email.secure', false);
    const user = this.configService.get<string>('email.user');
    const password = this.configService.get<string>('email.password');

    if (!enabled || !host) {
      this.transporter = nodemailer.createTransport({ jsonTransport: true });
      return;
    }

    this.transporter = nodemailer.createTransport({
      host,
      port,
      secure,
      auth: user && password ? { user, pass: password } : undefined,
    });
  }

  async send(options: {
    to: string;
    from: string;
    replyTo?: string;
    subject: string;
    html: string;
    text: string;
  }): Promise<void> {
    await this.transporter.sendMail(options);
    this.logger.debug(`Email queued for ${options.to} with subject "${options.subject}"`);
  }
}
