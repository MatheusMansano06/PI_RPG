import 'package:flutter/material.dart';

import '../../models/dialogue_option_model.dart';
import '../../models/game_environment_model.dart';
import '../../widgets/game_background.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_card.dart';
import '../../widgets/game_choice_button.dart';
import '../../widgets/game_section_title.dart';
import '../../widgets/npc_dialogue_card.dart';
import 'stage_challenge_screen.dart';

class NpcDialogueScreen extends StatefulWidget {
  const NpcDialogueScreen({super.key, required this.environment});

  final GameEnvironmentModel environment;

  @override
  State<NpcDialogueScreen> createState() => _NpcDialogueScreenState();
}

class _NpcDialogueScreenState extends State<NpcDialogueScreen> {
  DialogueOptionModel? _selectedOption;

  bool get _answeredCorrectly => _selectedOption?.correta ?? false;

  @override
  Widget build(BuildContext context) {
    final environment = widget.environment;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GameSectionTitle(
                      eyebrow: 'DIALOGO DA FASE ${environment.stageNumber}',
                      title: environment.nome,
                      subtitle:
                          'Leia a fala do NPC e escolha uma resposta para avancar na narrativa.',
                      icon: Icons.forum_outlined,
                      compact: compact,
                    ),
                    SizedBox(height: compact ? 14 : 18),
                    NpcDialogueCard(
                      npc: environment.npc,
                      locationName: environment.nome,
                    ),
                    SizedBox(height: compact ? 14 : 18),
                    GameGlassCard(
                      padding: EdgeInsets.all(compact ? 14 : 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Escolha sua resposta',
                            style: TextStyle(
                              color: Color(0xFFF5C542),
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...environment.dialogue.map(_buildOptionButton),
                          if (_selectedOption != null) ...[
                            const SizedBox(height: 4),
                            _ReactionBox(option: _selectedOption!),
                            const SizedBox(height: 14),
                            if (_answeredCorrectly)
                              GameButton(
                                label: 'Ir para desafio',
                                icon: Icons.extension,
                                compact: compact,
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute<void>(
                                      builder: (_) => StageChallengeScreen(
                                        environment: environment,
                                      ),
                                    ),
                                  );
                                },
                              )
                            else
                              GameButton(
                                label: 'Tentar dialogo novamente',
                                icon: Icons.refresh,
                                variant: GameButtonVariant.secondary,
                                compact: compact,
                                onPressed: () {
                                  setState(() {
                                    _selectedOption = null;
                                  });
                                },
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(DialogueOptionModel option) {
    final selected = _selectedOption == option;
    final state = !selected
        ? GameChoiceState.idle
        : option.correta
        ? GameChoiceState.correct
        : GameChoiceState.wrong;

    return GameChoiceButton(
      label: option.texto,
      state: state,
      onPressed: _answeredCorrectly
          ? null
          : () {
              setState(() {
                _selectedOption = option;
              });
            },
    );
  }
}

class _ReactionBox extends StatelessWidget {
  const _ReactionBox({required this.option});

  final DialogueOptionModel option;

  @override
  Widget build(BuildContext context) {
    final color = option.correta
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        option.reacao,
        style: TextStyle(
          color: option.correta
              ? const Color(0xFFBBF7D0)
              : const Color(0xFFFECACA),
          fontWeight: FontWeight.w800,
          height: 1.3,
        ),
      ),
    );
  }
}
