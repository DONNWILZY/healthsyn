<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="120" alt="Nest Logo" /></a>
</p>

[circleci-image]: https://img.shields.io/circleci/build/github/nestjs/nest/master?token=abc123def456
[circleci-url]: https://circleci.com/gh/nestjs/nest

  <p align="center">A progressive <a href="http://nodejs.org" target="_blank">Node.js</a> framework for building efficient and scalable server-side applications.</p>
    <p align="center">
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/v/@nestjs/core.svg" alt="NPM Version" /></a>
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/l/@nestjs/core.svg" alt="Package License" /></a>
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/dm/@nestjs/common.svg" alt="NPM Downloads" /></a>
<a href="https://circleci.com/gh/nestjs/nest" target="_blank"><img src="https://img.shields.io/circleci/build/github/nestjs/nest/master" alt="CircleCI" /></a>
<a href="https://discord.gg/G7Qnnhy" target="_blank"><img src="https://img.shields.io/badge/discord-online-brightgreen.svg" alt="Discord"/></a>
<a href="https://opencollective.com/nest#backer" target="_blank"><img src="https://opencollective.com/nest/backers/badge.svg" alt="Backers on Open Collective" /></a>
<a href="https://opencollective.com/nest#sponsor" target="_blank"><img src="https://opencollective.com/nest/sponsors/badge.svg" alt="Sponsors on Open Collective" /></a>
  <a href="https://paypal.me/kamilmysliwiec" target="_blank"><img src="https://img.shields.io/badge/Donate-PayPal-ff3f59.svg" alt="Donate us"/></a>
    <a href="https://opencollective.com/nest#sponsor"  target="_blank"><img src="https://img.shields.io/badge/Support%20us-Open%20Collective-41B883.svg" alt="Support us"></a>
  <a href="https://twitter.com/nestframework" target="_blank"><img src="https://img.shields.io/twitter/follow/nestframework.svg?style=social&label=Follow" alt="Follow us on Twitter"></a>
