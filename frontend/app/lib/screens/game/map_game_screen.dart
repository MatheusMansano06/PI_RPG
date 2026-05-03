import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/ambiente_model.dart';
import '../../services/ambiente_service.dart';
import '../../services/location_check_service.dart';
import '../../services/localizacao_service.dart';
import '../../widgets/mission_panel.dart';
import '../../widgets/player_avatar.dart';

class MapGameScreen extends StatefulWidget {
  const MapGameScreen({super.key});

  @override
  State<MapGameScreen> createState() => _MapGameScreenState();
}

class _MapGameScreenState extends State<MapGameScreen> {
  static const LatLng _campusI = LatLng(-22.8337, -47.0525);

  final AmbienteService _ambienteService = AmbienteService();
  final LocationCheckService _locationCheckService = LocationCheckService();
  final LocalizacaoService _localizacaoService = LocalizacaoService();

  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionSubscription;
  List<AmbienteModel> _ambientes = const [];
  Position? _currentPosition;
  String _statusConexao = 'Iniciando GPS...';
  String _resultadoApi = 'Aguardando localizacao';
  bool _checkingLocation = false;

  @override
  void initState() {
    super.initState();
    _carregarAmbientes();
    _iniciarLocalizacao();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _carregarAmbientes() async {
    try {
      final ambientes = await _ambienteService.buscarAmbientes();
      if (!mounted) {
        return;
      }
      setState(() {
        _ambientes = ambientes;
        _statusConexao = 'API online (${ambientes.length} ambientes)';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _statusConexao = 'Falha ao buscar ambientes';
        _resultadoApi = error.toString();
      });
    }
  }

  Future<void> _iniciarLocalizacao() async {
    final permitido = await _localizacaoService.pedirPermissao();
    if (!mounted) {
      return;
    }

    if (!permitido) {
      setState(() {
        _statusConexao = 'Permissao de GPS negada ou servico desligado';
      });
      return;
    }

    setState(() {
      _statusConexao = 'GPS ativo';
    });

    try {
      final position = await _localizacaoService.posicaoAtual();
      _atualizarPosicao(position);
    } catch (error) {
      if (mounted) {
        setState(() {
          _resultadoApi = 'GPS inicial indisponivel: $error';
        });
      }
    }

    _positionSubscription = _localizacaoService
        .acompanharPosicao()
        .listen(_atualizarPosicao, onError: _tratarErroLocalizacao);
  }

  void _atualizarPosicao(Position position) {
    if (!mounted) {
      return;
    }

    setState(() {
      _currentPosition = position;
    });

    final target = LatLng(position.latitude, position.longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLng(target));
    _verificarLocalizacao(position);
  }

  void _tratarErroLocalizacao(Object error) {
    if (!mounted) {
      return;
    }
    setState(() {
      _statusConexao = 'Erro no GPS';
      _resultadoApi = error.toString();
    });
  }

  Future<void> _verificarLocalizacao(Position position) async {
    if (_checkingLocation) {
      return;
    }

    _checkingLocation = true;
    try {
      final result = await _locationCheckService.verificarLocalizacao(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _statusConexao = 'API online';
        _resultadoApi = jsonEncode(result);
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _statusConexao = 'Falha no check de localizacao';
        _resultadoApi = error.toString();
      });
    } finally {
      _checkingLocation = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLatLng = _currentPosition == null
        ? _campusI
        : LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _campusI,
              zoom: 17,
            ),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: _buildAmbienteMarkers(),
            onMapCreated: (controller) {
              _mapController = controller;
              controller.moveCamera(CameraUpdate.newLatLng(currentLatLng));
            },
          ),
          const PlayerAvatar(),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              bottom: false,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xDD0F172A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'RPG Interativo Campus I',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MissionPanel(
              missaoAtual: _missaoAtual,
              statusConexao: _statusConexao,
              latitude: _currentPosition?.latitude,
              longitude: _currentPosition?.longitude,
              resultadoApi: _resultadoApi,
            ),
          ),
        ],
      ),
    );
  }

  String get _missaoAtual {
    if (_ambientes.isEmpty) {
      return 'Missao atual: carregar ambientes do Campus I';
    }

    final sorted = [..._ambientes]..sort((a, b) => a.ordem.compareTo(b.ordem));
    return 'Missao atual: ${sorted.first.nome}';
  }

  Set<Marker> _buildAmbienteMarkers() {
    return _ambientes
        .where((ambiente) => ambiente.latitude != null && ambiente.longitude != null)
        .map(
          (ambiente) => Marker(
            markerId: MarkerId('ambiente-${ambiente.id}'),
            position: LatLng(ambiente.latitude!, ambiente.longitude!),
            infoWindow: InfoWindow(
              title: ambiente.nome,
              snippet: ambiente.descricao,
            ),
          ),
        )
        .toSet();
  }
}
