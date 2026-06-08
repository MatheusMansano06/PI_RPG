import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/config/api_config.dart';
import '../../core/theme/app_theme.dart';
import '../../data/step_01_roteiro_fases.dart';
import '../../models/step_04_game_environment_model.dart';
import '../../services/step_04_game_progress_service.dart';
import '../../services/step_03_location_check_service.dart';
import '../../services/step_02_localizacao_service.dart';
import '../../widgets/step_07_mission_panel.dart';
import 'step_06_stage_intro_screen.dart';

// Tela do mapa.
// Ela controla GPS, marcador da missao atual e entrada nas fases.
class GameMapScreen extends StatefulWidget {
  const GameMapScreen({super.key});

  @override
  State<GameMapScreen> createState() => _GameMapScreenState();
}

class _GameMapScreenState extends State<GameMapScreen> {
  // Centro aproximado do Campus I usado quando ainda nao temos GPS do jogador.
  static const LatLng _campusI = LatLng(-22.8337, -47.0525);

  // Estilo visual do Google Maps para deixar o mapa com cara do jogo.
  static const String _gameMapStyle = '''
[
  {"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},
  {"featureType":"transit","stylers":[{"visibility":"off"}]},
  {"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"color":"#355E3B"}]},
  {"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#74C476"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#FFF3B0"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#C9A227"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#FFD166"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#2D9CDB"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#2E8B57"}]},
  {"featureType":"all","elementType":"labels.text.fill","stylers":[{"saturation":25},{"lightness":-10}]}
]
''';
  static const MethodChannel _mapsChannel = MethodChannel(
    'projeto_integrador_jogo/maps',
  );

  // Services usados nesta tela.
  final GameProgressService _progressService = GameProgressService.instance;
  final LocationCheckService _locationCheckService = LocationCheckService();
  final LocalizacaoService _localizacaoService = LocalizacaoService();

  // Variaveis que guardam o estado atual do mapa e do GPS.
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionSubscription;
  Position? _currentPosition;
  GameEnvironmentModel? _routeEnvironment;
  bool? _mapsApiKeyConfigured;
  bool _hasLocationPermission = false;
  String _mapsConfigMessage = 'Validando configuração do Google Maps...';
  String _statusGps = 'Iniciando GPS...';
  String _statusVerificacao = 'Verificacao local ativa';
  String _detalheVerificacao =
      'Backend de localizacao desativado para teste em campo.';
  bool _checkingLocation = false;
  static const double _maxUsableAccuracyMeters = 60;
  static const double _positionNoiseThresholdMeters = 2.5;
  static const double _cameraMovementThresholdMeters = 5;
  static const double _routeRefitThresholdMeters = 10;
  LatLng? _lastCameraTarget;
  LatLng? _lastRouteFitPlayer;

