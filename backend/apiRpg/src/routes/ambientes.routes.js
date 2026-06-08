import { Router } from 'express';
import * as ambienteController from '../controllers/ambienteController.js';

const router = Router();

router.get('/', ambienteController.listAmbientes);

export default router;
