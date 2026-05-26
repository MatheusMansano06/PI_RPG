import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

enum LocalizacaoPermissaoStatus {
  permitido,
  servicoDesligado,
  negado,
  negadoParaSempre,
}

class LocalizacaoPermissaoResultado {
  const LocalizacaoPermissaoResultado(this.status);

  final LocalizacaoPermissaoStatus status;

  bool get permitido => status == LocalizacaoPermissaoStatus.permitido;

  String get mensagem {
    return switch (status) {
      LocalizacaoPermissaoStatus.permitido => 'GPS ativo',
      LocalizacaoPermissaoStatus.servicoDesligado =>
        'GPS desligado. Ative a localizacao do celular para jogar em campo.',
      LocalizacaoPermissaoStatus.negado =>
        'Permissao de localizacao negada. O mapa continua aberto, mas a missao fica bloqueada.',
      LocalizacaoPermissaoStatus.negadoParaSempre =>
        'Permissao de localizacao bloqueada. Libere a permissao nas configuracoes do Android.',
    };
  }
}

class LocalizacaoService {
  Future<bool> pedirPermissao() async {
    final resultado = await pedirPermissaoDetalhada();
    return resultado.permitido;
  }

  Future<LocalizacaoPermissaoResultado> pedirPermissaoDetalhada() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocalizacaoPermissaoResultado(
        LocalizacaoPermissaoStatus.servicoDesligado,
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocalizacaoPermissaoResultado(
        LocalizacaoPermissaoStatus.negadoParaSempre,
      );
    }

    if (permission == LocationPermission.denied) {
      return const LocalizacaoPermissaoResultado(
        LocalizacaoPermissaoStatus.negado,
      );
    }

    return const LocalizacaoPermissaoResultado(
      LocalizacaoPermissaoStatus.permitido,
    );
  }

  Stream<Position> acompanharPosicao() {
    final settings = _locationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );

    return Geolocator.getPositionStream(locationSettings: settings);
  }

  Future<Position> posicaoAtual() {
    return Geolocator.getCurrentPosition(
      locationSettings: _locationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    );
  }

  LocationSettings _locationSettings({
    required LocationAccuracy accuracy,
    required int distanceFilter,
  }) {
    if (kIsWeb) {
      return WebSettings(accuracy: accuracy, distanceFilter: distanceFilter);
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        intervalDuration: const Duration(seconds: 1),
      );
    }

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return AppleSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        activityType: ActivityType.fitness,
        pauseLocationUpdatesAutomatically: false,
      );
    }

    return LocationSettings(accuracy: accuracy, distanceFilter: distanceFilter);
  }
}