  @override
  void initState() {
    super.initState();
    // Primeiro valida se a chave do mapa existe.
    _verificarConfiguracaoMaps();

    // Depois tenta ligar o GPS do jogador.
    _iniciarLocalizacao();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _verificarConfiguracaoMaps() async {
    try {
      // Esse canal chama codigo nativo do Android/iOS para ver se a chave foi configurada.
      final configured = await _mapsChannel.invokeMethod<bool>(
        'isMapsApiKeyConfigured',
      );
      if (!mounted) {
        return;
      }
      final keyMessage = defaultTargetPlatform == TargetPlatform.iOS
          ? 'Chave iOS ausente ou inválida. Configure GOOGLE_MAPS_API_KEY em ios/Flutter/GoogleMapsKeys.xcconfig e habilite Maps SDK for iOS no Google Cloud.'
          : 'Chave do Google Maps ausente. Configure MAPS_API_KEY em android/local.properties.';
      setState(() {
        _mapsApiKeyConfigured = configured ?? false;
        _mapsConfigMessage = _mapsApiKeyConfigured == true
            ? 'Google Maps configurado.'
            : keyMessage;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      final platformMessage = defaultTargetPlatform == TargetPlatform.iOS
          ? 'Não foi possível validar a chave do Google Maps no iOS.'
          : 'Não foi possível validar a chave do Google Maps no Android.';
      setState(() {
        _mapsApiKeyConfigured = false;
        _mapsConfigMessage = platformMessage;
      });
    }
  }

  Future<void> _iniciarLocalizacao() async {
    // Pede permissao antes de tentar ler o GPS.
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
  }

  void _atualizarPosicao(Position position) {
    // Essa funcao roda sempre que o GPS manda uma posicao nova.
    if (!mounted) {
      return;
    }

    final filteredPosition = _filteredPosition(position);
    if (filteredPosition == null) {
      // Se a precisao estiver ruim, nao usamos essa leitura.
      setState(() {
        _statusGps =
            'GPS fraco - precisao ${position.accuracy.toStringAsFixed(0)} m';
      });
      return;
    }

    final previousPlayerLatLng = _playerLatLng;

    setState(() {
      // Salva a posicao boa para a tela poder redesenhar o mapa.
      _currentPosition = filteredPosition;
      _statusGps = _gpsStatusText(filteredPosition);
    });

    final target = _knownPlayerLatLng;
    if (target == null) {
      return;
    }
    final movedMeters = previousPlayerLatLng == null
        ? double.infinity
        : _distanceBetween(previousPlayerLatLng, target);
    _updateCameraForPosition(target, filteredPosition, movedMeters);

    // Depois de atualizar o mapa, verificamos se chegou perto da missao.
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
    // Backend pode cair, entao o GPS local continua liberando fase.
    if (!ApiConfig.useBackendLocationCheck) {
      if (mounted) {
        setState(() {
          _statusVerificacao = 'Verificacao local ativa';
          _detalheVerificacao =
              'Distância calculada no celular com Geolocator.distanceBetween.';
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
        _statusVerificacao = 'Backend online; verificação local ativa';
        _detalheVerificacao =
            'API respondeu, mas a liberação usa o raio local do Flutter.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _statusVerificacao = 'Verificação local ativa';
        _detalheVerificacao =
            'Backend offline ou inacessível. O jogo continua usando GPS local.';
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
                zoom: 17.2,
                tilt: 0,
              ),
              myLocationButtonEnabled: _hasLocationPermission,
              myLocationEnabled: _hasLocationPermission,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              style: _gameMapStyle,
              markers: _buildMapMarkers(),
              circles: _buildCurrentEnvironmentCircle(),
              polylines: _buildRoutePolylines(routeEnvironment),
              onMapCreated: (controller) {
                _mapController = controller;
                controller.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: cameraLatLng, zoom: 17.2, tilt: 0),
                  ),
                );
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
                  'Todas as missões foram concluídas.',
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
              onSimularChegada: kDebugMode && currentEnvironment != null
                  ? () => _simularChegada(currentEnvironment)
                  : null,
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

    // Procuramos manualmente para ficar mais facil de entender que um where/first.
    for (final environment in roteiroFases) {
      if (environment.id == currentId) {
        return environment;
      }
    }

    return null;
  }

  String get _topStatusText {
    final done = _progressService.ambientesConcluidos.length;
    final total = roteiroFases.length;
    return 'RPG Interativo Campus I  $done/$total';
  }

  String _missionText(GameEnvironmentModel? environment) {
    if (environment == null) {
      return 'Missão finalizada: Campus I explorado';
    }
    return 'Missão atual: ${environment.nome}';
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
      return 'Permissão de localização indisponível.';
    }
    if (text.contains('disabled') || text.contains('service')) {
      return 'GPS desligado. Ative a localização do celular.';
    }
    return 'GPS indisponível no momento. Aguardando nova leitura.';
  }

  String _gpsStatusText(Position position) {
    final accuracy = position.accuracy;
    if (accuracy <= 10) {
      return 'GPS ativo - precisão ${accuracy.toStringAsFixed(0)} m';
    }
    return 'GPS ativo - baixa precisão ${accuracy.toStringAsFixed(0)} m';
  }

  Position? _filteredPosition(Position position) {
    // Se a precisao do GPS estiver muito ruim, nao atualizamos o jogador.
    if (position.accuracy > _maxUsableAccuracyMeters) {
      return null;
    }

    final previous = _currentPosition;
    if (previous == null) {
      return position;
    }

    // Se o GPS mudou quase nada, mantemos a posicao anterior.
    // Isso evita o boneco ficar tremendo no mapa.
    final distanceFromPrevious = Geolocator.distanceBetween(
      previous.latitude,
      previous.longitude,
      position.latitude,
      position.longitude,
    );

    if (distanceFromPrevious < _positionNoiseThresholdMeters) {
      return previous;
    }

    // Se passou nos testes acima, usamos a posicao nova.
    return position;
  }

  double _distanceToEnvironment(
    LatLng player,
    GameEnvironmentModel environment,
  ) {
    return _distanceBetween(
      player,
      LatLng(environment.latitude, environment.longitude),
    );
  }

  double _distanceBetween(LatLng first, LatLng second) {
    return Geolocator.distanceBetween(
      first.latitude,
      first.longitude,
      second.latitude,
      second.longitude,
    );
  }

  double _currentBearing(double heading) {
    if (!heading.isFinite || heading < 0) {
      return 0;
    }
    return heading % 360;
  }

  Set<Marker> _buildEnvironmentMarkers() {
    // Cria os marcadores de todas as fases do roteiro.
    return roteiroFases.map((environment) {
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
    // Junta os marcadores das fases com o marcador do jogador.
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
                : 'Precisão ${_currentPosition!.accuracy.toStringAsFixed(0)} m',
          ),
        ),
    };
  }

  Set<Circle> _buildCurrentEnvironmentCircle() {
    // Circulo azul mostra o raio que libera a missao.
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
    // Linha roxa simples entre o jogador e o destino.
    final player = _playerLatLng;
    if (environment == null || player == null) {
      return const {};
    }

    return {
      Polyline(
        polylineId: PolylineId('rota-${environment.id}'),
        points: [player, LatLng(environment.latitude, environment.longitude)],
        color: const Color(0xFFB52BFF),
        width: 7,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        patterns: [PatternItem.gap(10), PatternItem.dot],
      ),
    };
  }

  BitmapDescriptor _markerIcon(AmbienteStatus status) {
    if (status == AmbienteStatus.concluido) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }

    if (status == AmbienteStatus.atual) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }

    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
  }

