import { Injectable } from '@nestjs/common';
import { EmailTemplateService } from './email-template.service';
import { RenderedEmailTemplate } from '../email.types';

@Injectable()
export class EmailRendererService {
  constructor(private readonly templateService: EmailTemplateService) {}

  async render(
    template: string,
    context: Record<string, unknown> = {},
  ): Promise<RenderedEmailTemplate> {
    const [htmlTemplate, textTemplate, layoutTemplate] = await Promise.all([
      this.templateService.loadTemplate(template),
      this.templateService.loadTemplate(`${template}.text`),
      this.templateService.loadTemplate('layouts/base'),
    ]);

    const htmlBody = this.interpolate(htmlTemplate, context);
    const textBody = this.interpolate(textTemplate, context);
    const html = this.interpolate(layoutTemplate, { ...context, body: htmlBody });
    const subject = typeof context.subject === 'string' ? context.subject : undefined;

    return {
      subject,
      html,
      text: textBody,
    };
  }

  private interpolate(template: string, context: Record<string, unknown>): string {
    return template.replace(/\{\{\{?\s*([a-zA-Z0-9_.]+)\s*\}?\}\}/g, (_, key: string) => {
      const value = key.split('.').reduce<unknown>((acc, part) => {
        if (acc === null || acc === undefined || typeof acc !== 'object') {
          return undefined;
        }

        return (acc as Record<string, unknown>)[part];
      }, context);

      return value === undefined || value === null ? '' : String(value);
    });
  }
}
