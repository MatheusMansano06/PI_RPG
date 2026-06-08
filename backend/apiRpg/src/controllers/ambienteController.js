import * as ambienteService from '../services/ambienteService.js';

export async function listAmbientes(_req, res) {
  try {
    const ambientes = await ambienteService.listAmbientes();
    res.json(ambientes);
  } catch (err) {
    res.status(500).json({
      error: err.message || 'Não foi possível listar ambientes.',
    });
  }
}
