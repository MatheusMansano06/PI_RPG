import 'package:flutter/material.dart';

import '../../models/step_01_dialogue_option_model.dart';
import '../../models/step_04_game_environment_model.dart';
import '../../services/step_05_audio_manager.dart';
import '../../widgets/step_01_game_background.dart';
import '../../widgets/step_04_game_button.dart';
import '../../widgets/step_02_game_card.dart';
import '../../widgets/step_06_game_hud_badge.dart';
import '../../widgets/step_03_game_section_title.dart';
import 'step_09_stage_complete_screen.dart';

// Tela da pergunta da fase.
// Ela e chamada pela tela 07_npc_dialogue_screen depois da conversa com o personagem.
class StageChallengeScreen extends StatefulWidget {
  const StageChallengeScreen({super.key, required this.environment});

  final GameEnvironmentModel environment;

  @override
  State<StageChallengeScreen> createState() => _StageChallengeScreenState();
}

class _StageChallengeScreenState extends State<StageChallengeScreen> {
  // Guarda a opcao que o jogador clicou.
  DialogueOptionModel? _selectedOption;

  // Fica true so quando a resposta correta foi escolhida.
  bool _completed = false;

  String get _status {
    // Texto que aparece na caixa de retorno.
    final selected = _selectedOption;
    if (selected == null) {
      return 'Escolha a resposta correta para concluir esta missão.';
    }
    return selected.reacao;
  }

  @override
  Widget build(BuildContext context) {
    // Pegamos a pergunta que esta cadastrada no roteiro da fase.
    final challenge = widget.environment.challenge;
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 700 || size.width < 420;

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/dialog_campus.png',
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 14 : 18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: GameGlassCard(
                  padding: EdgeInsets.all(compact ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          GameHudBadge(
                            icon: Icons.flag_outlined,
                            label: 'Fase',
                            value: '${widget.environment.stageNumber}',
                          ),
                          GameHudBadge(
                            icon: Icons.quiz_outlined,
                            label: 'Modo',
                            value: 'Pergunta',
                          ),
                          GameHudBadge(
                            icon: Icons.bolt_outlined,
                            label: 'XP',
                            value: '+${challenge.rewardXp}',
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      GameSectionTitle(
                        eyebrow: 'PERGUNTA DA MISSÃO',
                        title: challenge.title,
                        subtitle: challenge.description,
                        icon: Icons.psychology_outlined,
                        compact: compact,
                      ),
                      const SizedBox(height: 16),
                      _StatusBox(
                        text: _status,
                        success: _completed,
                        hasSelection: _selectedOption != null,
                      ),
                      const SizedBox(height: 16),
                      for (final option in challenge.options) ...[
                        // Monta um botao para cada resposta cadastrada no roteiro.
                        _QuestionOptionButton(
                          option: option,
                          selected: _selectedOption == option,
                          locked: _completed,
                          onPressed: () => _selectOption(option),
                        ),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 6),
                      if (_completed)
                        GameButton(
                          label: 'Concluir missão',
                          icon: Icons.check_circle,
                          compact: compact,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => StageCompleteScreen(
                                  environment: widget.environment,
                                ),
                              ),
                            );
                          },
                        )
                      else
                        GameButton(
                          label: 'Voltar para o personagem',
                          icon: Icons.arrow_back,
                          variant: GameButtonVariant.secondary,
                          compact: compact,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectOption(DialogueOptionModel option) {
    // Depois que completou, nao deixa trocar resposta.
    if (_completed) {
      return;
    }

    // Toca som diferente para acerto e erro.
    if (option.correta) {
      AudioManager().playCorrect();
    } else {
      AudioManager().playWrong();
    }

    setState(() {
      // Atualiza a tela para mostrar a reacao da resposta.
      _selectedOption = option;
      _completed = option.correta;
    });
  }
}

class _StatusBox extends StatelessWidget {
  const _StatusBox({
    required this.text,
    required this.success,
    required this.hasSelection,
  });

  final String text;
  final bool success;
  final bool hasSelection;

  @override
  Widget build(BuildContext context) {
    // A cor muda conforme a resposta:
    // verde = acertou, vermelho = errou, azul = ainda nao respondeu.
    Color color = const Color(0xFF38BDF8);
    if (hasSelection) {
      color = const Color(0xFFF87171);
    }
    if (success) {
      color = const Color(0xFF4ADE80);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.42)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          height: 1.3,
        ),
      ),
    );
  }
}

class _QuestionOptionButton extends StatelessWidget {
  const _QuestionOptionButton({
    required this.option,
    required this.selected,
    required this.locked,
    required this.onPressed,
  });

  final DialogueOptionModel option;
  final bool selected;
  final bool locked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Comeca com borda azul, igual opcao normal.
    Color borderColor = const Color(0xFF38BDF8).withValues(alpha: 0.24);
    IconData icon = Icons.radio_button_unchecked;

    // Quando o jogador clica, mostramos se acertou ou errou.
    if (selected && option.correta) {
      borderColor = const Color(0xFF4ADE80);
      icon = Icons.check_circle;
    }

    if (selected && !option.correta) {
      borderColor = const Color(0xFFF87171);
      icon = Icons.cancel;
    }

    return OutlinedButton.icon(
      onPressed: locked ? null : onPressed,
      icon: Icon(icon),
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          option.texto,
          style: const TextStyle(fontWeight: FontWeight.w900, height: 1.25),
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        side: BorderSide(color: borderColor, width: selected ? 2 : 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.68),
      ),
    );
  }
}
