import { Module } from '@nestjs/common';
import { PrismaModule } from '../../infrastructure/prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { LmsSessionsController } from './lms-sessions.controller';
import { LmsSessionsService } from './lms-sessions.service';

/**
 * LmsSessionsModule
 *
 * CRUD for the LmsSession aggregate (individual learning sessions within a
 * CourseModule). Mirrors CourseModulesModule:
 * - Imports PrismaModule for DB access (from infrastructure/prisma).
 * - Imports AuthModule to consume the exported JwtAuthGuard and
 *   PermissionsGuard. No local auth providers are declared.
 */
@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [LmsSessionsController],
  providers: [LmsSessionsService],
  exports: [LmsSessionsService],
})
export class LmsSessionsModule {}
