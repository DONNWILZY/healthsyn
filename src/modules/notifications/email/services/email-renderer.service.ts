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

    const htmlBody = this.interpolate(htmlTemplate, context, true);
    const textBody = this.interpolate(textTemplate, context);
    const html = this.interpolate(layoutTemplate, context, true, htmlBody);
    const subject =
      typeof context.subject === 'string' ? context.subject : undefined;

    return {
      subject,
      html,
      text: textBody,
    };
  }

  private interpolate(
    template: string,
    context: Record<string, unknown>,
    escapeHtml = false,
    renderedBody?: string,
  ): string {
    return template.replace(
      /\{\{\{\s*([a-zA-Z0-9_.]+)\s*\}\}\}|\{\{\s*([a-zA-Z0-9_.]+)\s*\}\}/g,
      (_, rawKey: string | undefined, escapedKey: string) => {
        if (rawKey === 'body' && renderedBody !== undefined)
          return renderedBody;
        const key = rawKey ?? escapedKey;
        const value = key.split('.').reduce<unknown>((acc, part) => {
          if (
            acc === null ||
            acc === undefined ||
            typeof acc !== 'object' ||
            !Object.hasOwn(acc, part)
          ) {
            return undefined;
          }

          return (acc as Record<string, unknown>)[part];
        }, context);

        const text =
          typeof value === 'string' ||
          typeof value === 'number' ||
          typeof value === 'boolean'
            ? String(value)
            : '';
        if (!escapeHtml) return text;
        return text
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;')
          .replace(/'/g, '&#39;');
      },
    );
  }
}
