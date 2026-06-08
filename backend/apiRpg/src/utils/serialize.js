import { Timestamp } from 'firebase-admin/firestore';

function serializeValue(v) {
  if (v instanceof Timestamp) {
    return v.toDate().toISOString();
  }
  if (v && typeof v === 'object' && !Array.isArray(v)) {
    return serializeFirestoreData(v);
  }
  if (Array.isArray(v)) {
    return v.map(serializeValue);
  }
  return v;
}

export function serializeFirestoreData(data) {
  if (!data || typeof data !== 'object') return data;
  const out = {};
  for (const [key, val] of Object.entries(data)) {
    out[key] = serializeValue(val);
  }
  return out;
}

export function docToJSON(id, data) {
  return { id, ...serializeFirestoreData(data) };
}
