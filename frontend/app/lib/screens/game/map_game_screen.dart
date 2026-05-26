import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/config/api_config.dart';
import '../../core/theme/app_theme.dart';
import '../../data/story_mock.dart';
import '../../models/game_environment_model.dart';
import '../../services/game_progress_service.dart';
import '../../services/location_check_service.dart';
import '../../services/localizacao_service.dart';
import '../../widgets/mission_panel.dart';
import 'stage_intro_screen.dart';

class GameMapScreen extends StatefulWidget {
  const GameMapScreen({super.key});

  @override
  State<GameMapScreen> createState() => _GameMapScreenState();
}

class _GameMapScreenState extends State<GameMapScreen> {
  static const LatLng _campusI = LatLng(-22.8337, -47.0525);
  static const MethodChannel _mapsChannel = MethodChannel(
    'projeto_integrador_jogo/maps',
  );

  final GameProgressService _progressService = GameProgressService.instance;
  final LocationCheckService _locationCheckService = LocationCheckService();
  final LocalizacaoService _localizacaoService = LocalizacaoService();

  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _locationRefreshTimer;
  Position? _currentPosition;
  GameEnvironmentModel? _routeEnvironment;
  bool _hasCenteredOnGps = false;
  bool? _mapsApiKeyConfigured;
  bool _hasLocationPermission = false;
  String _mapsConfigMessage = 'Validando configuracao do Google Maps...';
  String _statusGps = 'Iniciando GPS...';
  String _statusVerificacao = 'Verificacao local ativa';
  String _detalheVerificacao =
      'Backend de localizacao desativado para teste em campo.';
  bool _checkingLocation = false;
  bool _refreshingLocation = false;
  static const double _maxUsableAccuracyMeters = 60;

  @override
  void initState() {
    super.initState();
    _verificarConfiguracaoMaps();
    _iniciarLocalizacao();
  }

  @override
  void dispose() {
    _locationRefreshTimer?.cancel();
    _positionSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _verificarConfiguracaoMaps() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      if (mounted) {
        setState(() {
          _mapsApiKeyConfigured = true;
        });
      }
      return;
    }

