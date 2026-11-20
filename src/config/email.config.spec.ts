import { ConfigService } from '@nestjs/config';
import { SmtpEmailProvider } from '../modules/notifications/email/providers/smtp.provider';
import emailConfig from './email.config';

describe('email delivery configuration', () => {
  afterEach(() => {
    jest.restoreAllMocks();
  });

  it('honors an explicit disable even with SMTP configured', async () => {
    jest.replaceProperty(process, 'env', {
      EMAIL_ENABLED: 'false',
      SMTP_HOST: 'smtp.example.com',
    });

    const provider = new SmtpEmailProvider(
      new ConfigService({ email: emailConfig() }),
    );

    await expect(
      provider.send({
        to: 'patient@example.com',
        from: 'staff@example.com',
        subject: 'Example',
        text: 'Example',
        html: '<p>Example</p>',
      }),
    ).rejects.toThrow('Email delivery is disabled');
  });

  it('rejects enabling delivery without an SMTP host', () => {
    jest.replaceProperty(process, 'env', { EMAIL_ENABLED: 'true' });

    expect(
      () => new SmtpEmailProvider(new ConfigService({ email: emailConfig() })),
    ).toThrow('EMAIL_HOST is required when email is enabled');
  });
});
