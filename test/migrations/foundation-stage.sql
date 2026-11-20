-- These bytes and hashes are synthetic. A real deployment must use its encryption service.
ALTER TABLE external_systems
    ADD COLUMN credentials_encrypted BYTEA,
    ADD COLUMN credentials_hash VARCHAR(64),
    ADD COLUMN credentials_key_version INTEGER DEFAULT 1;
UPDATE external_systems
SET credentials_encrypted = '\x1020', credentials_hash = repeat('a', 64), credentials_key_version = 2
WHERE name = 'Fixture EHR';

ALTER TABLE webhook_subscriptions
    ADD COLUMN secret_encrypted BYTEA,
    ADD COLUMN secret_hash VARCHAR(64),
    ADD COLUMN secret_key_version INTEGER DEFAULT 1;
UPDATE webhook_subscriptions
SET secret_encrypted = '\x3040', secret_hash = repeat('b', 64), secret_key_version = 3
WHERE event_type = 'TEST-EVENT';
