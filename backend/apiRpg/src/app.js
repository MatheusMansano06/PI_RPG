import express from 'express';
import cors from 'cors';
import testRoutes from './routes/test.routes.js';
import playersRoutes from './routes/players.routes.js';
import locationRoutes from './routes/location.routes.js';
import ambientesRoutes from './routes/ambientes.routes.js';

const app = express();

app.use(cors());
app.use(express.json());

app.use(testRoutes);
app.use('/players', playersRoutes);
app.use('/jogadores', playersRoutes);
app.use('/ambientes', ambientesRoutes);
app.use('/location', locationRoutes);

export default app;
