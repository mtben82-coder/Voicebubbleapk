import express from 'express';
import * as textTransformController from '../controllers/textTransformController.js';

const router = express.Router();

// Transform single text
router.post('/transform', textTransformController.transformText);

// Batch transform multiple texts
router.post('/batch-transform', textTransformController.batchTransformText);

// Get available transformation actions
router.get('/actions', textTransformController.getTransformationActions);

export default router;