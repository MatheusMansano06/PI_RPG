import 'package:flutter/material.dart';

import '../widgets/game_background.dart';
import '../widgets/game_button.dart';
import '../widgets/game_card.dart';
import '../widgets/game_hud_badge.dart';
import '../widgets/game_section_title.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 420;

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/start_campus.png',
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 16 : 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: GameGlassCard(
                  padding: EdgeInsets.all(compact ? 18 : 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GameSectionTitle(
                        eyebrow: 'SISTEMA',
                        title: 'Configuracoes',
                        subtitle:
                            'Preferencias visuais e de jornada entram aqui nas proximas etapas.',
                        icon: Icons.tune,
                        compact: compact,
                      ),
                      const SizedBox(height: 18),
                      const Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          GameHudBadge(
                            icon: Icons.map_outlined,
                            label: 'Mapa ativo',
                          ),
                          GameHudBadge(
                            icon: Icons.gps_fixed,
                            label: 'Geolocalizacao',
                          ),
                          GameHudBadge(
                            icon: Icons.cloud_queue,
                            label: 'API futura',
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const _SettingLine(
                        icon: Icons.volume_up_outlined,
                        title: 'Audio narrativo',
                        value: 'Em breve',
                      ),
                      const _SettingLine(
                        icon: Icons.contrast,
                        title: 'Modo cinematografico',
                        value: 'Ativo',
                      ),
                      const _SettingLine(
                        icon: Icons.route,
                        title: 'Dicas de exploracao',
                        value: 'Ativas',
                      ),
                      const SizedBox(height: 14),
                      GameButton(
                        label: 'Voltar ao Menu',
                        icon: Icons.arrow_back,
                        variant: GameButtonVariant.secondary,
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
}

class _SettingLine extends StatelessWidget {
  const _SettingLine({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF38BDF8).withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF5C542)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFBAE6FD),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
