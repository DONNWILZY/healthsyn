-- Synthetic data for the schema produced by the first two migrations.
INSERT INTO "User" (
    id, account_type, first_name, last_name, date_of_birth, email_encrypted, email_hash,
    phone_encrypted, phone_hash, password_hash, password_salt, session_token, updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000001', 'INDIVIDUAL', 'Test', 'Person', '2000-01-01',
    '\x01', 'synthetic-email-hash', '\x02', 'synthetic-phone-hash', 'fixture-hash',
    'fixture-salt', 'fixture-session', now()
);

INSERT INTO organizations (id, org_type, org_code, name, legal_name, license_number, address, contact_info, updated_at)
VALUES ('00000000-0000-0000-0000-000000000002', 'HOSPITAL', 'TEST-HOSP', 'Test Hospital', 'Test Hospital', 'TEST-ORG', '{}', '{}', now());

INSERT INTO patients (id, user_id, patient_code, closed_by, updated_at)
VALUES ('00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001', 'TEST-PATIENT', '00000000-0000-0000-0000-000000000001', now());

-- The legacy signature had two foreign keys on the same ID.
INSERT INTO healthcare_providers (id, user_id, provider_code, provider_type, license_number, updated_at)
VALUES ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'TEST-PROVIDER', 'DOCTOR', 'TEST-LIC', now());

INSERT INTO appointments (appointment_number, patient_id, provider_id, organization_id, appointment_type, reason_for_visit, scheduled_start, scheduled_end, status, updated_at)
VALUES ('TEST-APPT', '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', 'TEST', 'Fixture', now(), now(), ' completed ', now());

INSERT INTO data_export_requests (user_id, export_type, format, status, file_url)
VALUES ('00000000-0000-0000-0000-000000000001', 'TEST', 'JSON', 'completed', 'https://example.invalid/fixture');

INSERT INTO digital_signatures (signer_id, signer_type, resource_type, resource_id, signature_hash, algorithm)
VALUES
    ('00000000-0000-0000-0000-000000000001', 'user', 'TEST', '00000000-0000-0000-0000-000000000003', 'user-signature', 'fixture'),
    ('00000000-0000-0000-0000-000000000001', 'provider', 'TEST', '00000000-0000-0000-0000-000000000003', 'provider-signature', 'fixture');

INSERT INTO hl7_messages (message_type, organization_id, message_content, message_hash, status)
VALUES ('ADT_A01', '00000000-0000-0000-0000-000000000002', 'Fixture', 'synthetic-hl7-hash', 'processed');

INSERT INTO patient_access_logs (patient_id, accessor_id, accessor_type, action_type, action_details)
VALUES ('00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001', 'provider', 'view', 'Fixture');

INSERT INTO roles (name, permissions, organization_id, updated_at)
VALUES ('TEST-ORG-ROLE', '[]', '00000000-0000-0000-0000-000000000002', now()), ('TEST-SYSTEM-ROLE', '[]', NULL, now());

INSERT INTO invoices (id, invoice_number, patient_id, items, subtotal, total_amount, balance, issued_date, due_date, updated_at)
VALUES ('00000000-0000-0000-0000-000000000004', 'TEST-INV', '00000000-0000-0000-0000-000000000003', ARRAY['{"legacy":"item"}'::jsonb], 10, 10, 10, current_date, current_date, now());

INSERT INTO payments (id, invoice_id, patient_id, organization_id, amount, method)
VALUES ('00000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000002', 10, 'CASH');

INSERT INTO transactions (organization_id, payment_id, transaction_type, amount, balance_before, balance_after, description)
VALUES ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000005', 'credit', 10, 0, 10, 'Fixture');

INSERT INTO external_systems (organization_id, system_type, name, endpoint, authentication_type, credentials, updated_at)
VALUES ('00000000-0000-0000-0000-000000000002', 'EHR', 'Fixture EHR', 'https://example.invalid/ehr', 'API_KEY', '{"key":"fixture-credential"}', now());

INSERT INTO webhook_subscriptions (id, organization_id, event_type, url, secret)
VALUES ('00000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000002', 'TEST-EVENT', 'https://example.invalid/webhook', 'fixture-secret');

INSERT INTO webhook_deliveries (subscription_id, event_type, payload, status)
VALUES ('00000000-0000-0000-0000-000000000006', 'TEST-EVENT', '{}', 'delivered');
