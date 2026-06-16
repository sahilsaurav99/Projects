import { SetMetadata } from '@nestjs/common';

export const ROLES_KEY = 'requiredRoleKeys';
/** Caller must hold AT LEAST ONE of the role keys (e.g. 'HOD', 'INSTITUTE_ADMIN'). */
export const Roles = (...roleKeys: string[]) => SetMetadata(ROLES_KEY, roleKeys);
