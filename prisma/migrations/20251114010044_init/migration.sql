-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CreateEnum
CREATE TYPE "AccountType" AS ENUM ('INDIVIDUAL', 'HEALTHCARE_PROVIDER', 'ORGANIZATION', 'SYSTEM_ADMIN');

-- CreateEnum
CREATE TYPE "AccountStatus" AS ENUM ('PENDING_VERIFICATION', 'ACTIVE', 'SUSPENDED', 'INACTIVE', 'DEACTIVATED');

-- CreateEnum
CREATE TYPE "OrganizationType" AS ENUM ('HOSPITAL', 'PHARMACY', 'INSURANCE', 'SUPPLIER', 'LABORATORY', 'IMAGING_CENTER', 'CLINIC');

-- CreateEnum
CREATE TYPE "OrganizationStatus" AS ENUM ('ACTIVE', 'SUSPENDED', 'INACTIVE');

-- CreateEnum
CREATE TYPE "ProviderType" AS ENUM ('DOCTOR', 'NURSE', 'PHARMACIST', 'MEDICAL_ASSISTANT', 'THERAPIST', 'SPECIALIST', 'LABORATORY_TECHNICIAN', 'RADIOLOGIST');

-- CreateEnum
CREATE TYPE "ProviderSpecialty" AS ENUM ('CARDIOLOGY', 'NEUROLOGY', 'PEDIATRICS', 'ONCOLOGY', 'ORTHOPEDICS', 'GENERAL_PRACTICE', 'EMERGENCY_MEDICINE', 'PSYCHIATRY', 'DERMATOLOGY', 'GYNECOLOGY', 'UROLOGY', 'RADIOLOGY', 'PATHOLOGY', 'ANESTHESIOLOGY', 'PHARMACY', 'NURSING', 'PHYSICAL_THERAPY', 'OCCUPATIONAL_THERAPY', 'LAB_TECHNICIAN', 'MEDICAL_ASSISTANT', 'DENTIST', 'OPTOMETRIST', 'OTHER');

-- CreateEnum
CREATE TYPE "ProviderStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'ON_LEAVE', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "PatientStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'DECEASED');

-- CreateEnum
CREATE TYPE "ShiftStatus" AS ENUM ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW');

-- CreateEnum
CREATE TYPE "StaffStatus" AS ENUM ('ON_DUTY', 'OFF_DUTY', 'ON_BREAK', 'ON_CALL', 'SICK_LEAVE', 'VACATION');

-- CreateEnum
CREATE TYPE "ProxyPermission" AS ENUM ('VIEW_RECORDS', 'BOOK_APPOINTMENT', 'RESCHEDULE_APPOINTMENT', 'MAKE_PAYMENT', 'RECEIVE_NOTIFICATIONS', 'ADMINISTER_MEDICATION_REMINDER', 'MANAGE_CARE_PLAN', 'REPORT_INCIDENT', 'UPDATE_PROFILE', 'VIEW_LAB_RESULTS', 'VIEW_IMAGING', 'DOWNLOAD_RECORDS');

-- CreateEnum
CREATE TYPE "OtpType" AS ENUM ('EMAIL_VERIFICATION', 'PHONE_VERIFICATION', 'PASSWORD_RESET', 'TWO_FACTOR', 'CAREGIVER_LINK', 'EMERGENCY_ACCESS', 'PRESCRIPTION_APPROVAL', 'CONSENT_SIGNING');

-- CreateEnum
CREATE TYPE "EmailProvider" AS ENUM ('SMTP', 'SENDGRID', 'MAILGUN', 'SES', 'RESEND', 'TWILIO_SENDGRID', 'POSTMARK', 'CUSTOM');

-- CreateEnum
CREATE TYPE "TokenType" AS ENUM ('ACCESS', 'REFRESH', 'API_KEY', 'VERIFICATION', 'PASSWORD_RESET', 'FHIR_ACCESS');

-- CreateEnum
CREATE TYPE "ConsentType" AS ENUM ('ONE_TIME', 'RECURRING', 'EMERGENCY');

