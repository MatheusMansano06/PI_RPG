import { db } from '../config/firebase.js';
import { haversineMeters } from '../utils/geo.js';
import { docToJSON } from '../utils/serialize.js';

export async function listAmbientes() {
  const snapshot = await db.collection('ambientes').get();
  return snapshot.docs.map((doc) => docToJSON(doc.id, doc.data()));
}

function pickLatitude(data) {
  const candidates = [data.latitude, data.lat, data.y];
  for (const value of candidates) {
    const n = Number(value);
    if (Number.isFinite(n)) return n;
  }
  return NaN;
}

function pickLongitude(data) {
  const candidates = [data.longitude, data.lng, data.lon, data.x];
  for (const value of candidates) {
    const n = Number(value);
    if (Number.isFinite(n)) return n;
  }
  return NaN;
}

/**
 * Aceita latitude/longitude (ou x/y) no Firestore.
 * Se `raio` existir, só considera ambientes dentro do raio.
 * Se `raio` não existir, retorna o ambiente mais próximo.
 */
export async function findAmbienteParaCoordenadas(latitude, longitude) {
  const snapshot = await db.collection('ambientes').get();
  let best = null;
  let bestDistance = Infinity;

  for (const doc of snapshot.docs) {
    const data = doc.data();
    const lat = pickLatitude(data);
    const lon = pickLongitude(data);
    const raio = Number(data.raio);

    if (!Number.isFinite(lat) || !Number.isFinite(lon)) {
      continue;
    }

    const dist = haversineMeters(latitude, longitude, lat, lon);
    const hasRaio = Number.isFinite(raio);
    const isInside = hasRaio ? dist <= raio : true;
    if (isInside && dist < bestDistance) {
      bestDistance = dist;
      best = { doc, data, dist, hasRaio, raio };
    }
  }

  if (!best) {
    return { dentroDoAmbiente: false, ambiente: null, distanciaMetros: null };
  }

  return {
    dentroDoAmbiente: true,
    ambiente: docToJSON(best.doc.id, best.data),
    distanciaMetros: Math.round(best.dist * 100) / 100,
    criterio: best.hasRaio ? 'dentro_do_raio' : 'mais_proximo_sem_raio',
  };
}
