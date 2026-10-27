import { IsEmail, IsOptional, IsString, IsUUID, Length } from 'class-validator';

export class SendPasswordResetEmailDto {
  @IsEmail()
  to!: string;

  @IsString()
  @Length(1, 100)
  firstName!: string;

  @IsString()
  @Length(4, 32)
  resetCode!: string;

  @IsOptional()
  @IsUUID()
  organizationId?: string;
}
