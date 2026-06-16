import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Ip,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import type { Request } from 'express';
import { AuthService } from './auth.service';
import { CurrentUser } from './decorators/current-user.decorator';
import { Public } from './decorators/public.decorator';
import { AuthResponseDto, TokenPairDto } from './dto/auth-response.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { LoginDto } from './dto/login.dto';
import { MeResponseDto } from './dto/me-response.dto';
import { RefreshDto } from './dto/refresh.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { JwtRefreshGuard } from './guards/jwt-refresh.guard';
import type { JwtAccessPayload, JwtRefreshPayload } from './token.service';

function ctxFrom(req: Request, ip?: string) {
  return {
    ip: ip ?? req.ip ?? null,
    userAgent: (req.headers['user-agent'] as string | undefined) ?? null,
    requestId: (req.headers['x-request-id'] as string | undefined) ?? null,
    traceId: (req.headers['x-trace-id'] as string | undefined) ?? null,
  };
}

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Public()
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @ApiOperation({ summary: 'Authenticate with email + password' })
  @ApiBody({ type: LoginDto })
  @ApiOkResponse({ type: AuthResponseDto })
  @ApiUnauthorizedResponse({ description: 'Invalid credentials or locked account' })
  login(@Body() dto: LoginDto, @Req() req: Request, @Ip() ip: string) {
    return this.auth.login(dto.email, dto.password, {
      ...ctxFrom(req, ip),
      deviceName: dto.deviceName,
    });
  }

  @Public()
  @UseGuards(JwtRefreshGuard)
  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Rotate refresh token, get new access+refresh pair' })
  @ApiBody({ type: RefreshDto })
  @ApiOkResponse({ type: TokenPairDto })
  refresh(@Body() dto: RefreshDto, @Req() req: Request, @Ip() ip: string) {
    return this.auth.refresh(dto.refreshToken, ctxFrom(req, ip));
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Revoke current session (or all sessions)' })
  async logout(
    @CurrentUser() user: JwtAccessPayload,
    @Body() body: { allDevices?: boolean } = {},
    @Req() req: Request,
    @Ip() ip: string,
  ): Promise<void> {
    await this.auth.logout(
      { sub: user.sub, sid: user.sid, jti: user.jti, exp: user.exp },
      Boolean(body.allDevices),
      ctxFrom(req, ip),
    );
  }

  @Public()
  @Post('forgot-password')
  @HttpCode(HttpStatus.ACCEPTED)
  @Throttle({ default: { limit: 3, ttl: 60_000 } })
  @ApiOperation({ summary: 'Request a password reset email' })
  @ApiBody({ type: ForgotPasswordDto })
  async forgot(
    @Body() dto: ForgotPasswordDto,
    @Req() req: Request,
    @Ip() ip: string,
  ): Promise<{ status: 'accepted' }> {
    await this.auth.forgotPassword(dto.email, ctxFrom(req, ip));
    return { status: 'accepted' };
  }

  @Public()
  @Post('reset-password')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Consume reset token, set new password' })
  @ApiBody({ type: ResetPasswordDto })
  async reset(@Body() dto: ResetPasswordDto, @Req() req: Request, @Ip() ip: string): Promise<void> {
    await this.auth.resetPassword(dto.token, dto.newPassword, ctxFrom(req, ip));
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('me')
  @ApiOperation({ summary: 'Current user, roles, and resolved permissions' })
  @ApiOkResponse({ type: MeResponseDto })
  me(@CurrentUser() user: JwtAccessPayload): Promise<MeResponseDto> {
    return this.auth.me(user.sub);
  }
}
