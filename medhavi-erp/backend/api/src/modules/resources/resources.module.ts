import { Module } from '@nestjs/common';
import { PrismaModule } from '../../infrastructure/prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { ResourcesController } from './resources.controller';
import { ResourcesService } from './resources.service';

/**
 * ResourcesModule
 *
 * CRUD for the Resource aggregate (downloadable / linked learning assets
 * scoped optionally to a Course, CourseModule or LmsSession). Mirrors
 * CoursesModule / CourseModulesModule:
 * - Imports PrismaModule for DB access (from infrastructure/prisma).
 * - Imports AuthModule to consume the exported JwtAuthGuard and
 *   PermissionsGuard. No local auth providers are declared.
 */
@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [ResourcesController],
  providers: [ResourcesService],
  exports: [ResourcesService],
})
export class ResourcesModule {}
