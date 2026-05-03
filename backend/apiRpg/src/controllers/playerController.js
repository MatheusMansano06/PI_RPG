import * as playerService from '../services/playerService.js';

export async function createPlayer(req, res) {
  try {
    const { nome, personagem, classe } = req.body ?? {};
    if (
      typeof nome !== 'string' ||
      !nome.trim() ||
      typeof personagem !== 'string' ||
      !personagem.trim() ||
      typeof classe !== 'string' ||
      !classe.trim()
    ) {
      return res.status(400).json({
        error:
          'Campos obrigatórios: nome, personagem e classe (strings não vazias).',
      });
    }

    const player = await playerService.createPlayer({
      nome: nome.trim(),
      personagem: personagem.trim(),
      classe: classe.trim(),
    });
    res.status(201).json(player);
  } catch (err) {
    res.status(500).json({
      error: err.message || 'Não foi possível criar o jogador.',
    });
  }
}

export async function getPlayerById(req, res) {
  try {
    const { id } = req.params;
    const player = await playerService.getPlayerById(id);
    if (!player) {
      return res.status(404).json({ error: 'Jogador não encontrado.' });
    }
    res.json(player);
  } catch (err) {
    res.status(500).json({
      error: err.message || 'Não foi possível buscar o jogador.',
    });
  }
}
