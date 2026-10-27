export interface EmailAddress {
  email: string;
  name?: string;
}

export interface SendEmailOptions {
  to: string | EmailAddress | Array<string | EmailAddress>;
  subject: string;
  template: string;
  context?: Record<string, unknown>;
  replyTo?: string;
}

export interface RenderedEmailTemplate {
  html: string;
  text: string;
  subject?: string;
}

export interface EmailTransport {
  send(options: {
    to: string;
    from: string;
    replyTo?: string;
    subject: string;
    html: string;
    text: string;
  }): Promise<void>;
}
