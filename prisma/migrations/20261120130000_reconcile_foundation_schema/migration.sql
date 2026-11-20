BEGIN;

-- Populated integrations can stage ciphertext, hash and key version through
-- the approved encryption service before migration. Never copy plaintext into
-- the ciphertext columns or pass encryption keys to this migration.
ALTER TABLE "external_systems"
    ADD COLUMN IF NOT EXISTS "credentials_encrypted" BYTEA,
    ADD COLUMN IF NOT EXISTS "credentials_hash" VARCHAR(64),
    ADD COLUMN IF NOT EXISTS "credentials_key_version" INTEGER DEFAULT 1;
ALTER TABLE "webhook_subscriptions"
    ADD COLUMN IF NOT EXISTS "secret_encrypted" BYTEA,
    ADD COLUMN IF NOT EXISTS "secret_hash" VARCHAR(64),
    ADD COLUMN IF NOT EXISTS "secret_key_version" INTEGER DEFAULT 1;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM "external_systems"
        WHERE "credentials" IS NOT NULL AND (
            COALESCE(octet_length("credentials_encrypted"), 0) = 0 OR
            COALESCE("credentials_hash" !~ '^[0-9a-fA-F]{64}$', true) OR
            COALESCE("credentials_key_version", 0) < 1
        )
    ) THEN
        RAISE EXCEPTION 'Stage encrypted external system credentials before applying this migration';
    END IF;
    IF EXISTS (
        SELECT 1 FROM "webhook_subscriptions"
        WHERE COALESCE(octet_length("secret_encrypted"), 0) = 0 OR
            COALESCE("secret_hash" !~ '^[0-9a-fA-F]{64}$', true) OR
            COALESCE("secret_key_version", 0) < 1
    ) THEN
        RAISE EXCEPTION 'Stage encrypted webhook secrets before applying this migration';
    END IF;
END $$;

ALTER TABLE "external_systems"
    ALTER COLUMN "credentials_key_version" SET DEFAULT 1,
    ALTER COLUMN "credentials_key_version" SET NOT NULL,
    DROP COLUMN "credentials";
ALTER TABLE "webhook_subscriptions"
    ALTER COLUMN "secret_encrypted" SET NOT NULL,
    ALTER COLUMN "secret_hash" SET NOT NULL,
    ALTER COLUMN "secret_key_version" SET DEFAULT 1,
    ALTER COLUMN "secret_key_version" SET NOT NULL,
    DROP COLUMN "secret";

-- CreateEnum
CREATE TYPE "OrganizationRelationshipType" AS ENUM ('HOSPITAL_PHARMACY', 'HOSPITAL_INSURER', 'PHARMACY_INSURER', 'HOSPITAL_LAB', 'HOSPITAL_SUPPLIER', 'ORGANIZATION_PROVIDER', 'REFERRAL_NETWORK', 'CUSTOM');

-- CreateEnum
CREATE TYPE "OrganizationRelationshipStatus" AS ENUM ('DRAFT', 'ACTIVE', 'SUSPENDED', 'EXPIRED', 'TERMINATED');

-- CreateEnum
CREATE TYPE "OrganizationCapabilityType" AS ENUM ('HOSPITAL_SERVICES', 'PHARMACY_DISPENSING', 'INSURANCE_UNDERWRITING', 'CLAIMS_PROCESSING', 'LAB_PROCESSING', 'IMAGING_SERVICES', 'SUPPLY_FULFILLMENT', 'TELEHEALTH');

-- CreateEnum
CREATE TYPE "AppointmentStatus" AS ENUM ('SCHEDULED', 'CHECKED_IN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW');

-- CreateEnum
CREATE TYPE "HL7MessageStatus" AS ENUM ('PENDING', 'PROCESSING', 'PROCESSED', 'FAILED', 'ACKNOWLEDGED');

-- CreateEnum
CREATE TYPE "PatientAccessActorType" AS ENUM ('USER', 'PROVIDER', 'STAFF', 'CAREGIVER', 'SYSTEM', 'API_CLIENT', 'EXTERNAL_SYSTEM');

-- CreateEnum
CREATE TYPE "PatientAccessActionType" AS ENUM ('VIEW', 'CREATE', 'UPDATE', 'DELETE', 'EXPORT', 'DOWNLOAD', 'PRINT', 'SHARE', 'EMERGENCY_ACCESS');

