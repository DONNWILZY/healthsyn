import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { readFile } from 'fs/promises';
import { join } from 'path';

@Injectable()
export class EmailTemplateService {
  constructor(private readonly configService: ConfigService) {}

  async loadTemplate(relativePath: string): Promise<string> {
    const templatesDir = this.configService.getOrThrow<string>('email.templatesDir');
    const absolutePath = join(templatesDir, `${relativePath}.hbs`);
    return readFile(absolutePath, 'utf8');
  }
}
