import 'dotenv/config';
import express from 'express';
import http from 'http';
import { Server } from 'socket.io';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import { setupSwagger } from './presentation/docs/swagger';
import { errorHandler } from './presentation/middlewares/errorHandler';
import stationRoutes from './presentation/routes/stationRoutes';
import scheduleRoutes from './presentation/routes/scheduleRoutes';
import routeRoutes from './presentation/routes/routeRoutes';
import authRoutes from './presentation/routes/authRoutes';
import ticketRoutes from './presentation/routes/ticketRoutes';
import paymentRoutes from './presentation/routes/paymentRoutes';
import assistantRoutes from './presentation/routes/assistantRoutes';
import utilityRoutes from './presentation/routes/utilityRoutes';
import profileRoutes from './presentation/routes/profileRoutes';
import trackingRoutes from './presentation/routes/trackingRoutes';
import {
  getFeatureReadiness,
  validateProductionConfig,
} from './config/productionConfig';
import { prisma } from './infrastructure/database/prismaClient';

if (process.env.NODE_ENV === 'production') {
  const report = validateProductionConfig();
  for (const warning of report.warnings) {
    console.warn(`[production-config] ${warning}`);
  }
}

const app = express();
const PORT = process.env.PORT || 3000;

// Render terminates HTTPS and forwards requests through one trusted proxy.
app.set('trust proxy', 1);

// Security and Utility Middlewares
app.use(helmet());
const allowedOrigins = process.env.CORS_ORIGINS
  ? process.env.CORS_ORIGINS.split(',').map((origin) => origin.trim())
  : [];
app.use(
  cors({
    origin: allowedOrigins.length === 0 ? true : allowedOrigins,
    credentials: true,
  }),
);
app.use(compression());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per `window` (here, per 15 minutes)
  message: 'Too many requests from this IP, please try again after 15 minutes',
  standardHeaders: true,
  legacyHeaders: false,
  skip: (req) => req.originalUrl === '/api/v1/payments/webhook/xendit',
});
app.use('/api', limiter);

// Swagger Documentation
setupSwagger(app);

// API Routes
app.use('/api/v1/stations', stationRoutes);
app.use('/api/v1/schedules', scheduleRoutes);
app.use('/api/v1/routes', routeRoutes);
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/tickets', ticketRoutes);
app.use('/api/v1/payments', paymentRoutes);
app.use('/api/v1/assistant', assistantRoutes);
app.use('/api/v1/utilities', utilityRoutes);
app.use('/api/v1/profile', profileRoutes);
app.use('/api/v1/tracking', trackingRoutes);
app.get('/health', (_req, res) => {
  res.json({ success: true, data: { status: 'ok', timestamp: new Date().toISOString() } });
});
app.get('/ready', async (_req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    res.json({
      success: true,
      data: {
        status: 'ready',
        database: 'connected',
        features: getFeatureReadiness(),
        timestamp: new Date().toISOString(),
      },
    });
  } catch {
    res.status(503).json({
      success: false,
      error: {
        code: 'DATABASE_UNAVAILABLE',
        message: 'Database is unavailable.',
      },
    });
  }
});

// Global Error Handler
app.use(errorHandler);

const server = http.createServer(app);
export const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

io.on('connection', (socket) => {
  console.log(`User connected: ${socket.id}`);

  // Client subscribes to a specific train
  socket.on('subscribe-train', (trainNumber) => {
    socket.join(`train-${trainNumber}`);
    console.log(`Socket ${socket.id} joined room train-${trainNumber}`);
  });

  socket.on('disconnect', () => {
    console.log(`User disconnected: ${socket.id}`);
  });
});

if (require.main === module) {
  server.listen(PORT, () => {
    console.log(`Server and WebSocket are running on port ${PORT}`);
  });
}

export default app;
