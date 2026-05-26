import '../data/story_mock.dart';
import '../models/game_environment_model.dart';
import '../models/game_progress_model.dart';

enum AmbienteStatus {
  concluido,
  atual,
  bloqueado,
}

class GameProgressService {
  GameProgressService._();

  static final GameProgressService instance = GameProgressService._();

  GameProgressModel _progress = GameProgressModel(
    ambienteAtualId: storyMockEnvironments.first.id,
    ambientesConcluidos: <String>{},
  );

  GameProgressModel get progress => _progress;

  String? get ambienteAtualId => _progress.ambienteAtualId;

  Set<String> get ambientesConcluidos =>
      Set.unmodifiable(_progress.ambientesConcluidos);

  bool get jogoConcluido =>
      _progress.ambientesConcluidos.length == storyMockEnvironments.length;

  void marcarComoConcluido(String ambienteId) {
    final concluidos = {..._progress.ambientesConcluidos, ambienteId};
    final proximo = obterProximoAmbiente(concluidos);

    _progress = GameProgressModel(
      ambienteAtualId: proximo?.id,
      ambientesConcluidos: concluidos,
    );
  }

  GameEnvironmentModel? obterProximoAmbiente([Set<String>? concluidos]) {
    final done = concluidos ?? _progress.ambientesConcluidos;
    final ordered = [...storyMockEnvironments]
      ..sort((a, b) => a.ordem.compareTo(b.ordem));

    for (final environment in ordered) {
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
      ambienteAtualId: storyMockEnvironments.first.id,
      ambientesConcluidos: <String>{},
    );
  }
}
