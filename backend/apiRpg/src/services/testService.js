import { db } from '../config/firebase.js';
import { docToJSON } from '../utils/serialize.js';

/** Lê a coleção `teste` para validar conexão com o Firestore. */
export async function getTestCollectionDocs() {
  const snapshot = await db.collection('teste').get();
  return snapshot.docs.map((doc) => docToJSON(doc.id, doc.data()));
}
