import 'dialogue_option_model.dart';

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
