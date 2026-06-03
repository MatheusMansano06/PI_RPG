import 'package:flutter/material.dart';

import '../../models/game_environment_model.dart';
import '../../widgets/game_background.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_card.dart';
import 'stage_complete_screen.dart';

class NpcDialogueScreen extends StatefulWidget {
  const NpcDialogueScreen({super.key, required this.environment});

  final GameEnvironmentModel environment;

  @override
  State<NpcDialogueScreen> createState() => _NpcDialogueScreenState();
}

class _NpcDialogueScreenState extends State<NpcDialogueScreen>
    with SingleTickerProviderStateMixin {
  bool _sceneReady = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) {
        return;
      }
      setState(() => _sceneReady = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final environment = widget.environment;
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 700 || size.width < 420;
    final persona = _npcPersona(environment.npc.nome);

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/dialog_campus.png',
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: !_sceneReady
                ? const Center(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  )
                : Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(compact ? 14 : 18),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 780),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _NpcCinematicHeader(
                              stage: environment.stageNumber,
                              location: environment.nome,
                            ),
                            const SizedBox(height: 14),
                            _NpcHeroScene(
                              imagePath: persona.imagePath,
                              role: persona.role,
                              color: persona.color,
                              name: environment.npc.nome,
                              speech: environment.npc.falaInicial,
                            ),
                            const SizedBox(height: 14),
                            GameGlassCard(
                              padding: EdgeInsets.all(compact ? 14 : 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    environment.npc.descricao,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFFD1FAE5),
                                      fontWeight: FontWeight.w700,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  GameButton(
                                    label: 'Continuar',
                                    icon: Icons.arrow_forward,
                                    compact: compact,
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute<void>(
                                          builder: (_) => StageCompleteScreen(
                                            environment: environment,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
      ),
    );
  }
}

class _NpcCinematicHeader extends StatelessWidget {
  const _NpcCinematicHeader({required this.stage, required this.location});

  final int stage;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF052E16).withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF4ADE80).withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.movie_filter_outlined,
            color: Color(0xFF86EFAC),
            size: 18,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Cena $stage • $location',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFD1FAE5),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NpcHeroScene extends StatelessWidget {
  const _NpcHeroScene({
    required this.imagePath,
    required this.role,
    required this.color,
    required this.name,
    required this.speech,
  });

  final String imagePath;
  final String role;
  final Color color;
  final String name;
  final String speech;

  @override
  Widget build(BuildContext context) {
    return GameGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.3),
                    const Color(0xFF0F172A),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: color.withValues(alpha: 0.52)),
              ),
              child: Text(
                role,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _SpeechBubble(text: speech),
        ],
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF02140B).withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF86EFAC).withValues(alpha: 0.38),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💬', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFD1FAE5),
                fontSize: 16,
                height: 1.35,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

({String imagePath, String role, Color color}) _npcPersona(String npcName) {
  final lower = npcName.toLowerCase();
  if (lower.contains('professor marcos')) {
    return (
      imagePath: 'assets/images/characters/professor_marcos.png',
      role: 'PROFESSOR ORIENTADOR',
      color: const Color(0xFF60A5FA),
    );
  }
  if (lower.contains('helena')) {
    return (
      imagePath: 'assets/images/characters/helena.png',
      role: 'GUIA DA SECRETARIA',
      color: const Color(0xFF34D399),
    );
  }
  if (lower.contains('bia')) {
    return (
      imagePath: 'assets/images/characters/bia.png',
      role: 'VETERANA ALIADA',
      color: const Color(0xFF10B981),
    );
  }
  if (lower.contains('lucas')) {
    return (
      imagePath: 'assets/images/characters/lucas.png',
      role: 'MONITOR DE CAMPO',
      color: const Color(0xFFFBBF24),
    );
  }
  if (lower.contains('ze')) {
    return (
      imagePath: 'assets/images/characters/seu_ze.png',
      role: 'ORIENTADOR DA ENTRADA',
      color: const Color(0xFFF59E0B),
    );
  }
  return (
    imagePath: 'assets/images/characters/tutor_laboratorio.png',
    role: 'TUTOR DO LABORATÓRIO',
    color: const Color(0xFFA78BFA),
  );
}
