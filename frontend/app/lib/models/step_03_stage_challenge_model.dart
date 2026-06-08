import 'step_01_dialogue_option_model.dart';

// Modelo da pergunta/desafio da fase.
// Antes tinha mini jogo, mas agora ficou pergunta para ser mais direto.
class StageChallengeModel {
  const StageChallengeModel({
    required this.title,
    required this.description,
    required this.options,
    this.rewardXp = 100,
    this.rewardText = 'Recompensa narrativa desbloqueada.',
  });

  final String title;
  final String description;
  final List<DialogueOptionModel> options;
  final int rewardXp;
  final String rewardText;
}
