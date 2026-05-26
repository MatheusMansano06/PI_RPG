import 'package:flutter/material.dart';

import '../../models/dialogue_option_model.dart';
import '../../models/game_environment_model.dart';
import '../../widgets/game_background.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_card.dart';
import '../../widgets/game_choice_button.dart';
import '../../widgets/game_hud_badge.dart';
import '../../widgets/game_section_title.dart';
import 'stage_complete_screen.dart';

class StageChallengeScreen extends StatefulWidget {
  const StageChallengeScreen({super.key, required this.environment});

  final GameEnvironmentModel environment;

  @override
  State<StageChallengeScreen> createState() => _StageChallengeScreenState();
}

class _StageChallengeScreenState extends State<StageChallengeScreen> {
  DialogueOptionModel? _selectedOption;

  bool get _answeredCorrectly => _selectedOption?.correta ?? false;

  @override
  Widget build(BuildContext context) {
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
                constraints: const BoxConstraints(maxWidth: 720),
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
                            icon: Icons.bolt_outlined,
                            label: 'XP',
                            value: '+${challenge.rewardXp}',
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      GameSectionTitle(
                        eyebrow: 'DESAFIO DA MISSAO',
                        title: challenge.title,
                        subtitle: challenge.description,
                        icon: Icons.psychology_alt_outlined,
                        compact: compact,
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      ...challenge.options.map(_buildOptionButton),
                      if (_selectedOption != null) ...[
                        const SizedBox(height: 4),
                        _ReactionBox(option: _selectedOption!),
                        const SizedBox(height: 14),
                        if (_answeredCorrectly)
                          GameButton(
                            label: 'Concluir fase',
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
                            label: 'Tentar novamente',
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
      icon: Icons.psychology,
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
