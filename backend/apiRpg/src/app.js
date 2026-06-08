import express from 'express';
import cors from 'cors';
import testRoutes from './routes/test.routes.js';
import playersRoutes from './routes/players.routes.js';
import locationRoutes from './routes/location.routes.js';
import ambientesRoutes from './routes/ambientes.routes.js';
import authRoutes from './routes/auth.routes.js';
import { requireAuth } from './middleware/authMiddleware.js';

const app = express();

app.use(cors());
app.use(express.json());

app.use(testRoutes);
app.use('/jogadores', requireAuth, playersRoutes);
app.use('/auth', authRoutes);
app.use('/ambientes', ambientesRoutes);
app.use('/location', locationRoutes);

export default app;
