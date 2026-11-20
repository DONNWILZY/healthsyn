import { Test, TestingModule } from '@nestjs/testing';
import { EmailDispatcherService } from './email-dispatcher.service';
import { EmailLogService } from './email-log.service';
import { TransactionalEmailService } from './transactional-email.service';

describe('TransactionalEmailService', () => {
  let service: TransactionalEmailService;
  let dispatcher: jest.Mocked<EmailDispatcherService>;
  let emailLogService: jest.Mocked<EmailLogService>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TransactionalEmailService,
        {
          provide: EmailDispatcherService,
          useValue: {
            send: jest.fn(),
          },
        },
        {
          provide: EmailLogService,
          useValue: {
            createPendingLog: jest.fn(),
            markSent: jest.fn(),
            markFailed: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get(TransactionalEmailService);
    dispatcher = module.get(EmailDispatcherService);
    emailLogService = module.get(EmailLogService);
  });

  it('creates a log, dispatches the email, and marks it as sent', async () => {
    emailLogService.createPendingLog.mockResolvedValue({
      id: 'log-1',
    } as never);

    await service.sendPasswordResetEmail({
      to: 'patient@example.com',
      firstName: 'Ada',
      resetCode: '123456',
    });

    expect(emailLogService.createPendingLog).toHaveBeenCalledWith(
      expect.objectContaining({
        toEmail: 'patient@example.com',
        subject: 'Reset your HealthSync Pro password',
        body: JSON.stringify({ template: 'auth/password-reset' }),
      }),
    );
    expect(dispatcher.send).toHaveBeenCalledWith(
      expect.objectContaining({
        to: 'patient@example.com',
        template: 'auth/password-reset',
        context: expect.objectContaining({
          firstName: 'Ada',
          resetCode: '123456',
        }),
      }),
    );
    expect(emailLogService.markSent).toHaveBeenCalledWith('log-1');
    expect(emailLogService.markFailed).not.toHaveBeenCalled();
  });

  it('marks the log as failed when dispatch throws', async () => {
    emailLogService.createPendingLog.mockResolvedValue({
      id: 'log-2',
    } as never);
    dispatcher.send.mockRejectedValue(new Error('smtp down'));

    await expect(
      service.sendPasswordResetEmail({
        to: 'patient@example.com',
        firstName: 'Ada',
        resetCode: '123456',
      }),
    ).rejects.toThrow('smtp down');

    expect(emailLogService.markFailed).toHaveBeenCalledWith(
      'log-2',
      'Email dispatch failed',
    );
    expect(emailLogService.markSent).not.toHaveBeenCalled();
  });
  it('does not mark a delivered email as failed if writing its sent status fails', async () => {
    emailLogService.createPendingLog.mockResolvedValue({
      id: 'log-3',
    } as never);
    emailLogService.markSent.mockRejectedValue(
      new Error('database unavailable'),
    );

    await expect(
      service.sendWelcomeEmail({ to: 'patient@example.com', firstName: 'Ada' }),
    ).rejects.toThrow('database unavailable');

    expect(dispatcher.send).toHaveBeenCalledTimes(1);
    expect(emailLogService.markFailed).not.toHaveBeenCalled();
  });
});
