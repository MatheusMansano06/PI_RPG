import 'package:flutter/material.dart';

class MissionPanel extends StatelessWidget {
  const MissionPanel({
    super.key,
    required this.missaoAtual,
    required this.statusConexao,
    required this.latitude,
    required this.longitude,
    required this.resultadoApi,
  });

  final String missaoAtual;
  final String statusConexao;
  final double? latitude;
  final double? longitude;
  final String resultadoApi;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: const BoxDecoration(
          color: Color(0xF2FFFFFF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              missaoAtual,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            _InfoRow(label: 'Conexao', value: statusConexao),
            _InfoRow(label: 'Latitude', value: _formatCoordinate(latitude)),
            _InfoRow(label: 'Longitude', value: _formatCoordinate(longitude)),
            _InfoRow(label: 'API', value: resultadoApi),
          ],
        ),
      ),
    );
  }

  String _formatCoordinate(double? value) {
    if (value == null) {
      return '--';
    }
    return value.toStringAsFixed(6);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }
}
