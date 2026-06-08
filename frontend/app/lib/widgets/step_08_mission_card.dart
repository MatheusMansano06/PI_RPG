import 'package:flutter/material.dart';

import 'step_04_game_button.dart';
import 'step_02_game_card.dart';
import 'step_09_status_badge.dart';

// Card que aparece embaixo da tela do mapa.
// Ele mostra a missao atual, distancia, GPS e botoes para rota/entrada da fase.
class MissionCard extends StatefulWidget {
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

  // Nome e dica da missao atual.
  final String title;
  final String hint;
  final String distanceText;

  // Textos de status vindos da verificacao com backend/local.
  final String apiStatusText;
  final String apiDetailText;
  final StatusBadgeTone apiTone;

  // Dados do GPS atual do jogador.
  final String gpsStatusText;
  final double? latitude;
  final double? longitude;

  // Dados do destino da missao.
  final String environmentName;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final double? distanceMeters;
  final double radiusMeters;
  final String radiusStatusText;
  final String verificationStatusText;

  // Se for true, o botao de entrar na missao fica liberado.
  final bool canEnter;

  // Funcoes recebidas da tela do mapa.
  final VoidCallback? onTraceRoute;
  final VoidCallback? onEnter;
  final VoidCallback? onSimulateArrival;

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  // O usuario pode recolher o painel para enxergar melhor o mapa.
  bool _isMinimized = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    // compact deixa o painel menor em tela pequena.
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
                      // Icone amarelo para indicar que essa area fala da missao.
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
                              widget.title,
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
                        label: widget.apiStatusText,
                        icon: _apiIcon(widget.apiTone),
                        tone: widget.apiTone,
                      ),
                      IconButton(
                        icon: Icon(
                          _isMinimized
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: const Color(0xFFBAE6FD),
                        ),
                        onPressed: () {
                          // Abre ou fecha os detalhes do painel.
                          setState(() {
                            _isMinimized = !_isMinimized;
                          });
                        },
                      ),
                    ],
                  ),
                  if (!_isMinimized) ...[
                    const SizedBox(height: 14),
                    // Bloco com as informacoes tecnicas do GPS.
                    // Deixamos visivel para a banca entender como a fase libera.
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF020617).withValues(alpha: 0.48),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(
                            0xFF38BDF8,
                          ).withValues(alpha: 0.18),
                        ),
                      ),
                      child: compact
                          // Layout vertical para celular pequeno.
                          ? Column(
                              children: [
                                _Metric(
                                  label: 'Status do GPS',
                                  value: widget.gpsStatusText,
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
                                  value: widget.environmentName,
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
                                  value:
                                      '${widget.radiusMeters.toStringAsFixed(0)} m',
                                  icon: Icons.radio_button_checked,
                                ),
                                const SizedBox(height: 10),
                                _Metric(
                                  label: 'Status',
                                  value: widget.radiusStatusText,
                                  icon: Icons.verified_user_outlined,
                                ),
                                const SizedBox(height: 10),
                                _Metric(
                                  label: 'Verificacao',
                                  value: widget.verificationStatusText,
                                  icon: Icons.fact_check_outlined,
                                ),
                              ],
                            )
                          : Column(
                              // Layout em duas colunas para telas maiores.
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _Metric(
                                        label: 'Status do GPS',
                                        value: widget.gpsStatusText,
                                        icon: Icons.gps_fixed,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _Metric(
                                        label: 'Ambiente atual',
                                        value: widget.environmentName,
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
                                            '${widget.radiusMeters.toStringAsFixed(0)} m',
                                        icon: Icons.radio_button_checked,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _Metric(
                                        label: 'Status',
                                        value: widget.radiusStatusText,
                                        icon: Icons.verified_user_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _Metric(
                                  label: 'Verificacao',
                                  value: widget.verificationStatusText,
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
                            widget.hint,
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
                      widget.apiDetailText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.onTraceRoute != null ||
                        widget.onEnter != null ||
                        widget.onSimulateArrival != null) ...[
                      const SizedBox(height: 14),
                      compact
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (widget.onTraceRoute != null)
                                  GameButton(
                                    label: 'Tracar rota',
                                    icon: Icons.directions,
                                    compact: true,
                                    variant: GameButtonVariant.secondary,
                                    onPressed: widget.onTraceRoute,
                                  ),
                                if (widget.onTraceRoute != null &&
                                    widget.onEnter != null)
                                  const SizedBox(height: 10),
                                if (widget.onEnter != null)
                                  GameButton(
                                    label: 'Iniciar fase',
                                    icon: Icons.sports_esports,
                                    compact: true,
                                    onPressed: widget.canEnter
                                        ? widget.onEnter
                                        : null,
                                  ),
                                if (widget.onEnter != null &&
                                    widget.onSimulateArrival != null)
                                  const SizedBox(height: 10),
                                if (widget.onSimulateArrival != null)
                                  GameButton(
                                    label: 'Simular chegada',
                                    icon: Icons.near_me,
                                    compact: true,
                                    variant: GameButtonVariant.subtle,
                                    onPressed: widget.onSimulateArrival,
                                  ),
                              ],
                            )
                          : Row(
                              children: [
                                if (widget.onTraceRoute != null)
                                  Expanded(
                                    flex: 4,
                                    child: GameButton(
                                      label: 'Tracar rota',
                                      icon: Icons.directions,
                                      variant: GameButtonVariant.secondary,
                                      onPressed: widget.onTraceRoute,
                                    ),
                                  ),
                                if (widget.onTraceRoute != null &&
                                    widget.onEnter != null)
                                  const SizedBox(width: 10),
                                if (widget.onEnter != null)
                                  Expanded(
                                    flex: 5,
                                    child: GameButton(
                                      label: 'Iniciar fase',
                                      icon: Icons.sports_esports,
                                      onPressed: widget.canEnter
                                          ? widget.onEnter
                                          : null,
                                    ),
                                  ),
                                if (widget.onEnter != null &&
                                    widget.onSimulateArrival != null)
                                  const SizedBox(width: 10),
                                if (widget.onSimulateArrival != null)
                                  Expanded(
                                    flex: 4,
                                    child: GameButton(
                                      label: 'Simular chegada',
                                      icon: Icons.near_me,
                                      onPressed: widget.onSimulateArrival,
                                      variant: GameButtonVariant.subtle,
                                    ),
                                  ),
                              ],
                            ),
                    ],
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
    // Escolhe o icone conforme o status da API.
    if (tone == StatusBadgeTone.success) {
      return Icons.cloud_done;
    }

    if (tone == StatusBadgeTone.warning) {
      return Icons.sync;
    }

    if (tone == StatusBadgeTone.error) {
      return Icons.cloud_off;
    }

    return Icons.cloud_queue;
  }

  String get _latitudeText {
    // Enquanto nao tiver GPS, nao mostramos numero falso.
    if (widget.latitude == null || widget.longitude == null) {
      return 'Aguardando GPS';
    }
    return widget.latitude!.toStringAsFixed(6);
  }

  String get _longitudeText {
    if (widget.latitude == null || widget.longitude == null) {
      return 'Aguardando GPS';
    }
    return widget.longitude!.toStringAsFixed(6);
  }

  String get _destinationCoordinateText {
    // Destino vem da fase atual cadastrada no roteiro.
    if (widget.destinationLatitude == null ||
        widget.destinationLongitude == null) {
      return '--';
    }
    return '${widget.destinationLatitude!.toStringAsFixed(6)}, ${widget.destinationLongitude!.toStringAsFixed(6)}';
  }

  String get _distanceMetersText {
    // Mostra a distancia com uma casa decimal para ficar facil de conferir.
    if (widget.distanceMeters == null) {
      return widget.distanceText;
    }
    return '${widget.distanceMeters!.toStringAsFixed(1)} m';
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    // Pequena linha com icone, label e valor.
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
