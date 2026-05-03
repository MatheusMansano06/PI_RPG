import { Router } from 'express';
import * as locationController from '../controllers/locationController.js';

const router = Router();

router.post('/check', locationController.checkLocation);

export default router;
