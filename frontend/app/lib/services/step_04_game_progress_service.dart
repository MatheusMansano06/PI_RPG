import '../data/step_01_roteiro_fases.dart';
import '../models/step_04_game_environment_model.dart';
import '../models/step_05_game_progress_model.dart';

enum AmbienteStatus { concluido, atual, bloqueado }

class GameProgressService {
  GameProgressService._();

  static final GameProgressService instance = GameProgressService._();

  GameProgressModel _progress = GameProgressModel(
    ambienteAtualId: roteiroFases.first.id,
    ambientesConcluidos: <String>{},
  );

  GameProgressModel get progress => _progress;

  String? get ambienteAtualId => _progress.ambienteAtualId;

  Set<String> get ambientesConcluidos =>
      Set.unmodifiable(_progress.ambientesConcluidos);

  bool get jogoConcluido =>
      _progress.ambientesConcluidos.length == roteiroFases.length;

  void marcarComoConcluido(String ambienteId) {
    // Chamado pela tela 09 quando a missao termina.
    final concluidos = {..._progress.ambientesConcluidos, ambienteId};
    final proximo = obterProximoAmbiente(concluidos);

    _progress = GameProgressModel(
      ambienteAtualId: proximo?.id,
      ambientesConcluidos: concluidos,
    );
  }

  GameEnvironmentModel? obterProximoAmbiente([Set<String>? concluidos]) {
    final done = concluidos ?? _progress.ambientesConcluidos;

    // A lista roteiroFases ja esta cadastrada na ordem do jogo.
    // Por isso basta pegar a primeira fase que ainda nao foi concluida.
    for (final environment in roteiroFases) {
      if (!done.contains(environment.id)) {
        return environment;
      }
    }

    return null;
  }

  AmbienteStatus verificarStatusAmbiente(String ambienteId) {
    if (_progress.ambientesConcluidos.contains(ambienteId)) {
      return AmbienteStatus.concluido;
    }
    if (_progress.ambienteAtualId == ambienteId) {
      return AmbienteStatus.atual;
    }
    return AmbienteStatus.bloqueado;
  }

  void reiniciar() {
    _progress = GameProgressModel(
      ambienteAtualId: roteiroFases.first.id,
      ambientesConcluidos: <String>{},
    );
  }
}
