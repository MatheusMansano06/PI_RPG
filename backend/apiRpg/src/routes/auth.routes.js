import { Router } from 'express';
import * as authController from '../controllers/authController.js';

const router = Router();

router.get('/health', authController.health);
router.post('/register', authController.register);
router.post('/login', authController.login);

export default router;
