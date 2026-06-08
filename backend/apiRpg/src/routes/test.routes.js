import { Router } from 'express';
import * as testController from '../controllers/testController.js';

const router = Router();

router.get('/test', testController.getTest);

export default router;
