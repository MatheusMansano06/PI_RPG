import { FieldValue } from 'firebase-admin/firestore';
import { db } from '../config/firebase.js';
import { docToJSON } from '../utils/serialize.js';

export async function createPlayer({ nome, personagem, classe }) {
  const ref = db.collection('jogadores').doc();
  const payload = {
    nome,
    personagem,
    classe,
    nivel: 1,
    xp: 0,
    dataCriacao: FieldValue.serverTimestamp(),
  };
  await ref.set(payload);
  const snap = await ref.get();
  return docToJSON(snap.id, snap.data());
}

export async function getPlayerById(id) {
  const snap = await db.collection('jogadores').doc(id).get();
  if (!snap.exists) return null;
  return docToJSON(snap.id, snap.data());
}
