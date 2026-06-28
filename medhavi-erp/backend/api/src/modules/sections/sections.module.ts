import { Module } from '@nestjs/common';
import { PrismaModule } from '../../infrastructure/prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { SectionsController } from './sections.controller';
import { SectionsService } from './sections.service';

/**
 * SectionsModule
 *
 * CRUD for the Section aggregate (a Batch × Term sub-group of students).
 * Mirrors TermsModule:
 * - Imports PrismaModule for DB access (from infrastructure/prisma).
 * - Imports AuthModule to consume the exported JwtAuthGuard and
 *   PermissionsGuard. No local auth providers are declared.
 */
@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [SectionsController],
  providers: [SectionsService],
  exports: [SectionsService],
})
export class SectionsModule {}
