import { Router } from 'express';
import * as playerController from '../controllers/playerController.js';

const router = Router();

router.post('/', playerController.createPlayer);
router.get('/:id', playerController.getPlayerById);

export default router;
