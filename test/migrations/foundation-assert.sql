DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "User" WHERE id = '00000000-0000-0000-0000-000000000001'
        AND password_salt = 'fixture-salt' AND session_token = 'fixture-session'
        AND email_key_version = 1 AND phone_key_version = 1) THEN
        RAISE EXCEPTION 'Legacy user data was not preserved';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM appointments WHERE appointment_number = 'TEST-APPT' AND status = 'COMPLETED')
        OR NOT EXISTS (SELECT 1 FROM hl7_messages WHERE message_hash = 'synthetic-hl7-hash' AND status = 'PROCESSED')
        OR NOT EXISTS (SELECT 1 FROM patient_access_logs WHERE action_details = 'Fixture' AND accessor_type = 'PROVIDER' AND action_type = 'VIEW')
        OR NOT EXISTS (SELECT 1 FROM webhook_deliveries WHERE event_type = 'TEST-EVENT' AND status = 'DELIVERED')
        OR NOT EXISTS (SELECT 1 FROM transactions WHERE description = 'Fixture' AND transaction_type = 'CREDIT' AND amount = 10) THEN
        RAISE EXCEPTION 'Legacy enum values or their rows were not preserved';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM invoices WHERE invoice_number = 'TEST-INV' AND items = ARRAY['{"legacy":"item"}'::jsonb])
        OR NOT EXISTS (SELECT 1 FROM data_export_requests WHERE export_type = 'TEST'
            AND status = 'COMPLETED' AND file_url = 'https://example.invalid/fixture' AND storage_key IS NULL) THEN
        RAISE EXCEPTION 'Legacy invoice or export data was not preserved';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM digital_signatures WHERE signature_hash = 'user-signature' AND signer_type = 'USER'
            AND signer_user_id = '00000000-0000-0000-0000-000000000001' AND signer_provider_id IS NULL)
        OR NOT EXISTS (SELECT 1 FROM digital_signatures WHERE signature_hash = 'provider-signature' AND signer_type = 'PROVIDER'
            AND signer_provider_id = '00000000-0000-0000-0000-000000000001' AND signer_user_id IS NULL) THEN
        RAISE EXCEPTION 'Legacy signer IDs were not migrated to the matching relation';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM roles WHERE name = 'TEST-ORG-ROLE' AND scope_key = organization_id::text)
        OR NOT EXISTS (SELECT 1 FROM roles WHERE name = 'TEST-SYSTEM-ROLE' AND scope_key = 'SYSTEM') THEN
        RAISE EXCEPTION 'Legacy role scopes were not backfilled';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM external_systems WHERE name = 'Fixture EHR'
            AND credentials_encrypted = '\x1020' AND credentials_hash = repeat('a', 64) AND credentials_key_version = 2)
        OR NOT EXISTS (SELECT 1 FROM webhook_subscriptions WHERE event_type = 'TEST-EVENT'
            AND secret_encrypted = '\x3040' AND secret_hash = repeat('b', 64) AND secret_key_version = 3) THEN
        RAISE EXCEPTION 'Staged encrypted credentials were not retained';
    END IF;
END $$;
