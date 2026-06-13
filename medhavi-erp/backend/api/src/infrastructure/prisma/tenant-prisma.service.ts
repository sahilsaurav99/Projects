import { Injectable } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class TenantPrismaService {
  // Multi-tenant Prisma wrapper
  // Resolves tenant context and scopes queries automatically
}
