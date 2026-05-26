import 'package:flutter/material.dart';

import 'mission_card.dart';
import 'status_badge.dart';

class MissionPanel extends StatelessWidget {
  const MissionPanel({
    super.key,
    required this.missaoAtual,
    required this.dicaNarrativa,
    required this.distanciaTexto,
    required this.statusGps,
    required this.latitude,
    required this.longitude,
    required this.ambienteAtual,
    required this.destinoLatitude,
    required this.destinoLongitude,
    required this.distanciaMetros,
    required this.raioMetros,
    required this.statusRaio,
    required this.statusVerificacao,
    required this.detalheVerificacao,
    required this.podeEntrarNaMissao,
    this.onTracarRota,
    this.onEntrarMissao,
    this.onSimularChegada,
  });

  final String missaoAtual;
  final String dicaNarrativa;
  final String distanciaTexto;
  final String statusGps;
  final double? latitude;
  final double? longitude;
  final String ambienteAtual;
  final double? destinoLatitude;
  final double? destinoLongitude;
  final double? distanciaMetros;
  final double raioMetros;
  final String statusRaio;
  final String statusVerificacao;
  final String detalheVerificacao;
  final bool podeEntrarNaMissao;
  final VoidCallback? onTracarRota;
  final VoidCallback? onEntrarMissao;
  final VoidCallback? onSimularChegada;

  @override
  Widget build(BuildContext context) {
    return MissionCard(
      title: missaoAtual.replaceFirst('Missao atual: ', ''),
      hint: dicaNarrativa,
      distanceText: distanciaTexto,
      apiStatusText: _gpsStatusText,
      apiDetailText: detalheVerificacao,
      apiTone: _gpsTone,
      gpsStatusText: statusGps,
      latitude: latitude,
      longitude: longitude,
      environmentName: ambienteAtual,
      destinationLatitude: destinoLatitude,
      destinationLongitude: destinoLongitude,
      distanceMeters: distanciaMetros,
      radiusMeters: raioMetros,
      radiusStatusText: statusRaio,
      verificationStatusText: statusVerificacao,
      canEnter: podeEntrarNaMissao,
      onTraceRoute: onTracarRota,
      onEnter: onEntrarMissao,
      onSimulateArrival: onSimularChegada,
    );
  }

  String get _gpsStatusText {
    final normalized = statusGps.toLowerCase();
    if (normalized.contains('ativo')) {
      return 'GPS ok';
    }
    if (normalized.contains('simulada')) {
      return 'Debug';
    }
    if (normalized.contains('iniciando') || normalized.contains('aguardando')) {
      return 'GPS';
    }
    return 'GPS off';
  }

  StatusBadgeTone get _gpsTone {
    final normalized = statusGps.toLowerCase();
    if (normalized.contains('ativo')) {
      return StatusBadgeTone.success;
    }
    if (normalized.contains('simulada') ||
        normalized.contains('iniciando') ||
        normalized.contains('aguardando')) {
      return StatusBadgeTone.warning;
    }
    return StatusBadgeTone.error;
  }
}
