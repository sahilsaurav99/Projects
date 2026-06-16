import { Injectable } from '@nestjs/common';
import {
  AuditAction,
  LoginResult,
  Prisma,
  SecurityEventType,
  SecuritySeverity,
} from '@prisma/client';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';

export interface RequestCtx {
  ip?: string | null;
  userAgent?: string | null;
  requestId?: string | null;
  traceId?: string | null;
}

@Injectable()
export class AuditService {
  constructor(private readonly prisma: PrismaService) {}

  async recordLoginAttempt(args: {
    userId: string | null;
    emailTried: string | null;
    result: LoginResult;
    reason?: string | null;
    ctx: RequestCtx;
  }): Promise<void> {
    await this.prisma.loginAttempt.create({
      data: {
        userId: args.userId ?? undefined,
        emailTried: args.emailTried ?? undefined,
        result: args.result,
        reason: args.reason ?? undefined,
        ipAddress: args.ctx.ip ?? undefined,
        userAgent: args.ctx.userAgent ?? undefined,
      },
    });
  }

  async recordAudit(args: {
    instituteId?: string | null;
    actorUserId?: string | null;
    actorRoleKey?: string | null;
    action: AuditAction;
    entityType: string;
    entityId?: string | null;
    summary?: string;
    before?: Prisma.InputJsonValue;
    after?: Prisma.InputJsonValue;
    ctx: RequestCtx;
  }): Promise<void> {
    await this.prisma.auditLog.create({
      data: {
        instituteId: args.instituteId ?? undefined,
        actorUserId: args.actorUserId ?? undefined,
        actorRoleKey: args.actorRoleKey ?? undefined,
        action: args.action,
        entityType: args.entityType,
        entityId: args.entityId ?? undefined,
        summary: args.summary,
        before: args.before,
        after: args.after,
        ipAddress: args.ctx.ip ?? undefined,
        userAgent: args.ctx.userAgent ?? undefined,
        requestId: args.ctx.requestId ?? undefined,
        traceId: args.ctx.traceId ?? undefined,
      },
    });
  }

  async recordSecurityEvent(args: {
    instituteId?: string | null;
    userId?: string | null;
    eventType: SecurityEventType;
    severity?: SecuritySeverity;
    message?: string;
    context?: Prisma.InputJsonValue;
    ctx: RequestCtx;
  }): Promise<void> {
    await this.prisma.securityEvent.create({
      data: {
        instituteId: args.instituteId ?? undefined,
        userId: args.userId ?? undefined,
        eventType: args.eventType,
        severity: args.severity ?? SecuritySeverity.INFO,
        message: args.message,
        context: args.context,
        ipAddress: args.ctx.ip ?? undefined,
        userAgent: args.ctx.userAgent ?? undefined,
      },
    });
  }
}
