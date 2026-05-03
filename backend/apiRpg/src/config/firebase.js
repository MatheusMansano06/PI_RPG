import './env.js';
import admin from 'firebase-admin';

const projectId = process.env.FIREBASE_PROJECT_ID?.trim();
const clientEmail = process.env.FIREBASE_CLIENT_EMAIL?.trim();
const privateKeyRaw = process.env.FIREBASE_PRIVATE_KEY?.trim();

const required = { FIREBASE_PROJECT_ID: projectId, FIREBASE_CLIENT_EMAIL: clientEmail, FIREBASE_PRIVATE_KEY: privateKeyRaw };
const missing = Object.entries(required)
  .filter(([, value]) => !value)
  .map(([name]) => name);

if (missing.length) {
  console.error(
    `[Firebase] Defina estas variáveis no .env: ${missing.join(', ')}`
  );
  process.exit(1);
}

const privateKey = privateKeyRaw.replace(/\\n/g, '\n');

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert({
      projectId,
      clientEmail,
      privateKey,
    }),
  });
}

const db = admin.firestore();

export { db };
