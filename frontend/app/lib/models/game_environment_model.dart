import 'dialogue_option_model.dart';
import 'npc_model.dart';
import 'stage_challenge_model.dart';

class GameEnvironmentModel {
  const GameEnvironmentModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.latitude,
    required this.longitude,
    required this.raioMetros,
    required this.stageNumber,
    required this.missionTitle,
    required this.missionDescription,
    required this.introText,
    required this.npc,
    required this.dialogue,
    required this.challenge,
    required this.completionText,
    required this.nextHint,
  });

  final String id;
  final String nome;
  final String descricao;
  final double latitude;
  final double longitude;
  final double raioMetros;
  final int stageNumber;
  final String missionTitle;
  final String missionDescription;
  final String introText;
  final NpcModel npc;
  final List<DialogueOptionModel> dialogue;
  final StageChallengeModel challenge;
  final String completionText;
  final String nextHint;

  int get ordem => stageNumber;

  List<DialogueOptionModel> get opcoes => dialogue;

  String get dicaParaProximoLocal => nextHint;

  String get textoMissaoConcluida => completionText;
}
