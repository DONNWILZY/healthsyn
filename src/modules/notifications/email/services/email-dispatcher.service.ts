import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { EMAIL_TRANSPORT } from '../email.constants';
import { EmailTransport, SendEmailOptions } from '../email.types';
import { EmailRendererService } from './email-renderer.service';

@Injectable()
export class EmailDispatcherService {
  constructor(
    @Inject(EMAIL_TRANSPORT) private readonly transport: EmailTransport,
    private readonly configService: ConfigService,
    private readonly renderer: EmailRendererService,
  ) {}

  async send(options: SendEmailOptions): Promise<void> {
    const rendered = await this.renderer.render(options.template, {
      ...options.context,
      subject: options.subject,
    });

    const fromName = this.configService.get<string>('email.fromName', 'HealthSync Pro');
    const fromAddress = this.configService.get<string>(
      'email.fromAddress',
      'no-reply@healthsync.local',
    );
    const replyTo =
      options.replyTo ?? this.configService.get<string | undefined>('email.replyTo');

    await this.transport.send({
      to: this.normalizeRecipients(options.to),
      from: `${fromName} <${fromAddress}>`,
      replyTo,
      subject: rendered.subject ?? options.subject,
      html: rendered.html,
      text: rendered.text,
    });
  }

  private normalizeRecipients(recipientsInput: SendEmailOptions['to']): string {
    const recipients = Array.isArray(recipientsInput)
      ? recipientsInput
      : [recipientsInput];
    return recipients
      .map((recipient) =>
        typeof recipient === 'string'
          ? recipient
          : recipient.name
            ? `${recipient.name} <${recipient.email}>`
            : recipient.email,
      )
      .join(', ');
  }
}
