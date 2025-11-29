import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import { initRedis, closeRedis, redisHealthCheck } from './config/redis.js';
import { getCacheStats } from './utils/cache.js';
import { checkOpenAIHealth } from './utils/openai.js';
import transcribeRouter from './routes/transcribe.js';
import rewriteRouter from './routes/rewrite.js';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// If true, /health will return 503 when deps are unhealthy.
// If false (default), /health is always 200 and just reports status in JSON.
const STRICT_HEALTHCHECK = process.env.STRICT_HEALTHCHECK === 'true';

// ===== MIDDLEWARE CONFIGURATION =====

// Security headers
app.use(
  helmet({
    contentSecurityPolicy: false, // Allow SSE
    crossOriginEmbedderPolicy: false,
  })
);

// CORS configuration
app.use(
  cors({
    origin:
      NODE_ENV === 'production'
        ? [
            'https://voicebubble.app',
            'https://www.voicebubble.app',
            /\.railway\.app$/,
          ]
        : '*', // Allow all origins in development
    methods: ['GET', 'POST', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
  })
);

// Compression middleware
app.use(
  compression({
    filter: (req, res) => {
      if (req.headers['x-no-compression']) {
        return false;
      }
      return compression.filter(req, res);
    },
    level: 6, // Balanced compression level
  })
);

// Body parsers
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS, 10) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX, 10) || 100, // Limit each IP to 100 requests per window
  message: {
    error: 'Too many requests',
    message: 'Please try again later',
  },
  standardHeaders: true,
  legacyHeaders: false,
  // Skip rate limiting for health checks
  skip: (req) => req.path === '/health',
});

// Apply limiter only to API routes
app.use('/api/', limiter);

// Request logging middleware
app.use((req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`${req.method} ${req.path} - ${res.statusCode} (${duration}ms)`);
  });

  next();
});

// ===== ROUTES =====

// Health check endpoint
app.get('/health', async (req, res) => {
  let redisHealth = {
    status: 'unknown',
    error: null,
  };
  let openaiHealthy = false;
  let openaiError = null;

  try {
    redisHealth = await redisHealthCheck();
  } catch (err) {
    console.error('Redis health check error:', err);
    redisHealth = {
      status: 'unhealthy',
      error: err.message || 'Redis health check failed',
    };
  }

  try {
    openaiHealthy = await checkOpenAIHealth();
  } catch (err) {
    console.error('OpenAI health check error:', err);
    openaiHealthy = false;
    openaiError = err.message || 'OpenAI health check failed';
  }

  const health = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    environment: NODE_ENV,
    services: {
      redis: redisHealth,
      openai: {
        status: openaiHealthy ? 'healthy' : 'unhealthy',
        configured: !!process.env.OPENAI_API_KEY,
        error: openaiError || null,
      },
    },
  };

  const allHealthy =
    redisHealth.status === 'healthy' && openaiHealthy && !!process.env.OPENAI_API_KEY;

  // IMPORTANT:
  // By default, /health returns 200 so Railway doesn't kill the app.
  // If you want strict behavior later, set STRICT_HEALTHCHECK=true in env.
  const statusCode = STRICT_HEALTHCHECK && !allHealthy ? 503 : 200;

  return res.status(statusCode).json({
    ...health,
    overall: allHealthy ? 'healthy' : 'degraded',
    strict_healthcheck: STRICT_HEALTHCHECK,
  });
});

// Stats endpoint (useful for monitoring)
app.get('/stats', async (req, res) => {
  try {
    const cacheStats = await getCacheStats();

    res.json({
      uptime_seconds: process.uptime(),
      memory_usage: process.memoryUsage(),
      node_version: process.version,
      cache: cacheStats,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Stats error:', error);
    res.status(500).json({
      error: 'Failed to get stats',
      message: error.message,
    });
  }
});

// API Routes
app.use('/api/transcribe', transcribeRouter);
app.use('/api/rewrite', rewriteRouter);

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    name: 'VoiceBubble API',
    version: '1.0.0',
    description: 'High-performance backend for voice transcription and text rewriting',
    endpoints: {
      health: '/health',
      stats: '/stats',
      transcribe: 'POST /api/transcribe',
      rewrite: 'POST /api/rewrite (SSE streaming)',
      rewrite_batch: 'POST /api/rewrite/batch',
    },
    documentation: 'https://github.com/yourusername/voicebubble',
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not found',
    message: `Route ${req.method} ${req.path} not found`,
    available_endpoints: ['/', '/health', '/stats', '/api/transcribe', '/api/rewrite'],
  });
});

// Global error handler
// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);

  res.status(err.status || 500).json({
    error: err.name || 'Internal server error',
    message: err.message || 'An unexpected error occurred',
    ...(NODE_ENV === 'development' && { stack: err.stack }),
  });
});

// ===== SERVER INITIALIZATION =====

let server;
let redisInitialized = false;

async function startServer() {
  try {
    console.log('Initializing Redis...');
    try {
      await initRedis();
      redisInitialized = true;
      console.log('Redis initialized');
    } catch (err) {
      redisInitialized = false;
      console.error('Failed to initialize Redis (continuing without Redis):', err);
    }

    if (!process.env.OPENAI_API_KEY) {
      console.warn('WARNING: OPENAI_API_KEY not set. OpenAI-dependent features will fail.');
    } else {
      console.log('OpenAI API key configured');
    }

    server = app.listen(PORT, '0.0.0.0', () => {
      console.log('');
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      console.log('🚀 VoiceBubble Backend Server Running');
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      console.log(`📍 Environment: ${NODE_ENV}`);
      console.log(`🌐 Port: ${PORT}`);
      console.log(`🔗 URL: http://localhost:${PORT}`);
      console.log(`💚 Health: http://localhost:${PORT}/health`);
      console.log(`📊 Stats: http://localhost:${PORT}/stats`);
      console.log(`🧠 Redis: ${redisInitialized ? 'initialized' : 'NOT initialized'}`);
      console.log(
        `🤖 OpenAI: ${process.env.OPENAI_API_KEY ? 'configured' : 'MISSING API KEY'}`
      );
      console.log(`🔒 STRICT_HEALTHCHECK: ${STRICT_HEALTHCHECK}`);
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      console.log('');
    });

    // Keep-alive settings
    server.keepAliveTimeout = 65000; // 65 seconds
    server.headersTimeout = 66000; // Slightly longer than keepAliveTimeout
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

// Graceful shutdown
async function gracefulShutdown(signal) {
  console.log(`\n${signal} received. Starting graceful shutdown...`);

  // Stop accepting new connections
  if (server) {
    await new Promise((resolve) => {
      server.close(() => {
        console.log('HTTP server closed');
        resolve();
      });
    });
  }

  try {
    await closeRedis();
    console.log('Redis connection closed');
  } catch (err) {
    console.error('Error closing Redis connection:', err);
  }

  console.log('Graceful shutdown complete');
  process.exit(0);
}

// Handle shutdown signals
process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Handle uncaught errors
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  gracefulShutdown('uncaughtException');
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

// Start the server
startServer();

export default app;
