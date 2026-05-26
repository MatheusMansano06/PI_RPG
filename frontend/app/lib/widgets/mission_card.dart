import 'package:flutter/material.dart';

import 'game_button.dart';
import 'game_card.dart';
import 'status_badge.dart';

class MissionCard extends StatelessWidget {
  const MissionCard({
    super.key,
    required this.title,
    required this.hint,
    required this.distanceText,
    required this.apiStatusText,
    required this.apiDetailText,
    required this.apiTone,
    required this.gpsStatusText,
    required this.latitude,
    required this.longitude,
    required this.environmentName,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.distanceMeters,
    required this.radiusMeters,
    required this.radiusStatusText,
    required this.verificationStatusText,
    required this.canEnter,
    this.onTraceRoute,
    this.onEnter,
    this.onSimulateArrival,
  });

  final String title;
  final String hint;
  final String distanceText;
  final String apiStatusText;
  final String apiDetailText;
  final StatusBadgeTone apiTone;
  final String gpsStatusText;
  final double? latitude;
  final double? longitude;
  final String environmentName;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final double? distanceMeters;
  final double radiusMeters;
  final String radiusStatusText;
  final String verificationStatusText;
  final bool canEnter;
  final VoidCallback? onTraceRoute;
  final VoidCallback? onEnter;
  final VoidCallback? onSimulateArrival;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final compact = screenSize.width < 520;
    final maxPanelHeight = screenSize.height * (compact ? 0.72 : 0.62);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720, maxHeight: maxPanelHeight),
          child: GameGlassCard(
            padding: EdgeInsets.all(compact ? 14 : 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF5C542,
                          ).withValues(alpha: 0.13),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(
                              0xFFF5C542,
                            ).withValues(alpha: 0.32),
                          ),
                        ),
                        child: const Icon(
                          Icons.flag_outlined,
                          color: Color(0xFFF5C542),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MISSAO ATIVA',
                              style: TextStyle(
                                color: Color(0xFFBAE6FD),
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(
                        label: apiStatusText,
                        icon: _apiIcon(apiTone),
                        tone: apiTone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF020617).withValues(alpha: 0.48),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.18),
                      ),
                    ),
                    child: compact
                        ? Column(
                            children: [
                              _Metric(
                                label: 'Status do GPS',
                                value: gpsStatusText,
                                icon: Icons.gps_fixed,
                              ),
                              const SizedBox(height: 10),
                              _Metric(
                                label: 'Latitude atual',
                                value: _latitudeText,
                                icon: Icons.my_location,
                              ),
                              const SizedBox(height: 10),
                              _Metric(
                                label: 'Longitude atual',
                                value: _longitudeText,
                                icon: Icons.my_location,
                              ),
                              const SizedBox(height: 10),
                              _Metric(
                                label: 'Ambiente atual',
                                value: environmentName,
                                icon: Icons.place,
                              ),
                              const SizedBox(height: 10),
                              _Metric(
                                label: 'Destino',
                                value: _destinationCoordinateText,
                                icon: Icons.flag_outlined,
                              ),
                              const SizedBox(height: 10),
                              _Metric(
                                label: 'Distancia atual',
                                value: _distanceMetersText,
                                icon: Icons.route,
                              ),
                              const SizedBox(height: 10),
                              _Metric(
                                label: 'Raio necessario',
                                value: '${radiusMeters.toStringAsFixed(0)} m',
                                icon: Icons.radio_button_checked,
                              ),
                              const SizedBox(height: 10),
                              _Metric(
                                label: 'Status',
                                value: radiusStatusText,
                                icon: Icons.verified_user_outlined,
                              ),
                              const SizedBox(height: 10),
                              _Metric(
                                label: 'Verificacao',
                                value: verificationStatusText,
                                icon: Icons.fact_check_outlined,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _Metric(
                                      label: 'Status do GPS',
                                      value: gpsStatusText,
                                      icon: Icons.gps_fixed,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _Metric(
                                      label: 'Ambiente atual',
                                      value: environmentName,
                                      icon: Icons.place,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _Metric(
                                      label: 'Latitude atual',
                                      value: _latitudeText,
                                      icon: Icons.my_location,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _Metric(
                                      label: 'Longitude atual',
                                      value: _longitudeText,
                                      icon: Icons.my_location,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _Metric(
                                      label: 'Destino',
                                      value: _destinationCoordinateText,
                                      icon: Icons.flag_outlined,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _Metric(
                                      label: 'Distancia atual',
                                      value: _distanceMetersText,
                                      icon: Icons.route,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _Metric(
                                      label: 'Raio necessario',
                                      value:
                                          '${radiusMeters.toStringAsFixed(0)} m',
                                      icon: Icons.radio_button_checked,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _Metric(
                                      label: 'Status',
                                      value: radiusStatusText,
                                      icon: Icons.verified_user_outlined,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _Metric(
                                label: 'Verificacao',
                                value: verificationStatusText,
                                icon: Icons.fact_check_outlined,
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.auto_stories,
                        color: Color(0xFFF5C542),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          hint,
                          maxLines: compact ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFE0F2FE),
                            height: 1.28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    apiDetailText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (onTraceRoute != null ||
                      onEnter != null ||
                      onSimulateArrival != null) ...[
                    const SizedBox(height: 14),
                    compact
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (onTraceRoute != null)
                                GameButton(
                                  label: 'Tracar rota',
                                  icon: Icons.directions,
                                  compact: true,
                                  variant: GameButtonVariant.secondary,
                                  onPressed: onTraceRoute,
                                ),
                              if (onTraceRoute != null && onEnter != null)
                                const SizedBox(height: 10),
                              if (onEnter != null)
                                GameButton(
                                  label: 'Iniciar fase',
                                  icon: Icons.sports_esports,
                                  compact: true,
                                  onPressed: canEnter ? onEnter : null,
                                ),
                              if (onEnter != null && onSimulateArrival != null)
                                const SizedBox(height: 10),
                              if (onSimulateArrival != null)
                                GameButton(
                                  label: 'Simular chegada',
                                  icon: Icons.near_me,
                                  compact: true,
                                  variant: GameButtonVariant.subtle,
                                  onPressed: onSimulateArrival,
                                ),
                            ],
                          )
                        : Row(
                            children: [
                              if (onTraceRoute != null)
                                Expanded(
                                  flex: 4,
                                  child: GameButton(
                                    label: 'Tracar rota',
                                    icon: Icons.directions,
                                    variant: GameButtonVariant.secondary,
                                    onPressed: onTraceRoute,
                                  ),
                                ),
                              if (onTraceRoute != null && onEnter != null)
                                const SizedBox(width: 10),
                              if (onEnter != null)
                                Expanded(
                                  flex: 5,
                                  child: GameButton(
                                    label: 'Iniciar fase',
                                    icon: Icons.sports_esports,
                                    onPressed: canEnter ? onEnter : null,
                                  ),
                                ),
                              if (onEnter != null && onSimulateArrival != null)
                                const SizedBox(width: 10),
                              if (onSimulateArrival != null)
                                Expanded(
                                  flex: 4,
                                  child: GameButton(
                                    label: 'Simular chegada',
                                    icon: Icons.near_me,
                                    onPressed: onSimulateArrival,
                                    variant: GameButtonVariant.subtle,
                                  ),
                                ),
                            ],
                          ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _apiIcon(StatusBadgeTone tone) {
    return switch (tone) {
      StatusBadgeTone.success => Icons.cloud_done,
      StatusBadgeTone.warning => Icons.sync,
      StatusBadgeTone.error => Icons.cloud_off,
      StatusBadgeTone.neutral => Icons.cloud_queue,
    };
  }

  String get _latitudeText {
    if (latitude == null || longitude == null) {
      return 'Aguardando GPS';
    }
    return latitude!.toStringAsFixed(6);
  }

  String get _longitudeText {
    if (latitude == null || longitude == null) {
      return 'Aguardando GPS';
    }
    return longitude!.toStringAsFixed(6);
  }

  String get _destinationCoordinateText {
    if (destinationLatitude == null || destinationLongitude == null) {
      return '--';
    }
    return '${destinationLatitude!.toStringAsFixed(6)}, ${destinationLongitude!.toStringAsFixed(6)}';
  }

  String get _distanceMetersText {
    if (distanceMeters == null) {
      return distanceText;
    }
    return '${distanceMeters!.toStringAsFixed(1)} m';
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFBAE6FD), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
