import 'step_01_dialogue_option_model.dart';
import 'step_02_npc_model.dart';
import 'step_03_stage_challenge_model.dart';

// Modelo de uma fase/local do jogo.
// Ele e usado no roteiro e tambem nas telas do mapa, dialogo e desafio.
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

  // Nome que aparece para o jogador.
  final String nome;

  // Texto curto explicando o lugar.
  final String descricao;

  // Coordenadas usadas pelo mapa e pelo GPS.
  final double latitude;
  final double longitude;

  // Distancia maxima para liberar a fase.
  final double raioMetros;

  // Numero da fase no jogo.
  final int stageNumber;

  final String missionTitle;
  final String missionDescription;
  final String introText;

  // Personagem que aparece neste local.
  final NpcModel npc;

  // Falas de escolha antes da pergunta principal.
  final List<DialogueOptionModel> dialogue;

  // Pergunta que precisa acertar para concluir a missao.
  final StageChallengeModel challenge;

  final String completionText;
  final String nextHint;

  int get ordem => stageNumber;

  List<DialogueOptionModel> get opcoes => dialogue;

  String get dicaParaProximoLocal => nextHint;

  String get textoMissaoConcluida => completionText;
}
