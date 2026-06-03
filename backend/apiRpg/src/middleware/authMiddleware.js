import crypto from 'node:crypto';
import jwt from 'jsonwebtoken';

const jwtSecret = crypto
  .createHash('sha256')
  .update(process.env.JWT_SECRET || process.env.FIREBASE_PRIVATE_KEY || 'dev')
  .digest('hex');

export function requireAuth(req, res, next) {
  const header = req.get('authorization') || '';
  const [scheme, token] = header.split(' ');

  if (scheme !== 'Bearer' || !token) {
    return res.status(401).json({ error: 'Token de autenticacao ausente.' });
  }

  try {
    req.user = jwt.verify(token, jwtSecret);
    next();
  } catch (_) {
    res.status(401).json({ error: 'Token de autenticacao invalido.' });
  }
}
