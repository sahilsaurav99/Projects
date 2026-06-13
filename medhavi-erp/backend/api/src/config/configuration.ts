export default () => ({
  nodeEnv: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.API_PORT || '4000', 10),
  logLevel: process.env.LOG_LEVEL || 'debug',
  database: {
    url: process.env.DATABASE_URL,
  },
  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379',
  },
  mongo: {
    uri: process.env.MONGODB_URI || 'mongodb://localhost:27017/medhavi_logs',
  },
  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET || 'change-me',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'change-me',
    accessTtl: process.env.JWT_ACCESS_TTL || '900',
    refreshTtl: process.env.JWT_REFRESH_TTL || '2592000',
  },
  storage: {
    endpoint: process.env.S3_ENDPOINT || 'http://localhost:9000',
    region: process.env.S3_REGION || 'us-east-1',
    accessKey: process.env.S3_ACCESS_KEY || 'minioadmin',
    secretKey: process.env.S3_SECRET_KEY || 'minioadmin',
    bucket: process.env.S3_BUCKET || 'medhavi-dev',
  },
});
