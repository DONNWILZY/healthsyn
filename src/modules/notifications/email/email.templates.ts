export const EMAIL_TEMPLATES = {
  auth: {
    welcome: {
      template: 'auth/welcome',
      subject: 'Welcome to HealthSync Pro',
    },
    passwordReset: {
      template: 'auth/password-reset',
      subject: 'Reset your HealthSync Pro password',
    },
  },
  clinical: {
    appointmentReminder: {
      template: 'clinical/appointment-reminder',
      subject: 'Appointment reminder',
    },
  },
  billing: {
    paymentReceived: {
      template: 'billing/payment-received',
      subject: 'Payment received',
    },
  },
} as const;

export type EmailTemplateDescriptor =
  (typeof EMAIL_TEMPLATES)[keyof typeof EMAIL_TEMPLATES][keyof (typeof EMAIL_TEMPLATES)[keyof typeof EMAIL_TEMPLATES]];
