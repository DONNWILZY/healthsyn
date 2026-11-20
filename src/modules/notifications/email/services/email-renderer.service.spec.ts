import { Test, TestingModule } from '@nestjs/testing';
import { EmailRendererService } from './email-renderer.service';
import { EmailTemplateService } from './email-template.service';

describe('EmailRendererService', () => {
  let service: EmailRendererService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EmailRendererService,
        {
          provide: EmailTemplateService,
          useValue: {
            loadTemplate: jest.fn((template: string) => {
              const templates: Record<string, string> = {
                'auth/password-reset':
                  '<h1>Hello {{firstName}}</h1><p>{{resetCode}}</p>',
                'auth/password-reset.text': 'Hello {{firstName}} {{resetCode}}',
                'layouts/base':
                  '<html><body>{{{body}}}<footer>{{{firstName}}}</footer></body></html>',
              };

              return Promise.resolve(templates[template]);
            }),
          },
        },
      ],
    }).compile();

    service = module.get(EmailRendererService);
  });

  it('renders html and text templates with interpolated context', async () => {
    const rendered = await service.render('auth/password-reset', {
      firstName: 'Ada',
      resetCode: '123456',
      subject: 'Reset your HealthSync Pro password',
    });

    expect(rendered.subject).toBe('Reset your HealthSync Pro password');
    expect(rendered.html).toContain('<h1>Hello Ada</h1>');
    expect(rendered.html).toContain('<html><body>');
    expect(rendered.text).toContain('Hello Ada 123456');
  });
  it('escapes HTML values and keeps plain-text values verbatim', async () => {
    const rendered = await service.render('auth/password-reset', {
      firstName: '<b>Ada & Co</b>',
      resetCode: '012345',
    });

    expect(rendered.html).toContain(
      '<h1>Hello &lt;b&gt;Ada &amp; Co&lt;/b&gt;</h1>',
    );
    expect(rendered.html).toContain(
      '<footer>&lt;b&gt;Ada &amp; Co&lt;/b&gt;</footer>',
    );
    expect(rendered.text).toBe('Hello <b>Ada & Co</b> 012345');
  });
});