    try {
      final configured = await _mapsChannel.invokeMethod<bool>(
        'isMapsApiKeyConfigured',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _mapsApiKeyConfigured = configured ?? false;
        _mapsConfigMessage = _mapsApiKeyConfigured == true
            ? 'Google Maps configurado'
            : 'Chave do Google Maps ausente. Configure MAPS_API_KEY em android/local.properties.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _mapsApiKeyConfigured = false;
        _mapsConfigMessage =
            'Nao foi possivel validar a chave do Google Maps no Android.';
      });
    }
  }

  Future<void> _iniciarLocalizacao() async {
    final resultado = await _localizacaoService.pedirPermissaoDetalhada();
    if (!mounted) {
      return;
    }

    if (!resultado.permitido) {
      setState(() {
        _hasLocationPermission = false;
        _statusGps = resultado.mensagem;
        _statusVerificacao = 'Verificacao local ativa';
      });
      return;
    }

    setState(() {
      _hasLocationPermission = true;
      _statusGps = resultado.mensagem;
      _statusVerificacao = 'Verificacao local ativa';
    });

    try {
      final position = await _localizacaoService.posicaoAtual();
      _atualizarPosicao(position);
    } catch (_) {
      if (mounted) {
        setState(() {
          _statusGps =
              'Aguardando primeira posicao do GPS. Tente ficar em area aberta.';
        });
      }
    }

    _positionSubscription = _localizacaoService.acompanharPosicao().listen(
      _atualizarPosicao,
      onError: _tratarErroLocalizacao,
    );
    _iniciarAtualizacaoPeriodicaDoMapa();
  }

  void _iniciarAtualizacaoPeriodicaDoMapa() {
    _locationRefreshTimer?.cancel();
    _locationRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _atualizarMapaComGpsAtual();
    });
  }

  Future<void> _atualizarMapaComGpsAtual() async {
    if (_refreshingLocation || !mounted || !_hasLocationPermission) {
      return;
    }

    _refreshingLocation = true;
    try {
      final position = await _localizacaoService.posicaoAtual();
      _atualizarPosicao(position);
    } catch (error) {
      _tratarErroLocalizacao(error);
    } finally {
      _refreshingLocation = false;
    }
  }

  void _atualizarPosicao(Position position) {
    if (!mounted) {
      return;
    }

    final filteredPosition = _filteredPosition(position);
    if (filteredPosition == null) {
      setState(() {
        _statusGps =
            'GPS fraco - precisao ${position.accuracy.toStringAsFixed(0)} m';
      });
      return;
    }

    setState(() {
      _currentPosition = filteredPosition;
      _statusGps = _gpsStatusText(filteredPosition);
    });

    final target = _knownPlayerLatLng;
    if (target == null) {
      return;
    }
    final cameraUpdate = _hasCenteredOnGps
        ? CameraUpdate.newLatLng(target)
        : CameraUpdate.newLatLngZoom(target, 18);
    _hasCenteredOnGps = true;
    _mapController?.moveCamera(cameraUpdate);
    _verificarLocalizacao(target);
  }

  void _tratarErroLocalizacao(Object error) {
    if (!mounted) {
      return;
    }
    setState(() {
      _statusGps = _mensagemAmigavelErroGps(error);
    });
  }

  Future<void> _verificarLocalizacao(LatLng position) async {
    if (!ApiConfig.useBackendLocationCheck) {
      if (mounted) {
        setState(() {
          _statusVerificacao = 'Verificacao local ativa';
          _detalheVerificacao =
              'Distancia calculada no celular com Geolocator.distanceBetween.';
        });
      }
      return;
    }

    if (_checkingLocation) {
      return;
    }

    _checkingLocation = true;
    try {
      await _locationCheckService.verificarLocalizacao(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _statusVerificacao = 'Backend online; verificacao local ativa';
        _detalheVerificacao =
            'API respondeu, mas a liberacao usa o raio local do Flutter.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _statusVerificacao = 'Verificacao local ativa';
        _detalheVerificacao =
            'Backend offline ou inacessivel. O jogo continua usando GPS local.';
      });
    } finally {
      _checkingLocation = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEnvironment = _currentEnvironment;
    final playerLatLng = _playerLatLng;
    final cameraLatLng = playerLatLng ?? _campusI;
    final radiusMeters = currentEnvironment?.raioMetros;
    final routeEnvironment =
        currentEnvironment != null &&
            _routeEnvironment?.id == currentEnvironment.id
        ? currentEnvironment
        : null;
    final distance = currentEnvironment == null || playerLatLng == null
        ? null
        : _distanceToEnvironment(playerLatLng, currentEnvironment);
    final insideRadius =
        currentEnvironment != null &&
        radiusMeters != null &&
        distance != null &&
        distance <= radiusMeters;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_mapsApiKeyConfigured == true)
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _campusI,
                zoom: 17,
              ),
              myLocationButtonEnabled: _hasLocationPermission,
              myLocationEnabled: _hasLocationPermission,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              markers: _buildMapMarkers(),
              circles: _buildCurrentEnvironmentCircle(),
              polylines: _buildRoutePolylines(routeEnvironment),
              onMapCreated: (controller) {
                _mapController = controller;
                controller.moveCamera(CameraUpdate.newLatLng(cameraLatLng));
              },
            )
          else
            _MapConfigurationFallback(message: _mapsConfigMessage),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              bottom: false,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xEE0F172A),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFFF5C542).withValues(alpha: 0.32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.explore, color: AppTheme.accent, size: 18),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _topStatusText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MissionPanel(
              missaoAtual: _missionText(currentEnvironment),
              dicaNarrativa:
                  currentEnvironment?.dicaParaProximoLocal ??
                  'Todas as missoes foram concluidas.',
              distanciaTexto: _distanceText(distance, currentEnvironment),
              statusGps: _statusGps,
              latitude: playerLatLng?.latitude,
              longitude: playerLatLng?.longitude,
              ambienteAtual: currentEnvironment?.nome ?? 'Jornada completa',
              destinoLatitude: currentEnvironment?.latitude,
              destinoLongitude: currentEnvironment?.longitude,
              distanciaMetros: distance,
              raioMetros: radiusMeters ?? 12,
              statusRaio: _radiusStatusText(
                distance,
                currentEnvironment,
                radiusMeters,
              ),
              statusVerificacao: _statusVerificacao,
              detalheVerificacao: _detalheVerificacao,
              podeEntrarNaMissao: insideRadius,
              onTracarRota: currentEnvironment == null
                  ? null
                  : () => _tracarRotaNoMapa(currentEnvironment),
              onEntrarMissao: currentEnvironment != null && insideRadius
                  ? _entrarNaMissao
                  : null,
              onSimularChegada: null,
            ),
          ),
        ],
      ),
    );
  }

  LatLng? get _knownPlayerLatLng => _playerLatLng;

  LatLng? get _playerLatLng {
    if (_currentPosition != null) {
      return LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    }
    return null;
  }

  GameEnvironmentModel? get _currentEnvironment {
    final currentId = _progressService.ambienteAtualId;
    if (currentId == null) {
      return null;
    }
    return storyMockEnvironments
        .where((environment) => environment.id == currentId)
        .firstOrNull;
  }

  String get _topStatusText {
    final done = _progressService.ambientesConcluidos.length;
    final total = storyMockEnvironments.length;
    return 'RPG Interativo Campus I  $done/$total';
  }

  String _missionText(GameEnvironmentModel? environment) {
    if (environment == null) {
      return 'Missao finalizada: Campus I explorado';
    }
    return 'Missao atual: ${environment.nome}';
  }

  String _distanceText(double? distance, GameEnvironmentModel? environment) {
    if (environment == null) {
      return 'Jornada completa';
    }
    if (distance == null) {
      return 'Aguardando GPS';
    }
    final radiusMeters = environment.raioMetros;
    if (distance <= radiusMeters) {
      return 'Dentro do raio';
    }
    final remaining = distance - radiusMeters;
    return 'Faltam ${remaining.toStringAsFixed(0)} m';
  }

  String _radiusStatusText(
    double? distance,
    GameEnvironmentModel? environment,
    double? radiusMeters,
  ) {
    if (environment == null) {
      return 'Jornada completa';
    }
    if (distance == null) {
      return 'Aguardando GPS';
    }
    final effectiveRadius = radiusMeters ?? environment.raioMetros;
    return distance <= effectiveRadius ? 'Dentro do raio' : 'Fora do raio';
  }

  String _mensagemAmigavelErroGps(Object error) {
    final text = error.toString().toLowerCase();
    if (text.contains('permission')) {
      return 'Permissao de localizacao indisponivel.';
    }
    if (text.contains('disabled') || text.contains('service')) {
      return 'GPS desligado. Ative a localizacao do celular.';
    }
    return 'GPS indisponivel no momento. Aguardando nova leitura.';
  }

  String _gpsStatusText(Position position) {
    final accuracy = position.accuracy;
    if (accuracy <= 10) {
      return 'GPS ativo - precisao ${accuracy.toStringAsFixed(0)} m';
    }
    return 'GPS ativo - baixa precisao ${accuracy.toStringAsFixed(0)} m';
  }

  Position? _filteredPosition(Position position) {
    final previous = _currentPosition;
    if (previous == null) {
      return position;
    }

    if (position.accuracy > _maxUsableAccuracyMeters) {
      return null;
    }

    final distanceFromPrevious = Geolocator.distanceBetween(
      previous.latitude,
      previous.longitude,
      position.latitude,
      position.longitude,
    );

    if (distanceFromPrevious < 0.5) {
      return previous;
    }

    final alpha = position.accuracy <= 12
        ? 0.85
        : position.accuracy <= 25
        ? 0.65
        : 0.4;

    return Position(
      latitude: _lerp(previous.latitude, position.latitude, alpha),
      longitude: _lerp(previous.longitude, position.longitude, alpha),
      timestamp: position.timestamp,
      accuracy: math.min(previous.accuracy, position.accuracy),
      altitude: position.altitude,
      altitudeAccuracy: position.altitudeAccuracy,
      heading: position.heading,
      headingAccuracy: position.headingAccuracy,
      speed: position.speed,
      speedAccuracy: position.speedAccuracy,
      floor: position.floor,
      isMocked: position.isMocked,
    );
  }

  double _lerp(double start, double end, double alpha) {
    return start + ((end - start) * alpha);
  }

  double _distanceToEnvironment(
    LatLng player,
    GameEnvironmentModel environment,
  ) {
    return Geolocator.distanceBetween(
      player.latitude,
      player.longitude,
      environment.latitude,
      environment.longitude,
    );
  }

  Set<Marker> _buildEnvironmentMarkers() {
    return storyMockEnvironments.map((environment) {
      final status = _progressService.verificarStatusAmbiente(environment.id);
      return Marker(
        markerId: MarkerId(environment.id),
        position: LatLng(environment.latitude, environment.longitude),
        icon: _markerIcon(status),
        infoWindow: InfoWindow(
          title: environment.nome,
          snippet: _markerSnippet(status),
        ),
      );
    }).toSet();
  }

  Set<Marker> _buildMapMarkers() {
    return {
      ..._buildEnvironmentMarkers(),
      if (_playerLatLng != null)
        Marker(
          markerId: const MarkerId('jogador'),
          position: _playerLatLng!,
          zIndexInt: 1000,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(
            title: 'Seu boneco',
            snippet: _currentPosition == null
                ? null
                : 'Precisao ${_currentPosition!.accuracy.toStringAsFixed(0)} m',
          ),
        ),
    };
  }

  Set<Circle> _buildCurrentEnvironmentCircle() {
    final environment = _currentEnvironment;
    if (environment == null) {
      return const {};
    }

    return {
      Circle(
        circleId: CircleId('raio-${environment.id}'),
        center: LatLng(environment.latitude, environment.longitude),
        radius: environment.raioMetros,
        strokeWidth: 2,
        strokeColor: const Color(0xFF1D4ED8),
        fillColor: const Color(0x331D4ED8),
      ),
      if (_playerLatLng != null)
        Circle(
          circleId: const CircleId('jogador-posicao'),
          center: _playerLatLng!,
          radius: 3,
          strokeWidth: 3,
          strokeColor: AppTheme.accent,
          fillColor: AppTheme.primary.withValues(alpha: 0.35),
        ),
    };
  }

  Set<Polyline> _buildRoutePolylines(GameEnvironmentModel? environment) {
    final player = _playerLatLng;
    if (environment == null || player == null) {
      return const {};
    }

    return {
      Polyline(
        polylineId: PolylineId('rota-${environment.id}'),
        points: [player, LatLng(environment.latitude, environment.longitude)],
        color: AppTheme.accent,
        width: 6,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

  BitmapDescriptor _markerIcon(AmbienteStatus status) {
    return switch (status) {
      AmbienteStatus.concluido => BitmapDescriptor.pinConfig(
        backgroundColor: const Color(0xFF16A34A),
        borderColor: Colors.white,
      ),
      AmbienteStatus.atual => BitmapDescriptor.pinConfig(
        backgroundColor: const Color(0xFF2563EB),
        borderColor: Colors.white,
      ),
      AmbienteStatus.bloqueado => BitmapDescriptor.pinConfig(
        backgroundColor: const Color(0xFF64748B),
        borderColor: Colors.white,
      ),
    };
  }

  String _markerSnippet(AmbienteStatus status) {
    return switch (status) {
      AmbienteStatus.concluido => 'Concluido',
      AmbienteStatus.atual => 'Missao atual',
      AmbienteStatus.bloqueado => 'Bloqueado',
    };
  }

  Future<void> _entrarNaMissao() async {
    final environment = _currentEnvironment;
    if (environment == null) {
      return;
    }

    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => StageIntroScreen(environment: environment),
      ),
    );

    if (!mounted) {
      return;
    }

    if (completed == true) {
      final next = _currentEnvironment;
      if (next != null) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(next.latitude, next.longitude), 17),
        );
      }
    } else {
      setState(() {});
    }
  }

  void _tracarRotaNoMapa(GameEnvironmentModel environment) {
    final player = _playerLatLng;
    if (player == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aguardando GPS para tracar a rota.')),
      );
      return;
    }

    final destination = LatLng(environment.latitude, environment.longitude);
    setState(() {
      _routeEnvironment = environment;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(_boundsFor(player, destination), 72),
    );
  }

  LatLngBounds _boundsFor(LatLng first, LatLng second) {
    final southwest = LatLng(
      math.min(first.latitude, second.latitude),
      math.min(first.longitude, second.longitude),
    );
    final northeast = LatLng(
      math.max(first.latitude, second.latitude),
      math.max(first.longitude, second.longitude),
    );

    if (southwest == northeast) {
      return LatLngBounds(
        southwest: LatLng(
          southwest.latitude - 0.0001,
          southwest.longitude - 0.0001,
        ),
        northeast: LatLng(
          northeast.latitude + 0.0001,
          northeast.longitude + 0.0001,
        ),
      );
    }

    return LatLngBounds(southwest: southwest, northeast: northeast);
  }
}

class _MapConfigurationFallback extends StatelessWidget {
  const _MapConfigurationFallback({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final waiting = message.contains('Validando');

    return ColoredBox(
      color: const Color(0xFF020617),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (waiting)
                  const CircularProgressIndicator(color: AppTheme.accent)
                else
                  const Icon(
                    Icons.map_outlined,
                    color: AppTheme.accent,
                    size: 42,
                  ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
