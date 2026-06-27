import { Module } from '@nestjs/common';
import { PrismaModule } from '../../infrastructure/prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { TermsController } from './terms.controller';
import { TermsService } from './terms.service';

/**
 * TermsModule
 *
 * CRUD for the Term aggregate (an academic term/semester scoped to an
 * Institute and owned by an AcademicYear). Mirrors SubjectsModule:
 * - Imports PrismaModule for DB access (from infrastructure/prisma).
 * - Imports AuthModule to consume the exported JwtAuthGuard and
 *   PermissionsGuard. No local auth providers are declared.
 */
@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [TermsController],
  providers: [TermsService],
  exports: [TermsService],
})
export class TermsModule {}
