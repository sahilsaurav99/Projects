import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ConfigType } from '@nestjs/config';
import { Inject } from '@nestjs/common';
import { ExtractJwt, Strategy } from 'passport-jwt';
import authConfig from '../config/auth.config';
import { JwtRefreshPayload } from '../token.service';

@Injectable()
export class JwtRefreshStrategy extends PassportStrategy(Strategy, 'jwt-refresh') {
  constructor(@Inject(authConfig.KEY) cfg: ConfigType<typeof authConfig>) {
    super({
      jwtFromRequest: ExtractJwt.fromBodyField('refreshToken'),
      ignoreExpiration: false,
      secretOrKey: cfg.refreshSecret,
      issuer: cfg.issuer,
      audience: cfg.audience,
      passReqToCallback: false,
    });
  }

  validate(payload: JwtRefreshPayload): JwtRefreshPayload {
    if (payload.typ !== 'refresh') throw new UnauthorizedException('Wrong token type');
    return payload;
  }
}
