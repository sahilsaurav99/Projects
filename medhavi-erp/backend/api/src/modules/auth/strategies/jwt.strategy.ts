import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ConfigType } from '@nestjs/config';
import { Inject, UnauthorizedException } from '@nestjs/common';
import { ExtractJwt, Strategy } from 'passport-jwt';
import authConfig from '../config/auth.config';
import { TokenService, JwtAccessPayload } from '../token.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(
    @Inject(authConfig.KEY) cfg: ConfigType<typeof authConfig>,
    private readonly tokens: TokenService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: cfg.accessSecret,
      issuer: cfg.issuer,
      audience: cfg.audience,
    });
  }

  async validate(payload: JwtAccessPayload): Promise<JwtAccessPayload> {
    if (payload.typ !== 'access') throw new UnauthorizedException('Wrong token type');
    if (await this.tokens.isAccessDenylisted(payload.jti)) {
      throw new UnauthorizedException('Token revoked');
    }
    return payload;
  }
}
