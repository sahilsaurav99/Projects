import { Module } from '@nestjs/common';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';
import { AuthModule } from '../auth/auth.module';
import { CampusesController } from './campuses.controller';
import { CampusesService } from './campuses.service';
import { PrismaModule } from '../../infrastructure/prisma/prisma.module';

/**
 * CampusesModule
 *
 * CRUD for Campus entities. Mirrors InstitutesModule:
 * - Imports PrismaModule for DB access.
 * - Imports AuthModule to consume the exported JwtAuthGuard and PermissionsGuard.
 *   No local auth providers are declared.
 */
@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [CampusesController],
  providers: [CampusesService],
  exports: [CampusesService],
})
export class CampusesModule {}
