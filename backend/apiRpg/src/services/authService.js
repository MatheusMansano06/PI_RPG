import crypto from 'node:crypto';
import { promisify } from 'node:util';
import { FieldValue } from 'firebase-admin/firestore';
import jwt from 'jsonwebtoken';
import { db } from '../config/firebase.js';

const scrypt = promisify(crypto.scrypt);
const usuarios = db.collection('usuarios');
const jwtSecret = crypto
  .createHash('sha256')
  .update(process.env.JWT_SECRET || process.env.FIREBASE_PRIVATE_KEY || 'dev')
  .digest('hex');

export class AuthError extends Error {
  constructor(message, statusCode = 400) {
    super(message);
    this.statusCode = statusCode;
  }
}

export async function register({ nome, email, senha, telefone, curso }) {
  const data = validateRegister({ nome, email, senha, telefone, curso });
  const ref = usuarios.doc(userDocId(data.email));
  const existing = await ref.get();

  if (existing.exists) {
    throw new AuthError('Este e-mail ja esta cadastrado.', 409);
  }

  const password = await hashPassword(data.senha);
  await ref.set({
    nome: data.nome,
    email: data.email,
    telefone: data.telefone,
    curso: data.curso,
    progresso: criarProgressoInicial(),
    senhaHash: password.hash,
    senhaSalt: password.salt,
    dataCriacao: FieldValue.serverTimestamp(),
    ultimoLogin: FieldValue.serverTimestamp(),
  });

  return sessionFor({
    nome: data.nome,
    email: data.email,
    telefone: data.telefone,
    curso: data.curso,
  });
}

export async function login({ email, senha }) {
  const data = validateLogin({ email, senha });
  const ref = usuarios.doc(userDocId(data.email));
  const snap = await ref.get();

  if (!snap.exists) {
    throw new AuthError('E-mail ou senha invalidos.', 401);
  }

  const user = snap.data();
  const passwordMatches = await verifyPassword({
    senha: data.senha,
    hash: user.senhaHash,
    salt: user.senhaSalt,
  });

  if (!passwordMatches) {
    throw new AuthError('E-mail ou senha invalidos.', 401);
  }

  await ref.update({ ultimoLogin: FieldValue.serverTimestamp() });
  return sessionFor({
    nome: user.nome,
    email: user.email,
    telefone: user.telefone,
    curso: user.curso,
  });
}

export async function health() {
  await db.collection('teste').limit(1).get();
  return { ok: true, database: 'firestore' };
}

function validateRegister({ nome, email, senha, telefone, curso }) {
  const normalizedNome = typeof nome === 'string' ? nome.trim() : '';
  const normalizedEmail = normalizeEmail(email);
  const normalizedSenha = typeof senha === 'string' ? senha.trim() : '';
  const normalizedTelefone = typeof telefone === 'string' ? telefone.trim() : '';
  const normalizedCurso = typeof curso === 'string' ? curso.trim() : '';

  if (!normalizedNome) {
    throw new AuthError('Informe o nome do aluno.');
  }

  validateEmail(normalizedEmail);
  validatePassword(normalizedSenha);
  validateTelefone(normalizedTelefone);

  if (!normalizedCurso) {
    throw new AuthError('Informe o curso.');
  }

  return {
    nome: normalizedNome,
    email: normalizedEmail,
    senha: normalizedSenha,
    telefone: normalizedTelefone,
    curso: normalizedCurso,
  };
}

function validateLogin({ email, senha }) {
  const normalizedEmail = normalizeEmail(email);
  const normalizedSenha = typeof senha === 'string' ? senha.trim() : '';

  validateEmail(normalizedEmail);
  if (!normalizedSenha) {
    throw new AuthError('Informe a senha.');
  }

  return {
    email: normalizedEmail,
    senha: normalizedSenha,
  };
}

function normalizeEmail(email) {
  return typeof email === 'string' ? email.trim().toLowerCase() : '';
}

function validateEmail(email) {
  if (!email) {
    throw new AuthError('Informe o e-mail.');
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    throw new AuthError('Informe um e-mail valido.');
  }
}

function validatePassword(senha) {
  if (!senha) {
    throw new AuthError('Informe a senha.');
  }

  if (senha.length < 6) {
    throw new AuthError('A senha precisa ter pelo menos 6 caracteres.');
  }
}

function validateTelefone(telefone) {
  if (!telefone) {
    throw new AuthError('Informe o telefone.');
  }

  const digits = telefone.replace(/\D/g, '');
  if (digits.length < 8) {
    throw new AuthError('Informe um telefone valido.');
  }
}

async function hashPassword(senha) {
  const salt = crypto.randomBytes(16).toString('hex');
  const derivedKey = await scrypt(senha, salt, 64);
  return {
    salt,
    hash: derivedKey.toString('hex'),
  };
}

async function verifyPassword({ senha, hash, salt }) {
  if (typeof hash !== 'string' || typeof salt !== 'string') {
    return false;
  }

  const derivedKey = await scrypt(senha, salt, 64);
  const storedHash = Buffer.from(hash, 'hex');
  const incomingHash = Buffer.from(derivedKey.toString('hex'), 'hex');

  return (
    storedHash.length === incomingHash.length &&
    crypto.timingSafeEqual(storedHash, incomingHash)
  );
}

function userDocId(email) {
  return crypto.createHash('sha256').update(email).digest('hex');
}

function criarProgressoInicial() {
  return {
    ambienteAtualId: 'estacionamento_entrada',
    ambientesConcluidos: [],
    nivel: 1,
    xp: 0,
    atualizadoEm: FieldValue.serverTimestamp(),
  };
}

function sessionFor({ nome, email, telefone, curso }) {
  return {
    nome,
    email,
    telefone: telefone ?? '',
    curso: curso ?? '',
    token: jwt.sign({ email, nome }, jwtSecret, { expiresIn: '7d' }),
  };
}
