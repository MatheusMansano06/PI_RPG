class GameProgressModel {
  const GameProgressModel({
    required this.ambienteAtualId,
    required this.ambientesConcluidos,
  });

  final String? ambienteAtualId;
  final Set<String> ambientesConcluidos;

  GameProgressModel copyWith({
    String? ambienteAtualId,
    Set<String>? ambientesConcluidos,
  }) {
    return GameProgressModel(
      ambienteAtualId: ambienteAtualId ?? this.ambienteAtualId,
      ambientesConcluidos: ambientesConcluidos ?? this.ambientesConcluidos,
    );
  }
}
