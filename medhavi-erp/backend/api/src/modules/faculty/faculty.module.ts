import { Module } from '@nestjs/common';
import { PrismaModule } from '../../infrastructure/prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { FacultyController } from './faculty.controller';
import { FacultyService } from './faculty.service';

/**
 * FacultyModule
 *
 * CRUD for Faculty entities (a teaching/research employee linked to a User and
 * positioned under Institute → (Campus?) → School → Department). Mirrors
 * StudentsModule:
 * - Imports PrismaModule for DB access (from infrastructure/prisma).
 * - Imports AuthModule to consume the exported JwtAuthGuard and
 *   PermissionsGuard. No local auth providers are declared.
 */
@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [FacultyController],
  providers: [FacultyService],
  exports: [FacultyService],
})
export class FacultyModule {}
