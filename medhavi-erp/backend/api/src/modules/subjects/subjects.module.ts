import { Module } from '@nestjs/common';
import { PrismaModule } from '../../infrastructure/prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { SubjectsController } from './subjects.controller';
import { SubjectsService } from './subjects.service';

/**
 * SubjectsModule
 *
 * CRUD for the Subject aggregate (an academic subject scoped to an Institute,
 * owned by a Department, optionally associated with a Program). Mirrors
 * FacultyModule:
 * - Imports PrismaModule for DB access (from infrastructure/prisma).
 * - Imports AuthModule to consume the exported JwtAuthGuard and
 *   PermissionsGuard. No local auth providers are declared.
 */
@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [SubjectsController],
  providers: [SubjectsService],
  exports: [SubjectsService],
})
export class SubjectsModule {}
