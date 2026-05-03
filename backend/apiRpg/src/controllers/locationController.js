import * as ambienteService from '../services/ambienteService.js';

function parseCoord(body) {
  const lat = Number(body?.latitude ?? body?.y);
  const lon = Number(body?.longitude ?? body?.x);
  return { lat, lon };
}

export async function checkLocation(req, res) {
  try {
    const { lat, lon } = parseCoord(req.body);
    if (!Number.isFinite(lat) || !Number.isFinite(lon)) {
      return res.status(400).json({
        error:
          'Informe coordenadas numéricas no body: latitude/longitude ou y/x.',
      });
    }
    if (lat < -90 || lat > 90 || lon < -180 || lon > 180) {
      return res.status(400).json({
        error: 'latitude deve estar entre -90 e 90; longitude entre -180 e 180.',
      });
    }

    const result = await ambienteService.findAmbienteParaCoordenadas(lat, lon);
    res.json(result);
  } catch (err) {
    res.status(500).json({
      error: err.message || 'Falha ao verificar localização.',
    });
  }
}
