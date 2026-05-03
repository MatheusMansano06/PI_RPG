import * as testService from '../services/testService.js';

export async function getTest(_req, res) {
  try {
    const data = await testService.getTestCollectionDocs();
    res.json(data);
  } catch (err) {
    res.status(500).json({
      error: err.message || 'Falha ao ler a coleção teste no Firestore',
    });
  }
}
