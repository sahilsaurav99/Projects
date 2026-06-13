export const jwtConfig = {
  accessSecret: process.env.JWT_ACCESS_SECRET || 'change-me',
  refreshSecret: process.env.JWT_REFRESH_SECRET || 'change-me',
  accessTtl: process.env.JWT_ACCESS_TTL || '900',
  refreshTtl: process.env.JWT_REFRESH_TTL || '2592000',
};
