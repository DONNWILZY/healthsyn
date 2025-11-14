/*
  Warnings:

  - Added the required column `organization_id` to the `payments` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "PaymentProofStatus" AS ENUM ('PENDING_REVIEW', 'APPROVED', 'REJECTED', 'REQUIRES_CLARIFICATION');

-- AlterEnum
ALTER TYPE "PaymentMethod" ADD VALUE 'OFFLINE_PAYMENT';

-- AlterTable
ALTER TABLE "organizations" ADD COLUMN     "geog" JSONB,
ADD COLUMN     "latitude" DECIMAL(10,8),
ADD COLUMN     "location" JSONB,
ADD COLUMN     "location_updated_at" TIMESTAMP(3),
ADD COLUMN     "longitude" DECIMAL(11,8);

-- AlterTable
ALTER TABLE "payments" ADD COLUMN     "is_offline_payment" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "organization_id" UUID NOT NULL,
ADD COLUMN     "proof_image_url" TEXT,
ADD COLUMN     "proof_review_notes" TEXT,
ADD COLUMN     "proof_reviewed_at" TIMESTAMP(3),
ADD COLUMN     "proof_reviewed_by" UUID,
ADD COLUMN     "proof_status" "PaymentProofStatus",
ADD COLUMN     "proof_submitted_at" TIMESTAMP(3);

-- CreateTable
CREATE TABLE "transactions" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "payment_id" UUID NOT NULL,
    "transaction_type" VARCHAR(20) NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "balance_before" DECIMAL(10,2) NOT NULL,
    "balance_after" DECIMAL(10,2) NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "category" VARCHAR(50),
    "reference_type" VARCHAR(50),
    "reference_id" UUID,
    "settled_at" TIMESTAMP(3),
    "settled" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_balances" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "current_balance" DECIMAL(10,2) NOT NULL,
    "pending_balance" DECIMAL(10,2) NOT NULL,
    "total_received" DECIMAL(10,2) NOT NULL,
    "total_paid" DECIMAL(10,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "last_transaction_at" TIMESTAMP(3),
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_balances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "file_uploads" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "uploaded_by" UUID NOT NULL,
    "file_name" VARCHAR(255) NOT NULL,
    "file_url" TEXT NOT NULL,
    "file_type" VARCHAR(50) NOT NULL,
    "file_size" INTEGER NOT NULL,
    "resource_type" VARCHAR(50) NOT NULL,
    "resource_id" UUID NOT NULL,
    "uploaded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3),

    CONSTRAINT "file_uploads_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pharmacies" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "organization_id" UUID NOT NULL,
    "license_number" VARCHAR(100) NOT NULL,
    "dea_number" VARCHAR(20),
    "operating_hours" JSONB,
    "services" JSONB[] DEFAULT ARRAY[]::JSONB[],
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "pharmacies_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "transactions_payment_id_key" ON "transactions"("payment_id");

-- CreateIndex
CREATE INDEX "transactions_organization_id_created_at_idx" ON "transactions"("organization_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "transactions_organization_id_settled_created_at_idx" ON "transactions"("organization_id", "settled", "created_at" DESC);

-- CreateIndex
CREATE INDEX "transactions_transaction_type_created_at_idx" ON "transactions"("transaction_type", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "organization_balances_organization_id_key" ON "organization_balances"("organization_id");

-- CreateIndex
CREATE INDEX "file_uploads_resource_type_resource_id_idx" ON "file_uploads"("resource_type", "resource_id");

-- CreateIndex
CREATE INDEX "file_uploads_uploaded_by_uploaded_at_idx" ON "file_uploads"("uploaded_by", "uploaded_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "pharmacies_license_number_key" ON "pharmacies"("license_number");

-- CreateIndex
CREATE INDEX "pharmacies_organization_id_idx" ON "pharmacies"("organization_id");

-- CreateIndex
CREATE INDEX "organizations_latitude_longitude_idx" ON "organizations"("latitude", "longitude");

-- CreateIndex
CREATE INDEX "organizations_org_type_latitude_longitude_idx" ON "organizations"("org_type", "latitude", "longitude");

-- CreateIndex
CREATE INDEX "payments_organization_id_created_at_idx" ON "payments"("organization_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "payments_organization_id_status_created_at_idx" ON "payments"("organization_id", "status", "created_at" DESC);

-- CreateIndex
CREATE INDEX "payments_is_offline_payment_proof_status_idx" ON "payments"("is_offline_payment", "proof_status");

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "payments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_balances" ADD CONSTRAINT "organization_balances_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pharmacies" ADD CONSTRAINT "pharmacies_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