</p>
  <!--[![Backers on Open Collective](https://opencollective.com/nest/backers/badge.svg)](https://opencollective.com/nest#backer)
  [![Sponsors on Open Collective](https://opencollective.com/nest/sponsors/badge.svg)](https://opencollective.com/nest#sponsor)-->

## Description

[Nest](https://github.com/nestjs/nest) framework TypeScript starter repository.

## Project setup

Use Node.js 24 and a disposable PostgreSQL 17 database with `pgcrypto` and `uuid-ossp` available.

```bash
npm ci
cp .env.example .env
# Set DATABASE_URL to your development database in .env.
npx prisma validate
npx prisma migrate deploy
npx prisma generate
```

CI starts an isolated PostgreSQL service, compares the deployed schema with `prisma/schema.prisma`, checks the upgrade against synthetic legacy data, and runs the build, unit tests and HTTP tests.

### Repository foundation migration

The forward reconciliation starts from the schema created by `20251114010044_init` and `20251114013015_second_edition`. Before upgrading an existing environment, inspect its Prisma migration history and schema, restore a recent backup to staging, and rehearse the full upgrade against that copy. Keep legacy writes paused during credential staging and migration. Use `prisma migrate deploy` with your deployment credentials and confirm the schema afterwards.

```bash
npx prisma migrate status
npx prisma migrate deploy
npx prisma migrate diff --from-url "$DATABASE_URL" --to-schema-datamodel prisma/schema.prisma --exit-code
```

- A database still on the initial migration with existing `payments` needs a separate, reviewed payment-to-organization backfill. The historical second migration adds `payments.organization_id` as required with no value for old rows. Settle the mapping and the migration history for that environment before running the migration chain.
- Reconciliation normalizes legacy enum strings by trimming spaces and uppercasing them. Unknown values abort the transaction. Reconcile unknown values with the data owner and check references in `patients.closed_by` and `user_roles.granted_by` before staging deployment.
- Role scopes use the organization UUID as text for organization roles and `SYSTEM` for roles without an organization. Digital signatures move their signer ID into the relation named by their signer type.
- The password salt, session token, invoice items and export URL remain in their original columns as Prisma-ignored fields. A later migration can address credential verification, session invalidation, invoice-line conversion and export object keys independently. Existing export URLs are not mapped automatically to object keys.
- If the upgrade fails, use PostgreSQL logs to identify the original error. Verify that the reconciliation transaction rolled back before marking a recorded failed attempt as rolled back with `prisma migrate resolve --rolled-back 20261120130000_reconcile_foundation_schema`. Resolve the underlying data issue and retry on staging first.

#### Legacy integration credentials

For existing webhook subscriptions or external systems with non-null credentials, stage ciphertext, the deployment-approved 64-character hexadecimal digest, and the correct positive key version for each row before deployment. Have the approved encryption service create and verify those values. Record only row counts and verification status in deployment logs. The migration validates that staged fields are present and removes the legacy plaintext columns in the same transaction. It cannot verify decryption or select your encryption key. When both legacy credential sources are empty, skip staging.

Use this staging schema on the rehearsal database and, after validation, in the controlled upgrade:

```sql
ALTER TABLE external_systems
    ADD COLUMN IF NOT EXISTS credentials_encrypted BYTEA,
    ADD COLUMN IF NOT EXISTS credentials_hash VARCHAR(64),
    ADD COLUMN IF NOT EXISTS credentials_key_version INTEGER DEFAULT 1;
ALTER TABLE webhook_subscriptions
    ADD COLUMN IF NOT EXISTS secret_encrypted BYTEA,
    ADD COLUMN IF NOT EXISTS secret_hash VARCHAR(64),
    ADD COLUMN IF NOT EXISTS secret_key_version INTEGER DEFAULT 1;
```

### Transactional email

The sample environment disables delivery. To enable platform SMTP, set `EMAIL_ENABLED=true`, `EMAIL_HOST`, the appropriate port and TLS setting, and SMTP credentials if your server requires them. Existing `SMTP_*` settings are supported. A legacy `SMTP_HOST` enables mail when `EMAIL_ENABLED` is unset. An explicit `EMAIL_ENABLED=false` takes precedence. Supply live credentials through the deployment environment or its secret manager.

The built-in templates ship with the Nest build. Set `EMAIL_TEMPLATES_DIR` only to use an operator-managed template directory. Password reset delivery is an internal service for use by an authenticated or verified identity workflow. Tenant-specific dispatch requires a later phase.

## Compile and run the project

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Run tests

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

## Deployment

When you're ready to deploy your NestJS application to production, there are some key steps you can take to ensure it runs as efficiently as possible. Check out the [deployment documentation](https://docs.nestjs.com/deployment) for more information.

If you are looking for a cloud-based platform to deploy your NestJS application, check out [Mau](https://mau.nestjs.com), our official platform for deploying NestJS applications on AWS. Mau makes deployment straightforward and fast, requiring just a few simple steps:

```bash
$ npm install -g @nestjs/mau
$ mau deploy
```

With Mau, you can deploy your application in just a few clicks, allowing you to focus on building features rather than managing infrastructure.

## Resources

Check out a few resources that may come in handy when working with NestJS:

- Visit the [NestJS Documentation](https://docs.nestjs.com) to learn more about the framework.
- For questions and support, please visit our [Discord channel](https://discord.gg/G7Qnnhy).
- To dive deeper and get more hands-on experience, check out our official video [courses](https://courses.nestjs.com/).
- Deploy your application to AWS with the help of [NestJS Mau](https://mau.nestjs.com) in just a few clicks.
- Visualize your application graph and interact with the NestJS application in real-time using [NestJS Devtools](https://devtools.nestjs.com).
- Need help with your project (part-time to full-time)? Check out our official [enterprise support](https://enterprise.nestjs.com).
- To stay in the loop and get updates, follow us on [X](https://x.com/nestframework) and [LinkedIn](https://linkedin.com/company/nestjs).
- Looking for a job, or have a job to offer? Check out our official [Jobs board](https://jobs.nestjs.com).

## Support

Nest is an MIT-licensed open source project. It can grow thanks to the sponsors and support by the amazing backers. If you'd like to join them, please [read more here](https://docs.nestjs.com/support).

## Stay in touch

- Author - [Kamil Myśliwiec](https://twitter.com/kammysliwiec)
- Website - [https://nestjs.com](https://nestjs.com/)
- Twitter - [@nestframework](https://twitter.com/nestframework)

## License

Nest is [MIT licensed](https://github.com/nestjs/nest/blob/master/LICENSE).


codex Add missing npm dev script