-- CreateEnum
CREATE TYPE "DigitalSignatureSignerType" AS ENUM ('USER', 'PROVIDER');

-- CreateEnum
CREATE TYPE "WebhookDeliveryStatus" AS ENUM ('PENDING', 'IN_PROGRESS', 'DELIVERED', 'FAILED', 'ABANDONED');

-- CreateEnum
CREATE TYPE "DataExportStatus" AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'EXPIRED', 'REVOKED');

-- CreateEnum
CREATE TYPE "EligibilityCheckStatus" AS ENUM ('PENDING', 'VERIFIED', 'INELIGIBLE', 'PARTIAL', 'FAILED');

-- CreateEnum
CREATE TYPE "RefundStatus" AS ENUM ('REQUESTED', 'APPROVED', 'REJECTED', 'PROCESSED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "FinancialTransactionType" AS ENUM ('CREDIT', 'DEBIT', 'REFUND', 'ADJUSTMENT', 'TRANSFER');

-- CreateEnum
CREATE TYPE "AllocationType" AS ENUM ('INVOICE', 'CLAIM', 'SETTLEMENT');

-- CreateEnum
CREATE TYPE "PrescriptionRoutingStatus" AS ENUM ('PENDING', 'SENT', 'RECEIVED', 'ACCEPTED', 'REJECTED', 'REDIRECTED', 'FULFILLED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "ClarificationStatus" AS ENUM ('OPEN', 'RESPONDED', 'RESOLVED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "VerificationEntityType" AS ENUM ('USER', 'PROVIDER', 'ORGANIZATION');

-- CreateEnum
CREATE TYPE "VerificationStatus" AS ENUM ('PENDING', 'IN_REVIEW', 'VERIFIED', 'REJECTED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "TransferRequestStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'EXPIRED', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "SettlementCaseStatus" AS ENUM ('OPEN', 'DECIDED', 'SETTLING', 'SETTLED', 'FAILED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "SettlementDecisionType" AS ENUM ('PATIENT_PAYS', 'HOSPITAL_PAYS_AND_BILLS', 'INSURER_PAYS', 'REDIRECT', 'MICRO_AGREEMENT', 'MANUAL_REVIEW');

-- CreateEnum
CREATE TYPE "SettlementObligationStatus" AS ENUM ('PENDING', 'INVOICED', 'PAID', 'WAIVED', 'CANCELLED');

-- AlterEnum
ALTER TYPE "ReminderFrequency" ADD VALUE 'MULTIPLE';

-- Keep the legacy password salt, session token, invoice items and export URL
-- available for deliberate follow-up backfills. The client ignores these fields.
ALTER TABLE "User"
    ALTER COLUMN "password_salt" DROP NOT NULL,
    ADD COLUMN "email_key_version" INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN "phone_key_version" INTEGER NOT NULL DEFAULT 1;
DROP INDEX "User_email_encrypted_key";

-- Convert existing values in place. An unrecognized enum value aborts the migration.
ALTER TABLE "appointments" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "appointments" ALTER COLUMN "status" TYPE "AppointmentStatus"
    USING upper(btrim("status"))::"AppointmentStatus";
ALTER TABLE "appointments" ALTER COLUMN "status" SET DEFAULT 'SCHEDULED';

ALTER TABLE "data_export_requests" ADD COLUMN "storage_key" TEXT,
    ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "data_export_requests" ALTER COLUMN "status" TYPE "DataExportStatus"
    USING upper(btrim("status"))::"DataExportStatus";
ALTER TABLE "data_export_requests" ALTER COLUMN "status" SET DEFAULT 'PENDING';

-- Migrate the legacy signer ID to the matching typed foreign key. The old
-- constraints made that same ID refer to both a user and a provider.
ALTER TABLE "digital_signatures"
    DROP CONSTRAINT "digital_signatures_signer_provider_fkey",
    DROP CONSTRAINT "digital_signatures_signer_user_fkey",
    ADD COLUMN "signer_provider_id" UUID,
    ADD COLUMN "signer_user_id" UUID,
    ALTER COLUMN "signer_type" TYPE "DigitalSignatureSignerType"
        USING upper(btrim("signer_type"))::"DigitalSignatureSignerType";
UPDATE "digital_signatures"
SET "signer_user_id" = CASE WHEN "signer_type" = 'USER' THEN "signer_id" END,
    "signer_provider_id" = CASE WHEN "signer_type" = 'PROVIDER' THEN "signer_id" END;
ALTER TABLE "digital_signatures" DROP COLUMN "signer_id";

ALTER TABLE "hl7_messages" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "hl7_messages" ALTER COLUMN "status" TYPE "HL7MessageStatus"
    USING upper(btrim("status"))::"HL7MessageStatus";
ALTER TABLE "hl7_messages" ALTER COLUMN "status" SET DEFAULT 'PENDING';

ALTER TABLE "patient_access_logs"
    ALTER COLUMN "accessor_type" TYPE "PatientAccessActorType"
        USING upper(btrim("accessor_type"))::"PatientAccessActorType",
    ALTER COLUMN "action_type" TYPE "PatientAccessActionType"
        USING upper(btrim("action_type"))::"PatientAccessActionType";

ALTER TABLE "patient_insurance" ADD COLUMN "patient_organization_id" UUID;

ALTER TABLE "roles" ADD COLUMN "scope_key" VARCHAR(64) NOT NULL DEFAULT 'SYSTEM';
UPDATE "roles" SET "scope_key" = "organization_id"::text WHERE "organization_id" IS NOT NULL;
DROP INDEX "roles_name_key";

ALTER TABLE "transactions" ALTER COLUMN "transaction_type" TYPE "FinancialTransactionType"
    USING upper(btrim("transaction_type"))::"FinancialTransactionType";

ALTER TABLE "webhook_deliveries" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "webhook_deliveries" ALTER COLUMN "status" TYPE "WebhookDeliveryStatus"
    USING upper(btrim("status"))::"WebhookDeliveryStatus";
ALTER TABLE "webhook_deliveries" ALTER COLUMN "status" SET DEFAULT 'PENDING';

-- CreateTable
CREATE TABLE "organization_relationships" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "source_organization_id" UUID NOT NULL,
    "target_organization_id" UUID NOT NULL,
    "relationship_type" "OrganizationRelationshipType" NOT NULL,
    "status" "OrganizationRelationshipStatus" NOT NULL DEFAULT 'DRAFT',
    "network_code" VARCHAR(50),
    "allows_claims" BOOLEAN NOT NULL DEFAULT false,
    "allows_prescriptions" BOOLEAN NOT NULL DEFAULT false,
    "allows_data_exchange" BOOLEAN NOT NULL DEFAULT false,
    "terms" JSONB,
    "effective_from" DATE,
    "effective_to" DATE,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_relationships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_capabilities" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "capability_type" "OrganizationCapabilityType" NOT NULL,
    "config" JSONB,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_capabilities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_contracts" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_relationship_id" UUID,
    "primary_organization_id" UUID NOT NULL,
    "secondary_organization_id" UUID NOT NULL,
    "contract_code" VARCHAR(50) NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "terms" JSONB NOT NULL,
    "effective_from" DATE NOT NULL,
    "effective_to" DATE,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_contracts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reaction_reports" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "encounter_id" UUID,
    "provider_id" UUID,
    "reported_by_user_id" UUID,
    "symptom" VARCHAR(255) NOT NULL,
    "severity" VARCHAR(50),
    "description" TEXT,
    "occurred_at" TIMESTAMP(3),
    "resolved_at" TIMESTAMP(3),
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "reaction_reports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "patient_organizations" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "provider_id" UUID,
    "external_patient_id" VARCHAR(100),
    "mrn_encrypted" BYTEA,
    "mrn_hash" VARCHAR(64),
    "mrn_key_version" INTEGER NOT NULL DEFAULT 1,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "consentScope" JSONB,
    "metadata" JSONB,
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ended_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "patient_organizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prescription_routing" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "prescription_id" UUID NOT NULL,
    "source_hospital_id" UUID NOT NULL,
    "target_pharmacy_id" UUID,
    "relationship_id" UUID,
    "status" "PrescriptionRoutingStatus" NOT NULL DEFAULT 'PENDING',
    "reroute_reason" TEXT,
    "routing_metadata" JSONB,
    "sent_at" TIMESTAMP(3),
    "received_at" TIMESTAMP(3),
    "fulfilled_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "prescription_routing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prescription_clarifications" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "prescription_id" UUID NOT NULL,
    "pharmacy_id" UUID NOT NULL,
    "requested_by" UUID NOT NULL,
    "question" TEXT NOT NULL,
    "response" TEXT,
    "status" "ClarificationStatus" NOT NULL DEFAULT 'OPEN',
    "requested_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "responded_at" TIMESTAMP(3),

    CONSTRAINT "prescription_clarifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "eligibility_checks" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "coverage_enrollment_id" UUID NOT NULL,
    "insurance_company_id" UUID NOT NULL,
    "plan_id" UUID,
    "organization_id" UUID NOT NULL,
    "encounter_id" UUID,
    "status" "EligibilityCheckStatus" NOT NULL DEFAULT 'PENDING',
    "request_payload" JSONB,
    "response_payload" JSONB,
    "checked_at" TIMESTAMP(3),
    "expires_at" TIMESTAMP(3),
    "checked_by" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "eligibility_checks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "claim_lines" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "insurance_claim_id" UUID NOT NULL,
    "service_code" VARCHAR(50),
    "description" VARCHAR(255) NOT NULL,
    "quantity" DECIMAL(10,2) NOT NULL DEFAULT 1,
    "unit_amount" DECIMAL(10,2) NOT NULL,
    "billed_amount" DECIMAL(10,2) NOT NULL,
    "approved_amount" DECIMAL(10,2),
    "patient_responsibility" DECIMAL(10,2),
    "metadata" JSONB,

    CONSTRAINT "claim_lines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "claim_submission_logs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "insurance_claim_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "external_system_id" UUID,
    "request_payload" JSONB,
    "response_payload" JSONB,
    "submitted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "claim_submission_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoice_lines" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "invoice_id" UUID NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "quantity" DECIMAL(10,2) NOT NULL DEFAULT 1,
    "unit_amount" DECIMAL(10,2) NOT NULL,
    "total_amount" DECIMAL(10,2) NOT NULL,
    "category" VARCHAR(50),
    "metadata" JSONB,

    CONSTRAINT "invoice_lines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_allocations" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "payment_id" UUID NOT NULL,
    "invoice_id" UUID,
    "insurance_claim_id" UUID,
    "settlement_obligation_id" UUID,
    "allocation_type" "AllocationType" NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "allocated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_allocations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refunds" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "payment_id" UUID NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "reason" TEXT,
    "status" "RefundStatus" NOT NULL DEFAULT 'REQUESTED',
    "requested_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processed_at" TIMESTAMP(3),

    CONSTRAINT "refunds_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "settlement_cases" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "insurance_claim_id" UUID,
    "invoice_id" UUID,
    "prescription_routing_id" UUID,
    "relationship_id" UUID,
    "issue_code" VARCHAR(50) NOT NULL,
    "issue_summary" TEXT NOT NULL,
    "status" "SettlementCaseStatus" NOT NULL DEFAULT 'OPEN',
    "detected_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_at" TIMESTAMP(3),
    "metadata" JSONB,

    CONSTRAINT "settlement_cases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "settlement_decisions" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "settlement_case_id" UUID NOT NULL,
    "decision_type" "SettlementDecisionType" NOT NULL,
    "decided_by" UUID,
    "rationale" TEXT,
    "decision_payload" JSONB,
    "decided_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "settlement_decisions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "settlement_obligations" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "settlement_decision_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "status" "SettlementObligationStatus" NOT NULL DEFAULT 'PENDING',
    "due_at" TIMESTAMP(3),
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "settlement_obligations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "settlement_ledger_entries" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "settlement_obligation_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "direction" "FinancialTransactionType" NOT NULL,
    "reference_type" VARCHAR(50),
    "reference_id" UUID,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "settlement_ledger_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_sessions" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "refresh_token_hash" VARCHAR(64) NOT NULL,
    "session_family" VARCHAR(64),
    "device_id" VARCHAR(128),
    "device_name" VARCHAR(255),
    "ip_address" INET,
    "userAgent" TEXT,
    "last_used_at" TIMESTAMP(3),
    "expires_at" TIMESTAMP(3) NOT NULL,
    "revoked_at" TIMESTAMP(3),
    "revoked_reason" TEXT,
    "replaced_by_session_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "record_transfer_requests" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "source_organization_id" UUID NOT NULL,
    "target_organization_id" UUID NOT NULL,
    "consent_grant_id" UUID,
    "requested_by" UUID,
    "status" "TransferRequestStatus" NOT NULL DEFAULT 'PENDING',
    "request_reason" TEXT,
    "approved_at" TIMESTAMP(3),
    "rejected_at" TIMESTAMP(3),
    "expires_at" TIMESTAMP(3),
    "completed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "record_transfer_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "emergency_access_grants" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "organization_id" UUID,
    "granted_by" UUID,
    "reason" TEXT NOT NULL,
    "status" "ConsentStatus" NOT NULL DEFAULT 'ACTIVE',
    "granted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3),
    "revoked_at" TIMESTAMP(3),

    CONSTRAINT "emergency_access_grants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kyc_verifications" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID,
    "provider_id" UUID,
    "organization_id" UUID,
    "entity_type" "VerificationEntityType" NOT NULL,
    "document_type" VARCHAR(100) NOT NULL,
    "document_number_hash" VARCHAR(64),
    "document_data_encrypted" BYTEA,
    "status" "VerificationStatus" NOT NULL DEFAULT 'PENDING',
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMP(3),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "kyc_verifications_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "organization_relationships_source_organization_id_status_idx" ON "organization_relationships"("source_organization_id", "status");

-- CreateIndex
CREATE INDEX "organization_relationships_target_organization_id_status_idx" ON "organization_relationships"("target_organization_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "organization_relationships_source_organization_id_target_or_key" ON "organization_relationships"("source_organization_id", "target_organization_id", "relationship_type");

-- CreateIndex
CREATE INDEX "organization_capabilities_organization_id_active_idx" ON "organization_capabilities"("organization_id", "active");

-- CreateIndex
CREATE UNIQUE INDEX "organization_capabilities_organization_id_capability_type_key" ON "organization_capabilities"("organization_id", "capability_type");

-- CreateIndex
CREATE UNIQUE INDEX "organization_contracts_contract_code_key" ON "organization_contracts"("contract_code");

-- CreateIndex
CREATE INDEX "organization_contracts_primary_organization_id_active_idx" ON "organization_contracts"("primary_organization_id", "active");

-- CreateIndex
CREATE INDEX "organization_contracts_secondary_organization_id_active_idx" ON "organization_contracts"("secondary_organization_id", "active");

-- CreateIndex
CREATE INDEX "reaction_reports_patient_id_created_at_idx" ON "reaction_reports"("patient_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "reaction_reports_encounter_id_idx" ON "reaction_reports"("encounter_id");

-- CreateIndex
CREATE INDEX "reaction_reports_provider_id_idx" ON "reaction_reports"("provider_id");

-- CreateIndex
CREATE INDEX "patient_organizations_organization_id_active_idx" ON "patient_organizations"("organization_id", "active");

-- CreateIndex
CREATE INDEX "patient_organizations_patient_id_active_idx" ON "patient_organizations"("patient_id", "active");

-- CreateIndex
CREATE INDEX "patient_organizations_mrn_hash_idx" ON "patient_organizations"("mrn_hash");

-- CreateIndex
CREATE UNIQUE INDEX "patient_organizations_patient_id_organization_id_key" ON "patient_organizations"("patient_id", "organization_id");

-- CreateIndex
CREATE INDEX "prescription_routing_prescription_id_created_at_idx" ON "prescription_routing"("prescription_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "prescription_routing_target_pharmacy_id_status_idx" ON "prescription_routing"("target_pharmacy_id", "status");

-- CreateIndex
CREATE INDEX "prescription_clarifications_prescription_id_status_idx" ON "prescription_clarifications"("prescription_id", "status");

-- CreateIndex
CREATE INDEX "prescription_clarifications_pharmacy_id_requested_at_idx" ON "prescription_clarifications"("pharmacy_id", "requested_at" DESC);

-- CreateIndex
CREATE INDEX "eligibility_checks_patient_id_created_at_idx" ON "eligibility_checks"("patient_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "eligibility_checks_coverage_enrollment_id_status_idx" ON "eligibility_checks"("coverage_enrollment_id", "status");

-- CreateIndex
CREATE INDEX "eligibility_checks_organization_id_created_at_idx" ON "eligibility_checks"("organization_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "claim_lines_insurance_claim_id_idx" ON "claim_lines"("insurance_claim_id");

-- CreateIndex
CREATE INDEX "claim_submission_logs_insurance_claim_id_submitted_at_idx" ON "claim_submission_logs"("insurance_claim_id", "submitted_at" DESC);

-- CreateIndex
CREATE INDEX "claim_submission_logs_organization_id_submitted_at_idx" ON "claim_submission_logs"("organization_id", "submitted_at" DESC);

-- CreateIndex
CREATE INDEX "invoice_lines_invoice_id_idx" ON "invoice_lines"("invoice_id");

-- CreateIndex
CREATE INDEX "payment_allocations_payment_id_allocated_at_idx" ON "payment_allocations"("payment_id", "allocated_at" DESC);

-- CreateIndex
CREATE INDEX "payment_allocations_invoice_id_idx" ON "payment_allocations"("invoice_id");

-- CreateIndex
CREATE INDEX "payment_allocations_insurance_claim_id_idx" ON "payment_allocations"("insurance_claim_id");

-- CreateIndex
CREATE INDEX "payment_allocations_settlement_obligation_id_idx" ON "payment_allocations"("settlement_obligation_id");

-- CreateIndex
CREATE INDEX "refunds_payment_id_requested_at_idx" ON "refunds"("payment_id", "requested_at" DESC);

-- CreateIndex
CREATE INDEX "settlement_cases_organization_id_status_detected_at_idx" ON "settlement_cases"("organization_id", "status", "detected_at" DESC);

-- CreateIndex
CREATE INDEX "settlement_cases_insurance_claim_id_idx" ON "settlement_cases"("insurance_claim_id");

-- CreateIndex
CREATE INDEX "settlement_decisions_settlement_case_id_decided_at_idx" ON "settlement_decisions"("settlement_case_id", "decided_at" DESC);

-- CreateIndex
CREATE INDEX "settlement_obligations_organization_id_status_idx" ON "settlement_obligations"("organization_id", "status");

-- CreateIndex
CREATE INDEX "settlement_obligations_settlement_decision_id_idx" ON "settlement_obligations"("settlement_decision_id");

-- CreateIndex
CREATE INDEX "settlement_ledger_entries_settlement_obligation_id_created__idx" ON "settlement_ledger_entries"("settlement_obligation_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "settlement_ledger_entries_organization_id_created_at_idx" ON "settlement_ledger_entries"("organization_id", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "user_sessions_refresh_token_hash_key" ON "user_sessions"("refresh_token_hash");

-- CreateIndex
CREATE INDEX "user_sessions_user_id_revoked_at_idx" ON "user_sessions"("user_id", "revoked_at");

-- CreateIndex
CREATE INDEX "user_sessions_expires_at_revoked_at_idx" ON "user_sessions"("expires_at", "revoked_at");

-- CreateIndex
CREATE INDEX "user_sessions_session_family_idx" ON "user_sessions"("session_family");

-- CreateIndex
CREATE INDEX "record_transfer_requests_patient_id_created_at_idx" ON "record_transfer_requests"("patient_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "record_transfer_requests_source_organization_id_status_idx" ON "record_transfer_requests"("source_organization_id", "status");

-- CreateIndex
CREATE INDEX "record_transfer_requests_target_organization_id_status_idx" ON "record_transfer_requests"("target_organization_id", "status");

-- CreateIndex
CREATE INDEX "emergency_access_grants_patient_id_status_idx" ON "emergency_access_grants"("patient_id", "status");

-- CreateIndex
CREATE INDEX "emergency_access_grants_organization_id_status_idx" ON "emergency_access_grants"("organization_id", "status");

-- CreateIndex
CREATE INDEX "kyc_verifications_entity_type_status_created_at_idx" ON "kyc_verifications"("entity_type", "status", "created_at" DESC);

-- CreateIndex
CREATE INDEX "kyc_verifications_user_id_idx" ON "kyc_verifications"("user_id");

-- CreateIndex
CREATE INDEX "kyc_verifications_provider_id_idx" ON "kyc_verifications"("provider_id");

-- CreateIndex
CREATE INDEX "kyc_verifications_organization_id_idx" ON "kyc_verifications"("organization_id");

-- CreateIndex
CREATE INDEX "User_phone_hash_idx" ON "User"("phone_hash");

-- CreateIndex
CREATE INDEX "digital_signatures_signer_user_id_signed_at_idx" ON "digital_signatures"("signer_user_id", "signed_at");

-- CreateIndex
CREATE INDEX "digital_signatures_signer_provider_id_signed_at_idx" ON "digital_signatures"("signer_provider_id", "signed_at");

-- CreateIndex
CREATE INDEX "patient_insurance_patient_organization_id_idx" ON "patient_insurance"("patient_organization_id");

-- CreateIndex
CREATE INDEX "roles_organization_id_name_idx" ON "roles"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "roles_scope_key_name_key" ON "roles"("scope_key", "name");

-- CreateIndex
CREATE INDEX "user_roles_granted_by_idx" ON "user_roles"("granted_by");

-- AddForeignKey
ALTER TABLE "patients" ADD CONSTRAINT "patients_closed_by_fkey" FOREIGN KEY ("closed_by") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_relationships" ADD CONSTRAINT "organization_relationships_source_organization_id_fkey" FOREIGN KEY ("source_organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_relationships" ADD CONSTRAINT "organization_relationships_target_organization_id_fkey" FOREIGN KEY ("target_organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_capabilities" ADD CONSTRAINT "organization_capabilities_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_contracts" ADD CONSTRAINT "organization_contracts_organization_relationship_id_fkey" FOREIGN KEY ("organization_relationship_id") REFERENCES "organization_relationships"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_contracts" ADD CONSTRAINT "organization_contracts_primary_organization_id_fkey" FOREIGN KEY ("primary_organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_contracts" ADD CONSTRAINT "organization_contracts_secondary_organization_id_fkey" FOREIGN KEY ("secondary_organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reaction_reports" ADD CONSTRAINT "reaction_reports_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reaction_reports" ADD CONSTRAINT "reaction_reports_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "encounters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reaction_reports" ADD CONSTRAINT "reaction_reports_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "healthcare_providers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reaction_reports" ADD CONSTRAINT "reaction_reports_reported_by_user_id_fkey" FOREIGN KEY ("reported_by_user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_organizations" ADD CONSTRAINT "patient_organizations_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_organizations" ADD CONSTRAINT "patient_organizations_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_organizations" ADD CONSTRAINT "patient_organizations_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "healthcare_providers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescription_routing" ADD CONSTRAINT "prescription_routing_prescription_id_fkey" FOREIGN KEY ("prescription_id") REFERENCES "prescriptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescription_routing" ADD CONSTRAINT "prescription_routing_source_hospital_id_fkey" FOREIGN KEY ("source_hospital_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescription_routing" ADD CONSTRAINT "prescription_routing_target_pharmacy_id_fkey" FOREIGN KEY ("target_pharmacy_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescription_routing" ADD CONSTRAINT "prescription_routing_relationship_id_fkey" FOREIGN KEY ("relationship_id") REFERENCES "organization_relationships"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescription_clarifications" ADD CONSTRAINT "prescription_clarifications_prescription_id_fkey" FOREIGN KEY ("prescription_id") REFERENCES "prescriptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescription_clarifications" ADD CONSTRAINT "prescription_clarifications_pharmacy_id_fkey" FOREIGN KEY ("pharmacy_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_insurance" ADD CONSTRAINT "patient_insurance_patient_organization_id_fkey" FOREIGN KEY ("patient_organization_id") REFERENCES "patient_organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "eligibility_checks" ADD CONSTRAINT "eligibility_checks_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "eligibility_checks" ADD CONSTRAINT "eligibility_checks_coverage_enrollment_id_fkey" FOREIGN KEY ("coverage_enrollment_id") REFERENCES "patient_insurance"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "eligibility_checks" ADD CONSTRAINT "eligibility_checks_insurance_company_id_fkey" FOREIGN KEY ("insurance_company_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "eligibility_checks" ADD CONSTRAINT "eligibility_checks_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "insurance_plans"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "eligibility_checks" ADD CONSTRAINT "eligibility_checks_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "eligibility_checks" ADD CONSTRAINT "eligibility_checks_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "encounters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "claim_lines" ADD CONSTRAINT "claim_lines_insurance_claim_id_fkey" FOREIGN KEY ("insurance_claim_id") REFERENCES "insurance_claims"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "claim_submission_logs" ADD CONSTRAINT "claim_submission_logs_insurance_claim_id_fkey" FOREIGN KEY ("insurance_claim_id") REFERENCES "insurance_claims"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "claim_submission_logs" ADD CONSTRAINT "claim_submission_logs_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "claim_submission_logs" ADD CONSTRAINT "claim_submission_logs_external_system_id_fkey" FOREIGN KEY ("external_system_id") REFERENCES "external_systems"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_lines" ADD CONSTRAINT "invoice_lines_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_allocations" ADD CONSTRAINT "payment_allocations_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "payments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_allocations" ADD CONSTRAINT "payment_allocations_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_allocations" ADD CONSTRAINT "payment_allocations_insurance_claim_id_fkey" FOREIGN KEY ("insurance_claim_id") REFERENCES "insurance_claims"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_allocations" ADD CONSTRAINT "payment_allocations_settlement_obligation_id_fkey" FOREIGN KEY ("settlement_obligation_id") REFERENCES "settlement_obligations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refunds" ADD CONSTRAINT "refunds_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "payments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settlement_cases" ADD CONSTRAINT "settlement_cases_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settlement_cases" ADD CONSTRAINT "settlement_cases_insurance_claim_id_fkey" FOREIGN KEY ("insurance_claim_id") REFERENCES "insurance_claims"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settlement_cases" ADD CONSTRAINT "settlement_cases_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settlement_cases" ADD CONSTRAINT "settlement_cases_prescription_routing_id_fkey" FOREIGN KEY ("prescription_routing_id") REFERENCES "prescription_routing"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settlement_cases" ADD CONSTRAINT "settlement_cases_relationship_id_fkey" FOREIGN KEY ("relationship_id") REFERENCES "organization_relationships"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settlement_decisions" ADD CONSTRAINT "settlement_decisions_settlement_case_id_fkey" FOREIGN KEY ("settlement_case_id") REFERENCES "settlement_cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settlement_obligations" ADD CONSTRAINT "settlement_obligations_settlement_decision_id_fkey" FOREIGN KEY ("settlement_decision_id") REFERENCES "settlement_decisions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settlement_obligations" ADD CONSTRAINT "settlement_obligations_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settlement_ledger_entries" ADD CONSTRAINT "settlement_ledger_entries_settlement_obligation_id_fkey" FOREIGN KEY ("settlement_obligation_id") REFERENCES "settlement_obligations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settlement_ledger_entries" ADD CONSTRAINT "settlement_ledger_entries_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_sessions" ADD CONSTRAINT "user_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_granted_by_fkey" FOREIGN KEY ("granted_by") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "digital_signatures" ADD CONSTRAINT "digital_signatures_signer_user_fkey" FOREIGN KEY ("signer_user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "digital_signatures" ADD CONSTRAINT "digital_signatures_signer_provider_fkey" FOREIGN KEY ("signer_provider_id") REFERENCES "healthcare_providers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "record_transfer_requests" ADD CONSTRAINT "record_transfer_requests_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "record_transfer_requests" ADD CONSTRAINT "record_transfer_requests_source_organization_id_fkey" FOREIGN KEY ("source_organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "record_transfer_requests" ADD CONSTRAINT "record_transfer_requests_target_organization_id_fkey" FOREIGN KEY ("target_organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "record_transfer_requests" ADD CONSTRAINT "record_transfer_requests_consent_grant_id_fkey" FOREIGN KEY ("consent_grant_id") REFERENCES "data_consents"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "emergency_access_grants" ADD CONSTRAINT "emergency_access_grants_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "emergency_access_grants" ADD CONSTRAINT "emergency_access_grants_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_verifications" ADD CONSTRAINT "kyc_verifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_verifications" ADD CONSTRAINT "kyc_verifications_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "healthcare_providers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_verifications" ADD CONSTRAINT "kyc_verifications_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

COMMIT;
