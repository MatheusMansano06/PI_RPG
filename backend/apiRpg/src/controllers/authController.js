import * as authService from '../services/authService.js';

export async function register(req, res) {
  try {
    const session = await authService.register(req.body ?? {});
    res.status(201).json(session);
  } catch (err) {
    sendAuthError(res, err, 'Nao foi possivel cadastrar.');
  }
}

export async function login(req, res) {
  try {
    const session = await authService.login(req.body ?? {});
    res.json(session);
  } catch (err) {
    sendAuthError(res, err, 'Nao foi possivel entrar.');
  }
}

export async function health(_req, res) {
  try {
    res.json(await authService.health());
  } catch (err) {
    res.status(503).json({
      error: err.message || 'Banco de dados indisponivel.',
    });
  }
}

function sendAuthError(res, err, fallbackMessage) {
  res.status(err.statusCode || 500).json({
    error: err.message || fallbackMessage,
  });
}
