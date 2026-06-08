import 'package:flutter/material.dart';

import '../widgets/step_01_game_background.dart';
import '../widgets/step_04_game_button.dart';
import '../widgets/step_02_game_card.dart';
import '../widgets/step_06_game_hud_badge.dart';
import '../widgets/step_03_game_section_title.dart';
import 'game/step_05_map_game_screen.dart';

class PrologueScreen extends StatelessWidget {
  const PrologueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 680 || size.width < 420;

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/prologue_campus.png',
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 16 : 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: GameGlassCard(
                  padding: EdgeInsets.all(compact ? 18 : 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          GameHudBadge(
                            icon: Icons.school_outlined,
                            label: 'Campus I • PUC-Campinas',
                          ),
                          GameHudBadge(
                            icon: Icons.notification_important_outlined,
                            label: 'Alerta de matrícula',
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      GameSectionTitle(
                        eyebrow: 'ABERTURA',
                        title: 'Primeiro dia na PUC-Campinas',
                        subtitle:
                            'Uma notificação urgente transforma a chegada ao campus em uma missão de orientação.',
                        icon: Icons.auto_stories,
                        compact: compact,
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      const _NarrativeParagraph(
                        text:
                            'Você é um calouro chegando ao Campus I. Antes da primeira aula, uma notificação aparece no celular: existe uma pendência na sua matrícula.',
                      ),
                      const SizedBox(height: 12),
                      const _MissionCallout(
                        text:
                            'Missão principal: explorar o campus, conversar com personagens e resolver o bloqueio antes que o primeiro dia fique confuso.',
                      ),
                      const SizedBox(height: 12),
                      const _NarrativeParagraph(
                        text:
                            'Cada ambiente revela uma pista. Cada escolha aproxima você da solução ou mostra uma consequência comum da vida universitária.',
                        muted: true,
                      ),
                      SizedBox(height: compact ? 18 : 24),
                      GameButton(
                        label: 'Começar missão',
                        icon: Icons.travel_explore,
                        compact: compact,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => const GameMapScreen(),
                            ),
                          );
                        },
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
}

class _NarrativeParagraph extends StatelessWidget {
  const _NarrativeParagraph({required this.text, this.muted = false});

  final String text;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: muted ? const Color(0xFFCBD5E1) : Colors.white,
        fontSize: 16,
        height: 1.45,
        fontWeight: muted ? FontWeight.w600 : FontWeight.w800,
      ),
    );
  }
}

class _MissionCallout extends StatelessWidget {
  const _MissionCallout({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5C542).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF5C542).withValues(alpha: 0.36),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.flag_outlined, color: Color(0xFFF5C542)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFFDE68A),
                height: 1.35,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
