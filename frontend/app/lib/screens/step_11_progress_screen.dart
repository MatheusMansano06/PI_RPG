import 'package:flutter/material.dart';

import '../data/step_01_roteiro_fases.dart';
import '../services/step_04_game_progress_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = GameProgressService.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text('Progresso'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Jornada do Campus I',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Veja quais fases ja foram liberadas e concluidas.',
              style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 15),
            ),
            const SizedBox(height: 18),
            for (final environment in roteiroFases)
              _ProgressLine(
                stage: environment.stageNumber,
                title: environment.nome,
                subtitle: environment.missionTitle,
                done: progress.ambientesConcluidos.contains(environment.id),
                current: progress.ambienteAtualId == environment.id,
              ),
          ],
        ),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.stage,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.current,
  });

  final int stage;
  final String title;
  final String subtitle;
  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final color = done
        ? const Color(0xFF22C55E)
        : current
        ? const Color(0xFFF5C542)
        : const Color(0xFF94A3B8);
    final status = done
        ? 'Concluida'
        : current
        ? 'Atual'
        : 'Bloqueada';
    final icon = done
        ? Icons.check_circle
        : current
        ? Icons.flag
        : Icons.lock;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fase $stage - $title',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