  String _markerSnippet(AmbienteStatus status) {
    if (status == AmbienteStatus.concluido) {
      return 'Concluído';
    }

    if (status == AmbienteStatus.atual) {
      return 'Missão atual';
    }

    return 'Bloqueado';
  }

  Future<void> _entrarNaMissao() async {
    // Abre a introducao da fase atual.
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
      // Se a fase terminou, limpamos a rota e o mapa olha para a proxima fase.
      setState(() {
        _routeEnvironment = null;
        _lastRouteFitPlayer = null;
      });
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

  void _simularChegada(GameEnvironmentModel environment) {
    // Atalho de teste usado so em debug pelo painel da missao.
    setState(() {
      _currentPosition = Position(
        latitude: environment.latitude,
        longitude: environment.longitude,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
      _statusGps = 'Localização simulada para teste';
      _statusVerificacao = 'Simulação ativa';
      _detalheVerificacao =
          'Chegada simulada no destino. Agora toque em Iniciar fase.';
    });
  }

  void _tracarRotaNoMapa(GameEnvironmentModel environment) {
    // Cria uma rota visual simples, sem chamar API de rotas.
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
      _lastRouteFitPlayer = player;
    });

    _fitRouteOnMap(player, destination);
  }

  void _updateCameraForPosition(
    LatLng target,
    Position position,
    double movedMeters,
  ) {
    // Move a camera quando o jogador anda.
    // Se estiver com rota aberta, tenta mostrar jogador e destino juntos.
    final routeEnvironment = _routeEnvironment;
    if (routeEnvironment != null) {
      final lastRouteFitPlayer = _lastRouteFitPlayer;
      if (lastRouteFitPlayer == null ||
          _distanceBetween(lastRouteFitPlayer, target) >=
              _routeRefitThresholdMeters) {
        _lastRouteFitPlayer = target;
        _fitRouteOnMap(
          target,
          LatLng(routeEnvironment.latitude, routeEnvironment.longitude),
        );
      }
      return;
    }

    final lastCameraTarget = _lastCameraTarget;
    if (lastCameraTarget != null &&
        movedMeters < _cameraMovementThresholdMeters &&
        _distanceBetween(lastCameraTarget, target) <
            _cameraMovementThresholdMeters) {
      return;
    }

    _lastCameraTarget = target;
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: 18.2,
          tilt: 0,
          bearing: _currentBearing(position.heading),
        ),
      ),
    );
  }

  void _fitRouteOnMap(LatLng player, LatLng destination) {
    // Ajusta o zoom para caber o jogador e o destino na tela.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(_boundsFor(player, destination), 96),
      );
    });
  }

  LatLngBounds _boundsFor(LatLng first, LatLng second) {
    // Calcula o retangulo usado pelo Google Maps para ajustar a camera.
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