-- CreateEnum
CREATE TYPE "ConsentStatus" AS ENUM ('ACTIVE', 'REVOKED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "EncounterType" AS ENUM ('OUTPATIENT', 'INPATIENT', 'EMERGENCY', 'TELEHEALTH', 'FOLLOWUP', 'VIRTUAL');

-- CreateEnum
CREATE TYPE "EncounterStatus" AS ENUM ('SCHEDULED', 'CHECKED_IN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW');

-- CreateEnum
CREATE TYPE "PrescriptionStatus" AS ENUM ('PENDING', 'SENT_TO_PHARMACY', 'FILLED', 'PARTIALLY_FILLED', 'CANCELLED', 'EXPIRED', 'DISCONTINUED');

-- CreateEnum
CREATE TYPE "LabResultStatus" AS ENUM ('PENDING', 'COLLECTED', 'IN_PROGRESS', 'COMPLETED', 'CORRECTED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "ImagingStatus" AS ENUM ('ORDERED', 'SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "BedType" AS ENUM ('ICU', 'GENERAL', 'PRIVATE', 'SEMI_PRIVATE', 'EMERGENCY', 'MATERNITY', 'PEDIATRIC');

-- CreateEnum
CREATE TYPE "BedStatus" AS ENUM ('AVAILABLE', 'OCCUPIED', 'RESERVED', 'MAINTENANCE', 'QUARANTINE');

-- CreateEnum
CREATE TYPE "EquipmentStatus" AS ENUM ('OPERATIONAL', 'IN_USE', 'MAINTENANCE', 'BROKEN', 'RETIRED');

-- CreateEnum
CREATE TYPE "ProductType" AS ENUM ('MEDICATION', 'EQUIPMENT', 'SUPPLY', 'DEVICE');

-- CreateEnum
CREATE TYPE "PurchaseOrderStatus" AS ENUM ('DRAFT', 'SUBMITTED', 'APPROVED', 'IN_TRANSIT', 'DELIVERED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "InsurancePlanType" AS ENUM ('HMO', 'PPO', 'EPO', 'POS', 'MEDICARE', 'MEDICAID');

-- CreateEnum
CREATE TYPE "InsuranceStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'PENDING');

-- CreateEnum
CREATE TYPE "ClaimStatus" AS ENUM ('DRAFT', 'SUBMITTED', 'IN_REVIEW', 'APPROVED', 'PARTIALLY_APPROVED', 'DENIED', 'APPEALED');

-- CreateEnum
CREATE TYPE "ClaimType" AS ENUM ('MEDICAL', 'PHARMACY', 'DENTAL', 'VISION');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('DRAFT', 'PENDING', 'PARTIALLY_PAID', 'PAID', 'OVERDUE', 'CANCELLED', 'DISPUTED');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'BANK_TRANSFER', 'MOBILE_PAYMENT', 'INSURANCE', 'CHECK');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "NotificationPriority" AS ENUM ('LOW', 'NORMAL', 'HIGH', 'URGENT', 'CRITICAL');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('APPOINTMENT_REMINDER', 'MEDICATION_REMINDER', 'LAB_RESULT_READY', 'PRESCRIPTION_READY', 'BILL_DUE', 'INSURANCE_EXPIRING', 'SHIFT_REMINDER', 'EMERGENCY_ALERT', 'SYSTEM_MAINTENANCE');

-- CreateEnum
CREATE TYPE "MessageType" AS ENUM ('PATIENT_INQUIRY', 'PROVIDER_NOTE', 'PRESCRIPTION_CLARIFICATION', 'REFERRAL', 'GENERAL');

-- CreateEnum
CREATE TYPE "IncidentType" AS ENUM ('UNAUTHORIZED_ACCESS', 'DATA_BREACH', 'PRIVACY_VIOLATION', 'SECURITY_INCIDENT', 'MEDICATION_ERROR', 'FALL', 'ADVERSE_REACTION');

-- CreateEnum
CREATE TYPE "IncidentSeverity" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');

-- CreateEnum
CREATE TYPE "IncidentStatus" AS ENUM ('OPEN', 'INVESTIGATING', 'RESOLVED', 'CLOSED');

-- CreateEnum
CREATE TYPE "SyncType" AS ENUM ('IMPORT', 'EXPORT', 'BIDIRECTIONAL');

-- CreateEnum
CREATE TYPE "SyncStatus" AS ENUM ('IN_PROGRESS', 'COMPLETED', 'FAILED', 'PARTIAL');

-- CreateEnum
CREATE TYPE "ExternalSystemType" AS ENUM ('EHR', 'PHARMACY', 'INSURANCE', 'HIE', 'PACS', 'LABORATORY', 'FHIR_SERVER', 'HL7_INTERFACE');

-- CreateEnum
CREATE TYPE "AuthenticationType" AS ENUM ('OAUTH2', 'API_KEY', 'MUTUAL_TLS', 'BASIC_AUTH', 'JWT');

-- CreateEnum
CREATE TYPE "AddonStatus" AS ENUM ('DRAFT', 'PUBLISHED', 'DISABLED', 'DEPRECATED');

-- CreateEnum
CREATE TYPE "ApiServiceAuthType" AS ENUM ('API_KEY', 'OAUTH2', 'JWT', 'HMAC');

-- CreateEnum
CREATE TYPE "ReminderType" AS ENUM ('MEDICATION', 'APPOINTMENT', 'LAB_TEST', 'EXERCISE', 'DIET', 'VITAL_CHECK', 'WOUND_CARE', 'PHYSICAL_THERAPY', 'CUSTOM');

-- CreateEnum
CREATE TYPE "ReminderFrequency" AS ENUM ('ONE_TIME', 'DAILY', 'WEEKLY', 'MONTHLY', 'CUSTOM');

-- CreateEnum
CREATE TYPE "DeliveryChannel" AS ENUM ('EMAIL', 'SMS', 'PUSH_NOTIFICATION', 'IN_APP', 'PHONE_CALL');

-- CreateEnum
CREATE TYPE "DeliveryStatus" AS ENUM ('PENDING', 'SENT', 'DELIVERED', 'FAILED', 'BOUNCED', 'ACKNOWLEDGED');

-- CreateEnum
CREATE TYPE "RelationshipType" AS ENUM ('PARENT', 'CHILD', 'SIBLING', 'SPOUSE', 'GRANDPARENT', 'GRANDCHILD', 'UNCLE_AUNT', 'NEPHEW_NIECE', 'COUSIN', 'STEP_PARENT', 'STEP_CHILD', 'STEP_SIBLING', 'ADOPTED_PARENT', 'ADOPTED_CHILD', 'GUARDIAN', 'WARD');

-- CreateEnum
CREATE TYPE "FHIRResourceType" AS ENUM ('PATIENT', 'PRACTITIONER', 'ORGANIZATION', 'ENCOUNTER', 'OBSERVATION', 'MEDICATION_REQUEST', 'DIAGNOSTIC_REPORT', 'CONDITION', 'PROCEDURE', 'IMMUNIZATION', 'ALLERGY_INTOLERANCE', 'CARE_PLAN');

-- CreateEnum
CREATE TYPE "HL7MessageType" AS ENUM ('ADT_A01', 'ADT_A03', 'ADT_A08', 'ORM_O01', 'ORU_R01', 'RDE_O11', 'DFT_P03');

-- CreateEnum
CREATE TYPE "AuditAction" AS ENUM ('CREATE', 'READ', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT', 'EXPORT', 'PRINT', 'SHARE', 'REVOKE', 'APPROVE', 'REJECT');

-- CreateTable
CREATE TABLE "User" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "account_type" "AccountType" NOT NULL,
    "first_name" VARCHAR(100) NOT NULL,
    "middle_name" VARCHAR(100),
    "last_name" VARCHAR(100) NOT NULL,
    "date_of_birth" DATE NOT NULL,
    "gender" VARCHAR(20),
    "email_encrypted" BYTEA NOT NULL,
    "email_hash" VARCHAR(64) NOT NULL,
    "phone_encrypted" BYTEA NOT NULL,
    "phone_hash" VARCHAR(64) NOT NULL,
    "address" JSONB,
    "password_hash" VARCHAR(255) NOT NULL,
    "password_salt" VARCHAR(255) NOT NULL,
    "password_changed_at" TIMESTAMP(3),
    "failed_login_attempts" INTEGER NOT NULL DEFAULT 0,
    "locked_until" TIMESTAMP(3),
    "two_factor_enabled" BOOLEAN NOT NULL DEFAULT false,
    "two_factor_secret_encrypted" BYTEA,
    "backup_codes_encrypted" BYTEA,
    "last_login" TIMESTAMP(3),
    "last_activity" TIMESTAMP(3),
    "session_token" VARCHAR(255),
    "status" "AccountStatus" NOT NULL DEFAULT 'PENDING_VERIFICATION',
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "phone_verified" BOOLEAN NOT NULL DEFAULT false,
    "profile_picture_url" TEXT,
    "timezone" VARCHAR(50) DEFAULT 'UTC',
    "locale" VARCHAR(10) DEFAULT 'en-US',
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shift_schedules" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "staff_id" UUID,
    "provider_id" UUID,
    "shift_name" VARCHAR(100) NOT NULL,
    "date" DATE NOT NULL,
    "startTime" VARCHAR(5) NOT NULL,
    "endTime" VARCHAR(5) NOT NULL,
    "department" VARCHAR(100),
    "role" VARCHAR(50),
    "status" "ShiftStatus" NOT NULL DEFAULT 'SCHEDULED',
    "actual_start_time" TIMESTAMP(3),
    "actual_end_time" TIMESTAMP(3),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "shift_schedules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff_activities" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "staff_id" UUID NOT NULL,
    "activity_type" VARCHAR(50) NOT NULL,
    "action" TEXT NOT NULL,
    "resource_type" VARCHAR(50),
    "resource_id" UUID,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ipAddress" INET,
    "userAgent" TEXT,
    "location" JSONB,
    "changes" JSONB,
    "metadata" JSONB,

    CONSTRAINT "staff_activities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "otps" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "type" "OtpType" NOT NULL,
    "codeHash" VARCHAR(64) NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,
    "used_at" TIMESTAMP(3),
    "ip_address" INET,
    "userAgent" TEXT,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "otps_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "imaging_studies" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "encounter_id" UUID,
    "organization_id" UUID NOT NULL,
    "ordering_provider_id" UUID,
    "modality" VARCHAR(20) NOT NULL,
    "study_description" VARCHAR(255) NOT NULL,
    "body_part" VARCHAR(100),
    "study_date" TIMESTAMP(3) NOT NULL,
    "accession_number" VARCHAR(50),
    "study_instance_uid" VARCHAR(100),
    "series_count" INTEGER,
    "instance_count" INTEGER,
    "findings" TEXT,
    "impression" TEXT,
    "images_url" TEXT,
    "dicom_server_url" TEXT,
    "status" "ImagingStatus" NOT NULL DEFAULT 'ORDERED',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "imaging_studies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "patients" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "patient_code" VARCHAR(20) NOT NULL,
    "fhir_id" VARCHAR(100),
    "blood_type" VARCHAR(5),
    "height" DECIMAL(5,2),
    "weight" DECIMAL(5,2),
    "emergency_contact" JSONB,
    "ssn_encrypted" BYTEA,
    "mrn_encrypted" BYTEA,
    "status" "PatientStatus" NOT NULL DEFAULT 'ACTIVE',
    "is_deceased" BOOLEAN NOT NULL DEFAULT false,
    "date_of_death" DATE,
    "profile_closed" BOOLEAN NOT NULL DEFAULT false,
    "closed_at" TIMESTAMP(3),
    "closed_by" UUID,
    "closure_reason" TEXT,
    "legacy_access_enabled" BOOLEAN NOT NULL DEFAULT false,
    "registered_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "patients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "healthcare_providers" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "provider_code" VARCHAR(20) NOT NULL,
    "provider_type" "ProviderType" NOT NULL,
    "fhir_id" VARCHAR(100),
    "specialties" "ProviderSpecialty"[] DEFAULT ARRAY[]::"ProviderSpecialty"[],
    "license_number" VARCHAR(100) NOT NULL,
    "license_state" VARCHAR(2),
    "license_expiry" DATE,
    "npi_number" VARCHAR(20),
    "dea_number" VARCHAR(20),
    "primary_specialty" VARCHAR(100),
    "secondary_specialties" JSONB,
    "board_certifications" JSONB,
    "medical_school" VARCHAR(255),
    "graduation_year" INTEGER,
    "years_of_experience" INTEGER,
    "languages_spoken" JSONB,
    "accepting_new_patients" BOOLEAN NOT NULL DEFAULT true,
    "emergency_available" BOOLEAN NOT NULL DEFAULT false,
    "in_emergency_directory" BOOLEAN NOT NULL DEFAULT false,
    "location" JSONB,
    "geog" JSONB,
    "location_updated_at" TIMESTAMP(3),
    "digital_signature_public_key" TEXT,
    "digital_signature_private_key_encrypted" BYTEA,
    "status" "ProviderStatus" NOT NULL DEFAULT 'ACTIVE',
    "verified_at" TIMESTAMP(3),
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "healthcare_providers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_staff" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "staff_code" VARCHAR(20) NOT NULL,
    "job_title" VARCHAR(100) NOT NULL,
    "department" VARCHAR(100),
    "employee_id" VARCHAR(50),
    "work_schedule" JSONB,
    "current_status" "StaffStatus" NOT NULL DEFAULT 'OFF_DUTY',
    "hire_date" DATE NOT NULL,
    "termination_date" DATE,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_staff_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organizations" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "org_type" "OrganizationType" NOT NULL,
    "org_code" VARCHAR(20) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "legal_name" VARCHAR(255) NOT NULL,
    "fhir_id" VARCHAR(100),
    "license_number" VARCHAR(100) NOT NULL,
    "tax_id" VARCHAR(50),
    "npi_number" VARCHAR(20),
    "address" JSONB NOT NULL,
    "contact_info" JSONB NOT NULL,
    "accreditation" JSONB,
    "fhir_endpoint" TEXT,
    "hl7_endpoint" TEXT,
    "status" "OrganizationStatus" NOT NULL DEFAULT 'ACTIVE',
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "verified_at" TIMESTAMP(3),
    "verified_by" UUID,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "organizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "caregivers" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "patient_id" UUID NOT NULL,
    "relationship" VARCHAR(100) NOT NULL,
    "permissions" "ProxyPermission"[] DEFAULT ARRAY[]::"ProxyPermission"[],
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "approved_at" TIMESTAMP(3),
    "approved_by" UUID,
    "expires_at" TIMESTAMP(3),
    "receive_all_notifications" BOOLEAN NOT NULL DEFAULT true,
    "notification_channels" "DeliveryChannel"[] DEFAULT ARRAY['EMAIL', 'SMS']::"DeliveryChannel"[],
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "caregivers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "proxy_action_logs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "caregiver_id" UUID NOT NULL,
    "patient_id" UUID NOT NULL,
    "action" VARCHAR(100) NOT NULL,
    "resource_type" VARCHAR(50),
    "resource_id" UUID,
    "metadata" JSONB,
    "performed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "proxy_action_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff_roles" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "permissions" JSONB NOT NULL,
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "staff_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff_assignments" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "staff_id" UUID NOT NULL,
    "role_id" UUID NOT NULL,
    "assigned_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "assigned_by" UUID,

    CONSTRAINT "staff_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff_clock_ins" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "staff_id" UUID NOT NULL,
    "shift_id" UUID,
    "clock_in" TIMESTAMP(3) NOT NULL,
    "clock_out" TIMESTAMP(3),
    "location" JSONB,
    "ipAddress" INET,
    "break_start" TIMESTAMP(3),
    "break_end" TIMESTAMP(3),
    "total_break_minutes" INTEGER,
    "hours_worked" DECIMAL(5,2),
    "overtime_hours" DECIMAL(5,2),
    "notes" TEXT,

    CONSTRAINT "staff_clock_ins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "email_provider_configs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "provider" "EmailProvider" NOT NULL,
    "host" VARCHAR(255),
    "port" INTEGER,
    "username" TEXT,
    "password_encrypted" BYTEA,
    "api_key_encrypted" BYTEA,
    "fromEmail" VARCHAR(255) NOT NULL,
    "fromName" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "email_provider_configs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "email_logs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID,
    "email_config_id" UUID,
    "toEmail" VARCHAR(255) NOT NULL,
    "subject" TEXT NOT NULL,
    "bodyHash" VARCHAR(64) NOT NULL,
    "provider" "EmailProvider",
    "external_message_id" TEXT,
    "status" "DeliveryStatus" NOT NULL DEFAULT 'SENT',
    "error_message" TEXT,
    "sent_at" TIMESTAMP(3),
    "delivered_at" TIMESTAMP(3),
    "opened_at" TIMESTAMP(3),
    "clicked_at" TIMESTAMP(3),
    "bounced_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "email_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sms_logs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID,
    "toPhone" VARCHAR(20) NOT NULL,
    "messageHash" VARCHAR(64) NOT NULL,
    "provider" VARCHAR(50),
    "external_message_id" TEXT,
    "status" "DeliveryStatus" NOT NULL DEFAULT 'SENT',
    "error_message" TEXT,
    "sent_at" TIMESTAMP(3),
    "delivered_at" TIMESTAMP(3),
    "cost" DECIMAL(10,4),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sms_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "care_plans" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "status" VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    "goals" JSONB[] DEFAULT ARRAY[]::JSONB[],
    "care_team" JSONB[] DEFAULT ARRAY[]::JSONB[],
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "care_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "care_reminders" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "care_plan_id" UUID,
    "prescription_id" UUID,
    "type" "ReminderType" NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "instructions" TEXT,
    "frequency" "ReminderFrequency" NOT NULL,
    "custom_schedule" JSONB,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "notify_minutes_before" INTEGER NOT NULL DEFAULT 10,
    "delivery_channels" "DeliveryChannel"[] DEFAULT ARRAY['EMAIL', 'SMS', 'PUSH_NOTIFICATION']::"DeliveryChannel"[],
    "notify_caregivers" BOOLEAN NOT NULL DEFAULT true,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "care_reminders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reminder_delivery_logs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "reminder_id" UUID NOT NULL,
    "patient_id" UUID NOT NULL,
    "scheduled_for" TIMESTAMP(3) NOT NULL,
    "dosage" TEXT,
    "email_sent" BOOLEAN NOT NULL DEFAULT false,
    "email_status" "DeliveryStatus",
    "email_sent_at" TIMESTAMP(3),
    "sms_sent" BOOLEAN NOT NULL DEFAULT false,
    "sms_status" "DeliveryStatus",
    "sms_sent_at" TIMESTAMP(3),
    "push_sent" BOOLEAN NOT NULL DEFAULT false,
    "push_status" "DeliveryStatus",
    "push_sent_at" TIMESTAMP(3),
    "caregiver_emails_sent" INTEGER NOT NULL DEFAULT 0,
    "caregiver_sms_sent" INTEGER NOT NULL DEFAULT 0,
    "acknowledged" BOOLEAN NOT NULL DEFAULT false,
    "acknowledged_at" TIMESTAMP(3),
    "acknowledged_by" UUID,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "completed_at" TIMESTAMP(3),
    "skipped" BOOLEAN NOT NULL DEFAULT false,
    "skip_reason" TEXT,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reminder_delivery_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "addons" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "slug" VARCHAR(100) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "version" VARCHAR(20) NOT NULL,
    "author_org_id" UUID NOT NULL,
    "addon_type" VARCHAR(50) NOT NULL,
    "config_schema" JSONB,
    "default_config" JSONB,
    "api_endpoints" JSONB,
    "permissions" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "ui_components" JSONB,
    "css_overrides" TEXT,
    "documentation_url" TEXT,
    "icon_url" TEXT,
    "screenshots" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "category" VARCHAR(50),
    "tags" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "pricing_model" VARCHAR(50),
    "monthly_price" DECIMAL(10,2),
    "status" "AddonStatus" NOT NULL DEFAULT 'DRAFT',
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "published_at" TIMESTAMP(3),
    "install_count" INTEGER NOT NULL DEFAULT 0,
    "rating" DECIMAL(2,1),
    "review_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "addons_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "addon_subscriptions" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "addon_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "config" JSONB,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "subscription_type" VARCHAR(20) NOT NULL,
    "trial_ends_at" TIMESTAMP(3),
    "last_used_at" TIMESTAMP(3),
    "usage_count" INTEGER NOT NULL DEFAULT 0,
    "subscribed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "addon_subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "addon_reviews" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "addon_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "rating" INTEGER NOT NULL,
    "title" TEXT,
    "review" TEXT,
    "helpful" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "addon_reviews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "api_services" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "endpoint" TEXT NOT NULL,
    "auth_type" "ApiServiceAuthType" NOT NULL,
    "api_key_encrypted" BYTEA,
    "client_id" TEXT,
    "client_secret_encrypted" BYTEA,
    "token_url" TEXT,
    "scopes" JSONB,
    "rate_limit_per_min" INTEGER NOT NULL DEFAULT 100,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "api_services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "api_usage_logs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "service_id" UUID NOT NULL,
    "ipAddress" INET NOT NULL,
    "endpoint" TEXT NOT NULL,
    "method" VARCHAR(10) NOT NULL,
    "status_code" INTEGER NOT NULL,
    "response_time_ms" INTEGER NOT NULL,
    "requested_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "api_usage_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "api_keys" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "key_hash" VARCHAR(64) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "permissions" JSONB NOT NULL,
    "rate_limit_per_hour" INTEGER NOT NULL DEFAULT 10000,
    "ip_whitelist" TEXT[],
    "active" BOOLEAN NOT NULL DEFAULT true,
    "expires_at" TIMESTAMP(3),
    "last_used_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "api_keys_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_themes" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "logo" TEXT,
    "favicon" TEXT,
    "primary_color" VARCHAR(7),
    "secondary_color" VARCHAR(7),
    "accent_color" VARCHAR(7),
    "font_family" TEXT,
    "font_size" TEXT,
    "layout_style" VARCHAR(20),
    "dashboard_layout" JSONB,
    "custom_css" TEXT,
    "custom_header" TEXT,
    "custom_footer" TEXT,
    "custom_sidebar" TEXT,
    "custom_menu_items" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_themes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "death_certificates" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "certificate_number" VARCHAR(50) NOT NULL,
    "date_of_death" DATE NOT NULL,
    "time_of_death" VARCHAR(8),
    "place_of_death" VARCHAR(255) NOT NULL,
    "location_of_death" JSONB NOT NULL,
    "cause_of_death" TEXT NOT NULL,
    "icd10_code" VARCHAR(10),
    "immediately_cause" TEXT,
    "underlying_cause" TEXT,
    "contributing_factors" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "certified_by" UUID NOT NULL,
    "certifier_name" VARCHAR(255) NOT NULL,
    "certifier_license" VARCHAR(100) NOT NULL,
    "certified_at" TIMESTAMP(3) NOT NULL,
    "autopsy_performed" BOOLEAN NOT NULL DEFAULT false,
    "autopsy_findings" TEXT,
    "certificate_url" TEXT,
    "digital_signature" TEXT,
    "status" VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    "issued_at" TIMESTAMP(3),
    "registry_number" VARCHAR(50),
    "registered_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "death_certificates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "legacy_managers" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "manager_id" UUID NOT NULL,
    "relationship" VARCHAR(100) NOT NULL,
    "permissions" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "authorization_doc" TEXT,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "verified_by" UUID,
    "verified_at" TIMESTAMP(3),
    "active" BOOLEAN NOT NULL DEFAULT true,
    "expires_at" TIMESTAMP(3),
    "assigned_by" UUID,
    "assigned_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "legacy_managers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "family_relationships" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "person_id" UUID NOT NULL,
    "related_person_id" UUID NOT NULL,
    "relationship_type" "RelationshipType" NOT NULL,
    "reverse_relationship" "RelationshipType",
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "verified_by" UUID,
    "verified_at" TIMESTAMP(3),
    "proof_document" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "family_relationships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "genetic_profiles" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "blood_type" VARCHAR(5),
    "rh_factor" VARCHAR(10),
    "genetic_markers" JSONB,
    "hereditary_conditions" JSONB[] DEFAULT ARRAY[]::JSONB[],
    "carrier_status" JSONB[] DEFAULT ARRAY[]::JSONB[],
    "testing_completed" BOOLEAN NOT NULL DEFAULT false,
    "test_date" DATE,
    "test_provider" VARCHAR(255),
    "share_with_family" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "genetic_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "family_health_history" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "condition" VARCHAR(255) NOT NULL,
    "icd_code" VARCHAR(10),
    "snomed_code" VARCHAR(20),
    "affected_relatives" JSONB[] DEFAULT ARRAY[]::JSONB[],
    "inheritance_pattern" VARCHAR(50),
    "risk_level" VARCHAR(20),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "family_health_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "medical_records" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "record_number" VARCHAR(50) NOT NULL,
    "chief_complaint" TEXT,
    "present_illness" TEXT,
    "past_medical_history" JSONB,
    "sharing_enabled" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "medical_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "allergies" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "allergen" VARCHAR(255) NOT NULL,
    "allergen_code" VARCHAR(20),
    "reaction" TEXT,
    "severity" VARCHAR(20) NOT NULL,
    "diagnosed_date" DATE,
    "verified_date" DATE,
    "notes" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "allergies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "patient_medications" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "medication_name" VARCHAR(255) NOT NULL,
    "rxnorm_code" VARCHAR(20),
    "dosage" VARCHAR(100) NOT NULL,
    "frequency" VARCHAR(100) NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "prescribed_by" VARCHAR(255),
    "reason" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "patient_medications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "immunizations" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "vaccine_name" VARCHAR(255) NOT NULL,
    "cvx_code" VARCHAR(10),
    "date_administered" DATE NOT NULL,
    "lot_number" VARCHAR(50),
    "manufacturer" VARCHAR(255),
    "expiration_date" DATE,
    "administered_by" VARCHAR(255),
    "site" VARCHAR(100),
    "route" VARCHAR(100),
    "dose_number" INTEGER,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "immunizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "family_history" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "relationship" VARCHAR(50) NOT NULL,
    "condition" VARCHAR(255) NOT NULL,
    "snomed_code" VARCHAR(20),
    "age_at_diagnosis" INTEGER,
    "age_at_death" INTEGER,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "family_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "social_history" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "smoking_status" VARCHAR(50),
    "alcohol_use" VARCHAR(100),
    "drug_use" VARCHAR(100),
    "occupation" VARCHAR(255),
    "marital_status" VARCHAR(50),
    "living_arrangement" TEXT,
    "exercise_frequency" VARCHAR(100),
    "diet" VARCHAR(100),
    "notes" TEXT,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "social_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vital_signs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "encounter_id" UUID,
    "systolic_bp" INTEGER,
    "diastolic_bp" INTEGER,
    "heart_rate" INTEGER,
    "temperature" DECIMAL(4,1),
    "temperature_unit" VARCHAR(1),
    "respiratory_rate" INTEGER,
    "oxygen_saturation" INTEGER,
    "weight" DECIMAL(6,2),
    "weight_unit" VARCHAR(2),
    "height" DECIMAL(6,2),
    "height_unit" VARCHAR(2),
    "bmi" DECIMAL(4,1),
    "recorded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "recorded_by" VARCHAR(255),
    "notes" TEXT,

    CONSTRAINT "vital_signs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "appointments" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "appointment_number" VARCHAR(50) NOT NULL,
    "patient_id" UUID NOT NULL,
    "provider_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "appointment_type" VARCHAR(50) NOT NULL,
    "reason_for_visit" TEXT NOT NULL,
    "scheduled_start" TIMESTAMP(3) NOT NULL,
    "scheduled_end" TIMESTAMP(3) NOT NULL,
    "status" VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED',
    "checked_in_at" TIMESTAMP(3),
    "cancelled_at" TIMESTAMP(3),
    "cancellation_reason" TEXT,
    "reminder_sent" BOOLEAN NOT NULL DEFAULT false,
    "reminder_sent_at" TIMESTAMP(3),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "appointments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "encounters" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "encounter_number" VARCHAR(50) NOT NULL,
    "patient_id" UUID NOT NULL,
    "medical_record_id" UUID,
    "provider_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "appointment_id" UUID,
    "encounter_type" "EncounterType" NOT NULL,
    "started_at" TIMESTAMP(3),
    "ended_at" TIMESTAMP(3),
    "chief_complaint" TEXT,
    "history_of_present_illness" TEXT,
    "review_of_systems" JSONB,
    "physical_examination" TEXT,
    "assessment" TEXT,
    "plan" TEXT,
    "diagnosis_codes" JSONB,
    "procedure_codes" JSONB,
    "discharge_disposition" VARCHAR(50),
    "discharge_instructions" TEXT,
    "follow_up_instructions" TEXT,
    "status" "EncounterStatus" NOT NULL DEFAULT 'SCHEDULED',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "encounters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "provider_schedules" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "provider_id" UUID NOT NULL,
    "dayOfWeek" INTEGER NOT NULL,
    "start_time" VARCHAR(5) NOT NULL,
    "end_time" VARCHAR(5) NOT NULL,
    "slot_duration" INTEGER NOT NULL DEFAULT 30,
    "effective_from" DATE NOT NULL,
    "effective_to" DATE,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "provider_schedules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prescriptions" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "prescription_number" VARCHAR(50) NOT NULL,
    "patient_id" UUID NOT NULL,
    "encounter_id" UUID,
    "provider_id" UUID NOT NULL,
    "hospital_id" UUID NOT NULL,
    "pharmacy_id" UUID,
    "medication_name" VARCHAR(255) NOT NULL,
    "rxnorm_code" VARCHAR(20),
    "strength" VARCHAR(50) NOT NULL,
    "dosage_form" VARCHAR(50) NOT NULL,
    "quantity" DECIMAL(10,2) NOT NULL,
    "unit" VARCHAR(20) NOT NULL,
    "dosage_schedule" JSONB NOT NULL,
    "dosage_instructions" TEXT NOT NULL,
    "route" VARCHAR(50),
    "frequency" VARCHAR(100),
    "duration_days" INTEGER,
    "start_date" DATE,
    "end_date" DATE,
    "timing_instructions" TEXT,
    "refills_allowed" INTEGER NOT NULL DEFAULT 0,
    "refills_remaining" INTEGER,
    "indication" TEXT,
    "status" "PrescriptionStatus" NOT NULL DEFAULT 'PENDING',
    "prescribed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sent_to_pharmacy_at" TIMESTAMP(3),
    "filled_at" TIMESTAMP(3),
    "expires_at" TIMESTAMP(3),
    "controlled_substance" BOOLEAN NOT NULL DEFAULT false,
    "dea_schedule" VARCHAR(5),
    "digital_signature_hash" VARCHAR(64),
    "signed_at" TIMESTAMP(3),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "prescriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prescription_dispenses" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "prescription_id" UUID NOT NULL,
    "pharmacy_id" UUID NOT NULL,
    "pharmacist_user_id" UUID NOT NULL,
    "quantity_dispensed" DECIMAL(10,2) NOT NULL,
    "unit" VARCHAR(20) NOT NULL,
    "dispensed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lot_number" VARCHAR(50),
    "expiration_date" DATE,
    "instructions_given" TEXT,
    "counseling_provided" BOOLEAN NOT NULL DEFAULT false,
    "medication_cost" DECIMAL(10,2),
    "dispensing_fee" DECIMAL(10,2),
    "total_cost" DECIMAL(10,2),
    "notes" TEXT,

    CONSTRAINT "prescription_dispenses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prescription_footprints" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "prescription_id" UUID NOT NULL,
    "actor_id" UUID NOT NULL,
    "actor_name" VARCHAR(255) NOT NULL,
    "actor_role" VARCHAR(50) NOT NULL,
    "action" VARCHAR(50) NOT NULL,
    "changes" JSONB,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ipAddress" INET,
    "location" JSONB,
    "digital_signature" TEXT,

    CONSTRAINT "prescription_footprints_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pharmacy_inventory" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "pharmacy_id" UUID NOT NULL,
    "medication_name" VARCHAR(255) NOT NULL,
    "rxnorm_code" VARCHAR(20) NOT NULL,
    "strength" VARCHAR(50) NOT NULL,
    "dosage_form" VARCHAR(50) NOT NULL,
    "manufacturer" VARCHAR(255),
    "quantity_in_stock" DECIMAL(10,2) NOT NULL,
    "unit" VARCHAR(20) NOT NULL,
    "reorder_level" DECIMAL(10,2),
    "reorder_quantity" DECIMAL(10,2),
    "unit_cost" DECIMAL(10,2),
    "lot_number" VARCHAR(50),
    "expiration_date" DATE,
    "status" VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
    "last_updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pharmacy_inventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lab_orders" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "order_number" VARCHAR(50) NOT NULL,
    "patient_id" UUID NOT NULL,
    "encounter_id" UUID,
    "ordering_provider_id" UUID NOT NULL,
    "ordering_hospital_id" UUID NOT NULL,
    "lab_id" UUID NOT NULL,
    "partner_lab" BOOLEAN NOT NULL DEFAULT false,
    "tests" JSONB[] DEFAULT ARRAY[]::JSONB[],
    "priority" VARCHAR(20) NOT NULL DEFAULT 'ROUTINE',
    "specimen_type" VARCHAR(100),
    "collected_at" TIMESTAMP(3),
    "received_at_lab" TIMESTAMP(3),
    "status" VARCHAR(20) NOT NULL DEFAULT 'ORDERED',
    "clinical_notes" TEXT,
    "diagnosis_codes" JSONB,
    "result_transmitted_at" TIMESTAMP(3),
    "transmission_method" VARCHAR(20),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "lab_orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lab_results" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "lab_order_id" UUID NOT NULL,
    "patient_id" UUID NOT NULL,
    "encounter_id" UUID,
    "organization_id" UUID NOT NULL,
    "test_code" VARCHAR(20) NOT NULL,
    "test_name" VARCHAR(255) NOT NULL,
    "loinc_code" VARCHAR(20),
    "result_value" VARCHAR(255),
    "result_unit" VARCHAR(50),
    "reference_range" VARCHAR(100),
    "abnormal_flag" VARCHAR(20),
    "interpretation" TEXT,
    "status" "LabResultStatus" NOT NULL DEFAULT 'PENDING',
    "ordered_at" TIMESTAMP(3) NOT NULL,
    "collected_at" TIMESTAMP(3),
    "resulted_at" TIMESTAMP(3),
    "verified_at" TIMESTAMP(3),
    "performing_lab" VARCHAR(255),
    "technician" VARCHAR(255),
    "pathologist" VARCHAR(255),
    "transmitted_to" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "transmitted_at" TIMESTAMP(3),
    "attachments" JSONB,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lab_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lab_partnerships" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "hospital_id" UUID NOT NULL,
    "lab_id" UUID NOT NULL,
    "partnership_type" VARCHAR(50) NOT NULL,
    "integration_method" VARCHAR(20) NOT NULL,
    "api_endpoint" TEXT,
    "api_key_encrypted" BYTEA,
    "turnaround_time" JSONB,
    "pricing" JSONB,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lab_partnerships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "insurance_plans" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "insurance_company_id" UUID NOT NULL,
    "plan_code" VARCHAR(50) NOT NULL,
    "plan_name" VARCHAR(255) NOT NULL,
    "plan_type" "InsurancePlanType" NOT NULL,
    "coverage_details" JSONB NOT NULL,
    "premium_monthly" DECIMAL(10,2),
    "deductible_individual" DECIMAL(10,2),
    "deductible_family" DECIMAL(10,2),
    "out_of_pocket_max" DECIMAL(10,2),
    "copay_primary_care" DECIMAL(10,2),
    "copay_specialist" DECIMAL(10,2),
    "copay_emergency" DECIMAL(10,2),
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "insurance_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "patient_insurance" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "insurance_company_id" UUID NOT NULL,
    "plan_id" UUID NOT NULL,
    "policy_number" VARCHAR(100) NOT NULL,
    "group_number" VARCHAR(100),
    "is_primary" BOOLEAN NOT NULL DEFAULT true,
    "subscriber_name" VARCHAR(255) NOT NULL,
    "subscriber_dob" DATE NOT NULL,
    "relationship_to_subscriber" VARCHAR(50) NOT NULL,
    "effective_date" DATE NOT NULL,
    "termination_date" DATE,
    "status" "InsuranceStatus" NOT NULL DEFAULT 'ACTIVE',
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "verified_at" TIMESTAMP(3),
    "verification_response" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "patient_insurance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "insurance_claims" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "claim_number" VARCHAR(50) NOT NULL,
    "patient_id" UUID NOT NULL,
    "patient_insurance_id" UUID NOT NULL,
    "encounter_id" UUID,
    "insurance_company_id" UUID NOT NULL,
    "claim_type" "ClaimType" NOT NULL,
    "diagnosis_codes" JSONB NOT NULL,
    "procedure_codes" JSONB NOT NULL,
    "service_date" DATE NOT NULL,
    "total_charges" DECIMAL(10,2) NOT NULL,
    "approved_amount" DECIMAL(10,2),
    "patient_responsibility" DECIMAL(10,2),
    "status" "ClaimStatus" NOT NULL DEFAULT 'DRAFT',
    "submitted_at" TIMESTAMP(3),
    "processed_at" TIMESTAMP(3),
    "paid_at" TIMESTAMP(3),
    "denial_reason" TEXT,
    "transmission_method" VARCHAR(20),
    "external_claim_id" VARCHAR(100),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "insurance_claims_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "invoice_number" VARCHAR(50) NOT NULL,
    "patient_id" UUID NOT NULL,
    "encounter_id" UUID,
    "hospital_id" UUID,
    "pharmacy_id" UUID,
    "items" JSONB[] DEFAULT ARRAY[]::JSONB[],
    "subtotal" DECIMAL(10,2) NOT NULL,
    "tax" DECIMAL(10,2),
    "discount" DECIMAL(10,2),
    "total_amount" DECIMAL(10,2) NOT NULL,
    "amount_paid" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "balance" DECIMAL(10,2) NOT NULL,
    "status" "InvoiceStatus" NOT NULL DEFAULT 'PENDING',
    "issued_date" DATE NOT NULL,
    "due_date" DATE NOT NULL,
    "paid_date" DATE,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "invoice_id" UUID NOT NULL,
    "patient_id" UUID NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "method" "PaymentMethod" NOT NULL,
    "status" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "transaction_id" VARCHAR(100),
    "processed_at" TIMESTAMP(3),
    "gateway_response" JSONB,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hospital_departments" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "description" TEXT,
    "location" VARCHAR(255),
    "phone_number" VARCHAR(20),
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "hospital_departments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hospital_beds" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "department_id" UUID NOT NULL,
    "bed_number" VARCHAR(20) NOT NULL,
    "bed_type" "BedType" NOT NULL,
    "status" "BedStatus" NOT NULL DEFAULT 'AVAILABLE',
    "current_patient_id" UUID,
    "assigned_at" TIMESTAMP(3),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "hospital_beds_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "medical_equipment" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "equipment_code" VARCHAR(50) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "manufacturer" VARCHAR(255),
    "model" VARCHAR(100),
    "serial_number" VARCHAR(100),
    "location" VARCHAR(255),
    "purchase_date" DATE,
    "warranty_expiry" DATE,
    "status" "EquipmentStatus" NOT NULL DEFAULT 'OPERATIONAL',
    "last_maintenance" DATE,
    "next_maintenance" DATE,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "medical_equipment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "products" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "product_code" VARCHAR(50) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "product_type" "ProductType" NOT NULL,
    "manufacturer" VARCHAR(255),
    "unit_price" DECIMAL(10,2) NOT NULL,
    "unit" VARCHAR(20) NOT NULL,
    "description" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_orders" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "order_number" VARCHAR(50) NOT NULL,
    "hospital_id" UUID NOT NULL,
    "supplier_id" UUID NOT NULL,
    "items" JSONB[] DEFAULT ARRAY[]::JSONB[],
    "total_amount" DECIMAL(10,2) NOT NULL,
    "status" "PurchaseOrderStatus" NOT NULL DEFAULT 'DRAFT',
    "ordered_date" DATE NOT NULL,
    "expected_date" DATE,
    "delivered_date" DATE,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "purchase_orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fhir_resources" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "resource_type" "FHIRResourceType" NOT NULL,
    "fhir_id" VARCHAR(100) NOT NULL,
    "patient_id" UUID,
    "provider_id" UUID,
    "organization_id" UUID,
    "resource_json" JSONB NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "fhir_resources_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hl7_messages" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "message_type" "HL7MessageType" NOT NULL,
    "organization_id" UUID NOT NULL,
    "message_content" TEXT NOT NULL,
    "message_hash" VARCHAR(64) NOT NULL,
    "status" VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    "processed_at" TIMESTAMP(3),
    "error_message" TEXT,
    "ack_sent" BOOLEAN NOT NULL DEFAULT false,
    "ack_message" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "hl7_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "access_tokens" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "token_hash" VARCHAR(64) NOT NULL,
    "token_type" "TokenType" NOT NULL,
    "scope" JSONB NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "revoked" BOOLEAN NOT NULL DEFAULT false,
    "revoked_at" TIMESTAMP(3),
    "revoked_reason" TEXT,
    "last_used_at" TIMESTAMP(3),
    "ip_address" INET,
    "userAgent" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "access_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "permissions" JSONB NOT NULL,
    "organization_id" UUID,
    "system_role" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_roles" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "role_id" UUID NOT NULL,
    "granted_by" UUID,
    "granted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3),

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "access_logs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID,
    "resource_type" VARCHAR(50) NOT NULL,
    "resource_id" UUID NOT NULL,
    "action" VARCHAR(50) NOT NULL,
    "access_granted" BOOLEAN NOT NULL,
    "denial_reason" TEXT,
    "ip_address" INET,
    "userAgent" TEXT,
    "request_metadata" JSONB,
    "accessed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "access_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "patient_access_logs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "accessor_id" UUID NOT NULL,
    "accessor_type" VARCHAR(50) NOT NULL,
    "organization_id" UUID,
    "action_type" VARCHAR(50) NOT NULL,
    "resource_type" VARCHAR(50),
    "resource_id" UUID,
    "action_details" TEXT NOT NULL,
    "changes_json" JSONB,
    "accessed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ipAddress" INET,
    "userAgent" TEXT,
    "location" JSONB,
    "encounter_id" UUID,
    "purpose" VARCHAR(100),

    CONSTRAINT "patient_access_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID,
    "action" "AuditAction" NOT NULL,
    "resource_type" VARCHAR(50) NOT NULL,
    "resource_id" UUID,
    "old_values" JSONB,
    "new_values" JSONB,
    "previous_hash" VARCHAR(64),
    "current_hash" VARCHAR(64) NOT NULL,
    "ip_address" INET,
    "userAgent" TEXT,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "digital_signatures" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "signer_id" UUID NOT NULL,
    "signer_type" VARCHAR(50) NOT NULL,
    "resource_type" VARCHAR(50) NOT NULL,
    "resource_id" UUID NOT NULL,
    "signature_hash" VARCHAR(128) NOT NULL,
    "algorithm" VARCHAR(50) NOT NULL,
    "certificate_data" TEXT,
    "signed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "metadata" JSONB,

    CONSTRAINT "digital_signatures_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "data_consents" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "patient_id" UUID NOT NULL,
    "grantor_org_id" UUID,
    "grantee_org_id" UUID,
    "data_scope" JSONB NOT NULL,
    "purpose" TEXT NOT NULL,
    "consent_type" "ConsentType" NOT NULL,
    "status" "ConsentStatus" NOT NULL DEFAULT 'ACTIVE',
    "granted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3),
    "revoked_at" TIMESTAMP(3),
    "revocation_reason" TEXT,
    "signature_hash" VARCHAR(64),
    "signed_at" TIMESTAMP(3),
    "metadata" JSONB,

    CONSTRAINT "data_consents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "compliance_incidents" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "incident_type" "IncidentType" NOT NULL,
    "severity" "IncidentSeverity" NOT NULL,
    "status" "IncidentStatus" NOT NULL DEFAULT 'OPEN',
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT NOT NULL,
    "reported_by" UUID NOT NULL,
    "assigned_to" UUID,
    "affected_patients" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "affected_systems" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "occurred_at" TIMESTAMP(3) NOT NULL,
    "detected_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_at" TIMESTAMP(3),
    "remediation_steps" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "compliance_incidents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "type" "NotificationType" NOT NULL,
    "priority" "NotificationPriority" NOT NULL DEFAULT 'NORMAL',
    "title" VARCHAR(255) NOT NULL,
    "message" TEXT NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "read_at" TIMESTAMP(3),
    "action_url" TEXT,
    "action_data" JSONB,
    "sent_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3),

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "messages" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "sender_id" UUID NOT NULL,
    "recipient_id" UUID NOT NULL,
    "message_type" "MessageType" NOT NULL,
    "subject" VARCHAR(255),
    "body" TEXT NOT NULL,
    "attachments" JSONB,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "read_at" TIMESTAMP(3),
    "replied_to" UUID,
    "sent_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "system_settings" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID,
    "key" VARCHAR(100) NOT NULL,
    "value" JSONB NOT NULL,
    "description" TEXT,
    "is_encrypted" BOOLEAN NOT NULL DEFAULT false,
    "updated_by" UUID NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "system_settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "external_systems" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "system_type" "ExternalSystemType" NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "endpoint" TEXT NOT NULL,
    "authentication_type" "AuthenticationType" NOT NULL,
    "credentials" JSONB,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "last_sync_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "external_systems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "data_sync_logs" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "external_system_id" UUID NOT NULL,
    "sync_type" "SyncType" NOT NULL,
    "status" "SyncStatus" NOT NULL,
    "records_processed" INTEGER NOT NULL DEFAULT 0,
    "records_failed" INTEGER NOT NULL DEFAULT 0,
    "error_message" TEXT,
    "started_at" TIMESTAMP(3) NOT NULL,
    "completed_at" TIMESTAMP(3),

    CONSTRAINT "data_sync_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "webhook_subscriptions" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "event_type" VARCHAR(100) NOT NULL,
    "url" TEXT NOT NULL,
    "secret" VARCHAR(255) NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "webhook_subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "webhook_deliveries" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "subscription_id" UUID NOT NULL,
    "event_type" VARCHAR(100) NOT NULL,
    "payload" JSONB NOT NULL,
    "status" VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    "http_status" INTEGER,
    "response" TEXT,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "next_retry" TIMESTAMP(3),
    "delivered_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "webhook_deliveries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "data_export_requests" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "user_id" UUID NOT NULL,
    "export_type" VARCHAR(50) NOT NULL,
    "format" VARCHAR(20) NOT NULL,
    "date_range" JSONB,
    "filters" JSONB,
    "status" VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    "file_url" TEXT,
    "file_size" INTEGER,
    "expires_at" TIMESTAMP(3),
    "requested_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMP(3),

    CONSTRAINT "data_export_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "provider_organizations" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "provider_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "is_primary_affiliation" BOOLEAN NOT NULL DEFAULT false,
    "department" VARCHAR(100),
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "credentialed_at" TIMESTAMP(3),
    "privileges_granted" JSONB,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "provider_organizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_ManagedUser" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL,

    CONSTRAINT "_ManagedUser_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_encrypted_key" ON "User"("email_encrypted");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_hash_key" ON "User"("email_hash");

-- CreateIndex
CREATE UNIQUE INDEX "User_session_token_key" ON "User"("session_token");

-- CreateIndex
CREATE INDEX "shift_schedules_organization_id_date_idx" ON "shift_schedules"("organization_id", "date");

-- CreateIndex
CREATE INDEX "shift_schedules_staff_id_date_idx" ON "shift_schedules"("staff_id", "date");

-- CreateIndex
CREATE INDEX "shift_schedules_provider_id_date_idx" ON "shift_schedules"("provider_id", "date");

-- CreateIndex
CREATE INDEX "shift_schedules_status_idx" ON "shift_schedules"("status");

-- CreateIndex
CREATE INDEX "staff_activities_staff_id_timestamp_idx" ON "staff_activities"("staff_id", "timestamp" DESC);

-- CreateIndex
CREATE INDEX "staff_activities_resource_type_resource_id_timestamp_idx" ON "staff_activities"("resource_type", "resource_id", "timestamp");

-- CreateIndex
CREATE INDEX "otps_user_id_type_created_at_idx" ON "otps"("user_id", "type", "created_at" DESC);

-- CreateIndex
CREATE INDEX "otps_codeHash_used_idx" ON "otps"("codeHash", "used");

-- CreateIndex
CREATE UNIQUE INDEX "imaging_studies_accession_number_key" ON "imaging_studies"("accession_number");

-- CreateIndex
CREATE INDEX "imaging_studies_patient_id_study_date_idx" ON "imaging_studies"("patient_id", "study_date");

-- CreateIndex
CREATE INDEX "imaging_studies_encounter_id_idx" ON "imaging_studies"("encounter_id");

-- CreateIndex
CREATE INDEX "imaging_studies_accession_number_idx" ON "imaging_studies"("accession_number");

-- CreateIndex
CREATE UNIQUE INDEX "patients_patient_code_key" ON "patients"("patient_code");

-- CreateIndex
CREATE UNIQUE INDEX "patients_fhir_id_key" ON "patients"("fhir_id");

-- CreateIndex
CREATE INDEX "patients_patient_code_idx" ON "patients"("patient_code");

-- CreateIndex
CREATE INDEX "patients_user_id_idx" ON "patients"("user_id");

-- CreateIndex
CREATE INDEX "patients_fhir_id_idx" ON "patients"("fhir_id");

-- CreateIndex
CREATE INDEX "patients_status_deleted_at_idx" ON "patients"("status", "deleted_at");

-- CreateIndex
CREATE INDEX "patients_is_deceased_idx" ON "patients"("is_deceased");

-- CreateIndex
CREATE UNIQUE INDEX "healthcare_providers_user_id_key" ON "healthcare_providers"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "healthcare_providers_provider_code_key" ON "healthcare_providers"("provider_code");

-- CreateIndex
CREATE UNIQUE INDEX "healthcare_providers_fhir_id_key" ON "healthcare_providers"("fhir_id");

-- CreateIndex
CREATE UNIQUE INDEX "healthcare_providers_npi_number_key" ON "healthcare_providers"("npi_number");

-- CreateIndex
CREATE INDEX "healthcare_providers_provider_code_idx" ON "healthcare_providers"("provider_code");

-- CreateIndex
CREATE INDEX "healthcare_providers_fhir_id_idx" ON "healthcare_providers"("fhir_id");

-- CreateIndex
CREATE INDEX "healthcare_providers_npi_number_idx" ON "healthcare_providers"("npi_number");

-- CreateIndex
CREATE INDEX "healthcare_providers_provider_type_status_deleted_at_idx" ON "healthcare_providers"("provider_type", "status", "deleted_at");

-- CreateIndex
CREATE INDEX "healthcare_providers_user_id_idx" ON "healthcare_providers"("user_id");

-- CreateIndex
CREATE INDEX "healthcare_providers_specialties_idx" ON "healthcare_providers"("specialties");

-- CreateIndex
CREATE INDEX "healthcare_providers_emergency_available_in_emergency_direc_idx" ON "healthcare_providers"("emergency_available", "in_emergency_directory");

-- CreateIndex
CREATE UNIQUE INDEX "organization_staff_employee_id_key" ON "organization_staff"("employee_id");

-- CreateIndex
CREATE INDEX "organization_staff_organization_id_active_idx" ON "organization_staff"("organization_id", "active");

-- CreateIndex
CREATE INDEX "organization_staff_employee_id_idx" ON "organization_staff"("employee_id");

-- CreateIndex
CREATE INDEX "organization_staff_current_status_idx" ON "organization_staff"("current_status");

-- CreateIndex
CREATE UNIQUE INDEX "organization_staff_user_id_organization_id_key" ON "organization_staff"("user_id", "organization_id");

-- CreateIndex
CREATE UNIQUE INDEX "organizations_org_code_key" ON "organizations"("org_code");

-- CreateIndex
CREATE UNIQUE INDEX "organizations_fhir_id_key" ON "organizations"("fhir_id");

-- CreateIndex
CREATE UNIQUE INDEX "organizations_license_number_key" ON "organizations"("license_number");

-- CreateIndex
CREATE UNIQUE INDEX "organizations_npi_number_key" ON "organizations"("npi_number");

-- CreateIndex
CREATE INDEX "organizations_org_type_deleted_at_idx" ON "organizations"("org_type", "deleted_at");

-- CreateIndex
CREATE INDEX "organizations_org_code_deleted_at_idx" ON "organizations"("org_code", "deleted_at");

-- CreateIndex
CREATE INDEX "organizations_fhir_id_idx" ON "organizations"("fhir_id");

-- CreateIndex
CREATE INDEX "organizations_npi_number_idx" ON "organizations"("npi_number");

-- CreateIndex
CREATE INDEX "organizations_status_deleted_at_idx" ON "organizations"("status", "deleted_at");

-- CreateIndex
CREATE INDEX "caregivers_patient_id_is_active_idx" ON "caregivers"("patient_id", "is_active");

-- CreateIndex
CREATE INDEX "caregivers_user_id_is_active_idx" ON "caregivers"("user_id", "is_active");

-- CreateIndex
CREATE UNIQUE INDEX "caregivers_user_id_patient_id_key" ON "caregivers"("user_id", "patient_id");

-- CreateIndex
CREATE INDEX "proxy_action_logs_patient_id_performed_at_idx" ON "proxy_action_logs"("patient_id", "performed_at" DESC);

-- CreateIndex
CREATE INDEX "proxy_action_logs_caregiver_id_performed_at_idx" ON "proxy_action_logs"("caregiver_id", "performed_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "staff_roles_organization_id_name_key" ON "staff_roles"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "staff_assignments_staff_id_role_id_key" ON "staff_assignments"("staff_id", "role_id");

-- CreateIndex
CREATE INDEX "staff_clock_ins_staff_id_clock_in_idx" ON "staff_clock_ins"("staff_id", "clock_in" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "email_provider_configs_organization_id_key" ON "email_provider_configs"("organization_id");

-- CreateIndex
CREATE INDEX "email_logs_organization_id_sent_at_idx" ON "email_logs"("organization_id", "sent_at" DESC);

-- CreateIndex
CREATE INDEX "email_logs_status_idx" ON "email_logs"("status");

-- CreateIndex
CREATE INDEX "email_logs_toEmail_sent_at_idx" ON "email_logs"("toEmail", "sent_at" DESC);

-- CreateIndex
CREATE INDEX "sms_logs_organization_id_sent_at_idx" ON "sms_logs"("organization_id", "sent_at" DESC);

-- CreateIndex
CREATE INDEX "sms_logs_status_idx" ON "sms_logs"("status");

-- CreateIndex
CREATE INDEX "sms_logs_toPhone_sent_at_idx" ON "sms_logs"("toPhone", "sent_at" DESC);

-- CreateIndex
CREATE INDEX "care_plans_patient_id_status_idx" ON "care_plans"("patient_id", "status");

-- CreateIndex
CREATE INDEX "care_reminders_patient_id_active_idx" ON "care_reminders"("patient_id", "active");

-- CreateIndex
CREATE INDEX "care_reminders_type_active_idx" ON "care_reminders"("type", "active");

-- CreateIndex
CREATE INDEX "reminder_delivery_logs_reminder_id_scheduled_for_idx" ON "reminder_delivery_logs"("reminder_id", "scheduled_for");

-- CreateIndex
CREATE INDEX "reminder_delivery_logs_patient_id_scheduled_for_idx" ON "reminder_delivery_logs"("patient_id", "scheduled_for" DESC);

-- CreateIndex
CREATE INDEX "reminder_delivery_logs_scheduled_for_email_sent_sms_sent_pu_idx" ON "reminder_delivery_logs"("scheduled_for", "email_sent", "sms_sent", "push_sent");

-- CreateIndex
CREATE UNIQUE INDEX "addons_slug_key" ON "addons"("slug");

-- CreateIndex
CREATE INDEX "addons_status_category_idx" ON "addons"("status", "category");

-- CreateIndex
CREATE INDEX "addons_author_org_id_idx" ON "addons"("author_org_id");

-- CreateIndex
CREATE UNIQUE INDEX "addon_subscriptions_addon_id_organization_id_key" ON "addon_subscriptions"("addon_id", "organization_id");

-- CreateIndex
CREATE UNIQUE INDEX "addon_reviews_addon_id_user_id_key" ON "addon_reviews"("addon_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "api_services_endpoint_key" ON "api_services"("endpoint");

-- CreateIndex
CREATE INDEX "api_services_organization_id_idx" ON "api_services"("organization_id");

-- CreateIndex
CREATE INDEX "api_usage_logs_service_id_requested_at_idx" ON "api_usage_logs"("service_id", "requested_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "api_keys_key_hash_key" ON "api_keys"("key_hash");

-- CreateIndex
CREATE INDEX "api_keys_key_hash_active_idx" ON "api_keys"("key_hash", "active");

-- CreateIndex
CREATE INDEX "api_keys_organization_id_idx" ON "api_keys"("organization_id");

-- CreateIndex
CREATE UNIQUE INDEX "organization_themes_organization_id_key" ON "organization_themes"("organization_id");

-- CreateIndex
CREATE UNIQUE INDEX "death_certificates_certificate_number_key" ON "death_certificates"("certificate_number");

-- CreateIndex
CREATE INDEX "death_certificates_patient_id_idx" ON "death_certificates"("patient_id");

-- CreateIndex
CREATE INDEX "death_certificates_certificate_number_idx" ON "death_certificates"("certificate_number");

-- CreateIndex
CREATE INDEX "death_certificates_date_of_death_idx" ON "death_certificates"("date_of_death");

-- CreateIndex
CREATE INDEX "legacy_managers_manager_id_idx" ON "legacy_managers"("manager_id");

-- CreateIndex
CREATE UNIQUE INDEX "legacy_managers_patient_id_manager_id_key" ON "legacy_managers"("patient_id", "manager_id");

-- CreateIndex
CREATE INDEX "family_relationships_person_id_idx" ON "family_relationships"("person_id");

-- CreateIndex
CREATE INDEX "family_relationships_related_person_id_idx" ON "family_relationships"("related_person_id");

-- CreateIndex
CREATE UNIQUE INDEX "family_relationships_person_id_related_person_id_relationsh_key" ON "family_relationships"("person_id", "related_person_id", "relationship_type");

-- CreateIndex
CREATE UNIQUE INDEX "genetic_profiles_patient_id_key" ON "genetic_profiles"("patient_id");

-- CreateIndex
CREATE INDEX "family_health_history_patient_id_idx" ON "family_health_history"("patient_id");

-- CreateIndex
CREATE INDEX "family_health_history_condition_idx" ON "family_health_history"("condition");

-- CreateIndex
CREATE UNIQUE INDEX "medical_records_record_number_key" ON "medical_records"("record_number");

-- CreateIndex
CREATE INDEX "medical_records_patient_id_deleted_at_idx" ON "medical_records"("patient_id", "deleted_at");

-- CreateIndex
CREATE INDEX "medical_records_organization_id_deleted_at_idx" ON "medical_records"("organization_id", "deleted_at");

-- CreateIndex
CREATE INDEX "allergies_patient_id_active_idx" ON "allergies"("patient_id", "active");

-- CreateIndex
CREATE INDEX "patient_medications_patient_id_active_idx" ON "patient_medications"("patient_id", "active");

-- CreateIndex
CREATE INDEX "immunizations_patient_id_idx" ON "immunizations"("patient_id");

-- CreateIndex
CREATE INDEX "immunizations_date_administered_idx" ON "immunizations"("date_administered");

-- CreateIndex
CREATE INDEX "family_history_patient_id_idx" ON "family_history"("patient_id");

-- CreateIndex
CREATE UNIQUE INDEX "social_history_patient_id_key" ON "social_history"("patient_id");

-- CreateIndex
CREATE INDEX "vital_signs_patient_id_recorded_at_idx" ON "vital_signs"("patient_id", "recorded_at" DESC);

-- CreateIndex
CREATE INDEX "vital_signs_encounter_id_idx" ON "vital_signs"("encounter_id");

-- CreateIndex
CREATE UNIQUE INDEX "appointments_appointment_number_key" ON "appointments"("appointment_number");

-- CreateIndex
CREATE INDEX "appointments_patient_id_scheduled_start_idx" ON "appointments"("patient_id", "scheduled_start");

-- CreateIndex
CREATE INDEX "appointments_provider_id_scheduled_start_idx" ON "appointments"("provider_id", "scheduled_start");

-- CreateIndex
CREATE INDEX "appointments_organization_id_scheduled_start_idx" ON "appointments"("organization_id", "scheduled_start");

-- CreateIndex
CREATE INDEX "appointments_status_scheduled_start_idx" ON "appointments"("status", "scheduled_start");

-- CreateIndex
CREATE UNIQUE INDEX "encounters_encounter_number_key" ON "encounters"("encounter_number");

-- CreateIndex
CREATE UNIQUE INDEX "encounters_appointment_id_key" ON "encounters"("appointment_id");

-- CreateIndex
CREATE INDEX "encounters_patient_id_started_at_idx" ON "encounters"("patient_id", "started_at");

-- CreateIndex
CREATE INDEX "encounters_provider_id_started_at_idx" ON "encounters"("provider_id", "started_at");

-- CreateIndex
CREATE INDEX "encounters_organization_id_started_at_idx" ON "encounters"("organization_id", "started_at");

-- CreateIndex
CREATE INDEX "encounters_status_idx" ON "encounters"("status");

-- CreateIndex
CREATE INDEX "provider_schedules_provider_id_dayOfWeek_active_idx" ON "provider_schedules"("provider_id", "dayOfWeek", "active");

-- CreateIndex
CREATE UNIQUE INDEX "prescriptions_prescription_number_key" ON "prescriptions"("prescription_number");

-- CreateIndex
CREATE INDEX "prescriptions_patient_id_prescribed_at_idx" ON "prescriptions"("patient_id", "prescribed_at");

-- CreateIndex
CREATE INDEX "prescriptions_provider_id_idx" ON "prescriptions"("provider_id");

-- CreateIndex
CREATE INDEX "prescriptions_pharmacy_id_status_idx" ON "prescriptions"("pharmacy_id", "status");

-- CreateIndex
CREATE INDEX "prescriptions_status_idx" ON "prescriptions"("status");

-- CreateIndex
CREATE INDEX "prescriptions_rxnorm_code_idx" ON "prescriptions"("rxnorm_code");

-- CreateIndex
CREATE INDEX "prescription_dispenses_prescription_id_idx" ON "prescription_dispenses"("prescription_id");

-- CreateIndex
CREATE INDEX "prescription_dispenses_pharmacy_id_dispensed_at_idx" ON "prescription_dispenses"("pharmacy_id", "dispensed_at");

-- CreateIndex
CREATE INDEX "prescription_footprints_prescription_id_timestamp_idx" ON "prescription_footprints"("prescription_id", "timestamp");

-- CreateIndex
CREATE INDEX "pharmacy_inventory_pharmacy_id_status_idx" ON "pharmacy_inventory"("pharmacy_id", "status");

-- CreateIndex
CREATE INDEX "pharmacy_inventory_rxnorm_code_idx" ON "pharmacy_inventory"("rxnorm_code");

-- CreateIndex
CREATE UNIQUE INDEX "pharmacy_inventory_pharmacy_id_rxnorm_code_lot_number_key" ON "pharmacy_inventory"("pharmacy_id", "rxnorm_code", "lot_number");

-- CreateIndex
CREATE UNIQUE INDEX "lab_orders_order_number_key" ON "lab_orders"("order_number");

-- CreateIndex
CREATE INDEX "lab_orders_patient_id_created_at_idx" ON "lab_orders"("patient_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "lab_orders_lab_id_status_idx" ON "lab_orders"("lab_id", "status");

-- CreateIndex
CREATE INDEX "lab_orders_ordering_hospital_id_created_at_idx" ON "lab_orders"("ordering_hospital_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "lab_results_patient_id_ordered_at_idx" ON "lab_results"("patient_id", "ordered_at" DESC);

-- CreateIndex
CREATE INDEX "lab_results_lab_order_id_idx" ON "lab_results"("lab_order_id");

-- CreateIndex
CREATE INDEX "lab_results_encounter_id_idx" ON "lab_results"("encounter_id");

-- CreateIndex
CREATE INDEX "lab_results_loinc_code_idx" ON "lab_results"("loinc_code");

-- CreateIndex
CREATE UNIQUE INDEX "lab_partnerships_hospital_id_lab_id_key" ON "lab_partnerships"("hospital_id", "lab_id");

-- CreateIndex
CREATE UNIQUE INDEX "insurance_plans_plan_code_key" ON "insurance_plans"("plan_code");

-- CreateIndex
CREATE INDEX "insurance_plans_insurance_company_id_active_idx" ON "insurance_plans"("insurance_company_id", "active");

-- CreateIndex
CREATE INDEX "patient_insurance_patient_id_status_idx" ON "patient_insurance"("patient_id", "status");

-- CreateIndex
CREATE INDEX "patient_insurance_policy_number_idx" ON "patient_insurance"("policy_number");

-- CreateIndex
CREATE UNIQUE INDEX "insurance_claims_claim_number_key" ON "insurance_claims"("claim_number");

-- CreateIndex
CREATE INDEX "insurance_claims_patient_id_status_idx" ON "insurance_claims"("patient_id", "status");

-- CreateIndex
CREATE INDEX "insurance_claims_insurance_company_id_status_idx" ON "insurance_claims"("insurance_company_id", "status");

-- CreateIndex
CREATE INDEX "insurance_claims_status_submitted_at_idx" ON "insurance_claims"("status", "submitted_at");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_invoice_number_key" ON "invoices"("invoice_number");

-- CreateIndex
CREATE INDEX "invoices_patient_id_status_idx" ON "invoices"("patient_id", "status");

-- CreateIndex
CREATE INDEX "invoices_status_due_date_idx" ON "invoices"("status", "due_date");

-- CreateIndex
CREATE INDEX "payments_invoice_id_idx" ON "payments"("invoice_id");

-- CreateIndex
CREATE INDEX "payments_patient_id_created_at_idx" ON "payments"("patient_id", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "hospital_departments_organization_id_code_key" ON "hospital_departments"("organization_id", "code");

-- CreateIndex
CREATE INDEX "hospital_beds_department_id_status_idx" ON "hospital_beds"("department_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "hospital_beds_organization_id_bed_number_key" ON "hospital_beds"("organization_id", "bed_number");

-- CreateIndex
CREATE INDEX "medical_equipment_status_idx" ON "medical_equipment"("status");

-- CreateIndex
CREATE UNIQUE INDEX "medical_equipment_organization_id_equipment_code_key" ON "medical_equipment"("organization_id", "equipment_code");

-- CreateIndex
CREATE UNIQUE INDEX "products_organization_id_product_code_key" ON "products"("organization_id", "product_code");

-- CreateIndex
CREATE UNIQUE INDEX "purchase_orders_order_number_key" ON "purchase_orders"("order_number");

-- CreateIndex
CREATE INDEX "purchase_orders_hospital_id_status_idx" ON "purchase_orders"("hospital_id", "status");

-- CreateIndex
CREATE INDEX "purchase_orders_supplier_id_idx" ON "purchase_orders"("supplier_id");

-- CreateIndex
CREATE INDEX "fhir_resources_patient_id_idx" ON "fhir_resources"("patient_id");

-- CreateIndex
CREATE INDEX "fhir_resources_provider_id_idx" ON "fhir_resources"("provider_id");

-- CreateIndex
CREATE INDEX "fhir_resources_organization_id_idx" ON "fhir_resources"("organization_id");

-- CreateIndex
CREATE UNIQUE INDEX "fhir_resources_resource_type_fhir_id_key" ON "fhir_resources"("resource_type", "fhir_id");

-- CreateIndex
CREATE INDEX "hl7_messages_organization_id_created_at_idx" ON "hl7_messages"("organization_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "hl7_messages_status_idx" ON "hl7_messages"("status");

-- CreateIndex
CREATE UNIQUE INDEX "access_tokens_token_hash_key" ON "access_tokens"("token_hash");

-- CreateIndex
CREATE INDEX "access_tokens_token_hash_revoked_idx" ON "access_tokens"("token_hash", "revoked");

-- CreateIndex
CREATE INDEX "access_tokens_user_id_revoked_idx" ON "access_tokens"("user_id", "revoked");

-- CreateIndex
CREATE INDEX "access_tokens_expires_at_revoked_idx" ON "access_tokens"("expires_at", "revoked");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("name");

-- CreateIndex
CREATE INDEX "user_roles_user_id_idx" ON "user_roles"("user_id");

-- CreateIndex
CREATE INDEX "user_roles_role_id_idx" ON "user_roles"("role_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_roles_user_id_role_id_key" ON "user_roles"("user_id", "role_id");

-- CreateIndex
CREATE INDEX "access_logs_user_id_accessed_at_idx" ON "access_logs"("user_id", "accessed_at");

-- CreateIndex
CREATE INDEX "access_logs_resource_type_resource_id_accessed_at_idx" ON "access_logs"("resource_type", "resource_id", "accessed_at");

-- CreateIndex
CREATE INDEX "access_logs_accessed_at_idx" ON "access_logs"("accessed_at");

-- CreateIndex
CREATE INDEX "patient_access_logs_patient_id_accessed_at_idx" ON "patient_access_logs"("patient_id", "accessed_at" DESC);

-- CreateIndex
CREATE INDEX "patient_access_logs_accessor_id_accessed_at_idx" ON "patient_access_logs"("accessor_id", "accessed_at" DESC);

-- CreateIndex
CREATE INDEX "patient_access_logs_organization_id_accessed_at_idx" ON "patient_access_logs"("organization_id", "accessed_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "audit_logs_current_hash_key" ON "audit_logs"("current_hash");

-- CreateIndex
CREATE INDEX "audit_logs_user_id_timestamp_idx" ON "audit_logs"("user_id", "timestamp" DESC);

-- CreateIndex
CREATE INDEX "audit_logs_resource_type_resource_id_timestamp_idx" ON "audit_logs"("resource_type", "resource_id", "timestamp");

-- CreateIndex
CREATE INDEX "audit_logs_timestamp_idx" ON "audit_logs"("timestamp");

-- CreateIndex
CREATE INDEX "audit_logs_current_hash_idx" ON "audit_logs"("current_hash");

-- CreateIndex
CREATE INDEX "digital_signatures_resource_type_resource_id_idx" ON "digital_signatures"("resource_type", "resource_id");

-- CreateIndex
CREATE INDEX "digital_signatures_signer_id_signed_at_idx" ON "digital_signatures"("signer_id", "signed_at");

-- CreateIndex
CREATE INDEX "data_consents_patient_id_status_idx" ON "data_consents"("patient_id", "status");

-- CreateIndex
CREATE INDEX "data_consents_grantee_org_id_status_idx" ON "data_consents"("grantee_org_id", "status");

-- CreateIndex
CREATE INDEX "data_consents_expires_at_status_idx" ON "data_consents"("expires_at", "status");

-- CreateIndex
CREATE INDEX "compliance_incidents_severity_status_idx" ON "compliance_incidents"("severity", "status");

-- CreateIndex
CREATE INDEX "compliance_incidents_reported_by_idx" ON "compliance_incidents"("reported_by");

-- CreateIndex
CREATE INDEX "compliance_incidents_occurred_at_idx" ON "compliance_incidents"("occurred_at");

-- CreateIndex
CREATE INDEX "notifications_user_id_read_sent_at_idx" ON "notifications"("user_id", "read", "sent_at" DESC);

-- CreateIndex
CREATE INDEX "notifications_user_id_type_read_idx" ON "notifications"("user_id", "type", "read");

-- CreateIndex
CREATE INDEX "messages_recipient_id_read_sent_at_idx" ON "messages"("recipient_id", "read", "sent_at" DESC);

-- CreateIndex
CREATE INDEX "messages_sender_id_sent_at_idx" ON "messages"("sender_id", "sent_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "system_settings_organization_id_key_key" ON "system_settings"("organization_id", "key");

-- CreateIndex
CREATE INDEX "external_systems_organization_id_system_type_idx" ON "external_systems"("organization_id", "system_type");

-- CreateIndex
CREATE INDEX "data_sync_logs_external_system_id_started_at_idx" ON "data_sync_logs"("external_system_id", "started_at" DESC);

-- CreateIndex
CREATE INDEX "webhook_subscriptions_organization_id_event_type_active_idx" ON "webhook_subscriptions"("organization_id", "event_type", "active");

-- CreateIndex
CREATE INDEX "webhook_deliveries_subscription_id_created_at_idx" ON "webhook_deliveries"("subscription_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "webhook_deliveries_status_next_retry_idx" ON "webhook_deliveries"("status", "next_retry");

-- CreateIndex
CREATE INDEX "data_export_requests_user_id_requested_at_idx" ON "data_export_requests"("user_id", "requested_at" DESC);

-- CreateIndex
CREATE INDEX "provider_organizations_organization_id_active_idx" ON "provider_organizations"("organization_id", "active");

-- CreateIndex
CREATE UNIQUE INDEX "provider_organizations_provider_id_organization_id_key" ON "provider_organizations"("provider_id", "organization_id");

-- CreateIndex
CREATE INDEX "_ManagedUser_B_index" ON "_ManagedUser"("B");

-- AddForeignKey
ALTER TABLE "shift_schedules" ADD CONSTRAINT "shift_schedules_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "shift_schedules" ADD CONSTRAINT "shift_schedules_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "organization_staff"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "shift_schedules" ADD CONSTRAINT "shift_schedules_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "healthcare_providers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_activities" ADD CONSTRAINT "staff_activities_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "organization_staff"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "otps" ADD CONSTRAINT "otps_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "imaging_studies" ADD CONSTRAINT "imaging_studies_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "imaging_studies" ADD CONSTRAINT "imaging_studies_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "encounters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "imaging_studies" ADD CONSTRAINT "imaging_studies_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patients" ADD CONSTRAINT "patients_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "healthcare_providers" ADD CONSTRAINT "healthcare_providers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_staff" ADD CONSTRAINT "organization_staff_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_staff" ADD CONSTRAINT "organization_staff_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "caregivers" ADD CONSTRAINT "caregivers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "caregivers" ADD CONSTRAINT "caregivers_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proxy_action_logs" ADD CONSTRAINT "proxy_action_logs_caregiver_id_fkey" FOREIGN KEY ("caregiver_id") REFERENCES "caregivers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proxy_action_logs" ADD CONSTRAINT "proxy_action_logs_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_roles" ADD CONSTRAINT "staff_roles_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_assignments" ADD CONSTRAINT "staff_assignments_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "organization_staff"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_assignments" ADD CONSTRAINT "staff_assignments_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "staff_roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_clock_ins" ADD CONSTRAINT "staff_clock_ins_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "organization_staff"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_clock_ins" ADD CONSTRAINT "staff_clock_ins_shift_id_fkey" FOREIGN KEY ("shift_id") REFERENCES "shift_schedules"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "email_provider_configs" ADD CONSTRAINT "email_provider_configs_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "email_logs" ADD CONSTRAINT "email_logs_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "email_logs" ADD CONSTRAINT "email_logs_email_config_id_fkey" FOREIGN KEY ("email_config_id") REFERENCES "email_provider_configs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sms_logs" ADD CONSTRAINT "sms_logs_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "care_plans" ADD CONSTRAINT "care_plans_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "care_reminders" ADD CONSTRAINT "care_reminders_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "care_reminders" ADD CONSTRAINT "care_reminders_care_plan_id_fkey" FOREIGN KEY ("care_plan_id") REFERENCES "care_plans"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "care_reminders" ADD CONSTRAINT "care_reminders_prescription_id_fkey" FOREIGN KEY ("prescription_id") REFERENCES "prescriptions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reminder_delivery_logs" ADD CONSTRAINT "reminder_delivery_logs_reminder_id_fkey" FOREIGN KEY ("reminder_id") REFERENCES "care_reminders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reminder_delivery_logs" ADD CONSTRAINT "reminder_delivery_logs_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "addons" ADD CONSTRAINT "addons_author_org_id_fkey" FOREIGN KEY ("author_org_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "addon_subscriptions" ADD CONSTRAINT "addon_subscriptions_addon_id_fkey" FOREIGN KEY ("addon_id") REFERENCES "addons"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "addon_subscriptions" ADD CONSTRAINT "addon_subscriptions_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "addon_reviews" ADD CONSTRAINT "addon_reviews_addon_id_fkey" FOREIGN KEY ("addon_id") REFERENCES "addons"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "api_services" ADD CONSTRAINT "api_services_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "api_usage_logs" ADD CONSTRAINT "api_usage_logs_service_id_fkey" FOREIGN KEY ("service_id") REFERENCES "api_services"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "api_keys" ADD CONSTRAINT "api_keys_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_themes" ADD CONSTRAINT "organization_themes_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "death_certificates" ADD CONSTRAINT "death_certificates_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "legacy_managers" ADD CONSTRAINT "legacy_managers_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "family_relationships" ADD CONSTRAINT "family_relationships_person_id_fkey" FOREIGN KEY ("person_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "family_relationships" ADD CONSTRAINT "family_relationships_related_person_id_fkey" FOREIGN KEY ("related_person_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "genetic_profiles" ADD CONSTRAINT "genetic_profiles_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "family_health_history" ADD CONSTRAINT "family_health_history_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "medical_records" ADD CONSTRAINT "medical_records_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "medical_records" ADD CONSTRAINT "medical_records_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "allergies" ADD CONSTRAINT "allergies_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_medications" ADD CONSTRAINT "patient_medications_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "immunizations" ADD CONSTRAINT "immunizations_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "family_history" ADD CONSTRAINT "family_history_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "social_history" ADD CONSTRAINT "social_history_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vital_signs" ADD CONSTRAINT "vital_signs_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vital_signs" ADD CONSTRAINT "vital_signs_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "encounters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "appointments" ADD CONSTRAINT "appointments_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "appointments" ADD CONSTRAINT "appointments_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "healthcare_providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "appointments" ADD CONSTRAINT "appointments_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "encounters" ADD CONSTRAINT "encounters_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "encounters" ADD CONSTRAINT "encounters_medical_record_id_fkey" FOREIGN KEY ("medical_record_id") REFERENCES "medical_records"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "encounters" ADD CONSTRAINT "encounters_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "healthcare_providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "encounters" ADD CONSTRAINT "encounters_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "encounters" ADD CONSTRAINT "encounters_appointment_id_fkey" FOREIGN KEY ("appointment_id") REFERENCES "appointments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_schedules" ADD CONSTRAINT "provider_schedules_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "healthcare_providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescriptions" ADD CONSTRAINT "prescriptions_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescriptions" ADD CONSTRAINT "prescriptions_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "encounters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescriptions" ADD CONSTRAINT "prescriptions_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "healthcare_providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescriptions" ADD CONSTRAINT "prescriptions_hospital_id_fkey" FOREIGN KEY ("hospital_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescription_dispenses" ADD CONSTRAINT "prescription_dispenses_prescription_id_fkey" FOREIGN KEY ("prescription_id") REFERENCES "prescriptions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescription_dispenses" ADD CONSTRAINT "prescription_dispenses_pharmacy_id_fkey" FOREIGN KEY ("pharmacy_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescription_footprints" ADD CONSTRAINT "prescription_footprints_prescription_id_fkey" FOREIGN KEY ("prescription_id") REFERENCES "prescriptions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pharmacy_inventory" ADD CONSTRAINT "pharmacy_inventory_pharmacy_id_fkey" FOREIGN KEY ("pharmacy_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lab_orders" ADD CONSTRAINT "lab_orders_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lab_orders" ADD CONSTRAINT "lab_orders_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "encounters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lab_orders" ADD CONSTRAINT "lab_orders_ordering_hospital_id_fkey" FOREIGN KEY ("ordering_hospital_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lab_orders" ADD CONSTRAINT "lab_orders_lab_id_fkey" FOREIGN KEY ("lab_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lab_results" ADD CONSTRAINT "lab_results_lab_order_id_fkey" FOREIGN KEY ("lab_order_id") REFERENCES "lab_orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lab_results" ADD CONSTRAINT "lab_results_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lab_results" ADD CONSTRAINT "lab_results_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "encounters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lab_results" ADD CONSTRAINT "lab_results_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lab_partnerships" ADD CONSTRAINT "lab_partnerships_hospital_id_fkey" FOREIGN KEY ("hospital_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lab_partnerships" ADD CONSTRAINT "lab_partnerships_lab_id_fkey" FOREIGN KEY ("lab_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "insurance_plans" ADD CONSTRAINT "insurance_plans_insurance_company_id_fkey" FOREIGN KEY ("insurance_company_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_insurance" ADD CONSTRAINT "patient_insurance_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_insurance" ADD CONSTRAINT "patient_insurance_insurance_company_id_fkey" FOREIGN KEY ("insurance_company_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_insurance" ADD CONSTRAINT "patient_insurance_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "insurance_plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "insurance_claims" ADD CONSTRAINT "insurance_claims_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "insurance_claims" ADD CONSTRAINT "insurance_claims_patient_insurance_id_fkey" FOREIGN KEY ("patient_insurance_id") REFERENCES "patient_insurance"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "insurance_claims" ADD CONSTRAINT "insurance_claims_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "encounters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "insurance_claims" ADD CONSTRAINT "insurance_claims_insurance_company_id_fkey" FOREIGN KEY ("insurance_company_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_encounter_id_fkey" FOREIGN KEY ("encounter_id") REFERENCES "encounters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_hospital_id_fkey" FOREIGN KEY ("hospital_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_pharmacy_id_fkey" FOREIGN KEY ("pharmacy_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hospital_departments" ADD CONSTRAINT "hospital_departments_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hospital_beds" ADD CONSTRAINT "hospital_beds_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hospital_beds" ADD CONSTRAINT "hospital_beds_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "hospital_departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "medical_equipment" ADD CONSTRAINT "medical_equipment_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_hospital_id_fkey" FOREIGN KEY ("hospital_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fhir_resources" ADD CONSTRAINT "fhir_resources_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fhir_resources" ADD CONSTRAINT "fhir_resources_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "healthcare_providers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fhir_resources" ADD CONSTRAINT "fhir_resources_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hl7_messages" ADD CONSTRAINT "hl7_messages_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "access_tokens" ADD CONSTRAINT "access_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "roles" ADD CONSTRAINT "roles_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "access_logs" ADD CONSTRAINT "access_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_access_logs" ADD CONSTRAINT "patient_access_logs_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "digital_signatures" ADD CONSTRAINT "digital_signatures_signer_user_fkey" FOREIGN KEY ("signer_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "digital_signatures" ADD CONSTRAINT "digital_signatures_signer_provider_fkey" FOREIGN KEY ("signer_id") REFERENCES "healthcare_providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_consents" ADD CONSTRAINT "data_consents_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_consents" ADD CONSTRAINT "data_consents_grantor_org_id_fkey" FOREIGN KEY ("grantor_org_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_consents" ADD CONSTRAINT "data_consents_grantee_org_id_fkey" FOREIGN KEY ("grantee_org_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "compliance_incidents" ADD CONSTRAINT "compliance_incidents_reported_by_fkey" FOREIGN KEY ("reported_by") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "compliance_incidents" ADD CONSTRAINT "compliance_incidents_assigned_to_fkey" FOREIGN KEY ("assigned_to") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_recipient_id_fkey" FOREIGN KEY ("recipient_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "system_settings" ADD CONSTRAINT "system_settings_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "system_settings" ADD CONSTRAINT "system_settings_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "external_systems" ADD CONSTRAINT "external_systems_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_sync_logs" ADD CONSTRAINT "data_sync_logs_external_system_id_fkey" FOREIGN KEY ("external_system_id") REFERENCES "external_systems"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "webhook_subscriptions" ADD CONSTRAINT "webhook_subscriptions_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "webhook_deliveries" ADD CONSTRAINT "webhook_deliveries_subscription_id_fkey" FOREIGN KEY ("subscription_id") REFERENCES "webhook_subscriptions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_export_requests" ADD CONSTRAINT "data_export_requests_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_organizations" ADD CONSTRAINT "provider_organizations_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "healthcare_providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_organizations" ADD CONSTRAINT "provider_organizations_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ManagedUser" ADD CONSTRAINT "_ManagedUser_A_fkey" FOREIGN KEY ("A") REFERENCES "caregivers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ManagedUser" ADD CONSTRAINT "_ManagedUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
