import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../decorators/roles.decorator';
import { JwtAccessPayload } from '../token.service';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(ctx: ExecutionContext): boolean {
    const required = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      ctx.getHandler(),
      ctx.getClass(),
    ]);
    if (!required || required.length === 0) return true;

    const user: JwtAccessPayload | undefined = ctx.switchToHttp().getRequest().user;
    if (!user) throw new ForbiddenException('No authenticated user');

    const held = new Set(user.roles.map((r) => r.key));
    const ok = required.some((r) => held.has(r));
    if (!ok) throw new ForbiddenException('Missing required role');
    return true;
  }
}
