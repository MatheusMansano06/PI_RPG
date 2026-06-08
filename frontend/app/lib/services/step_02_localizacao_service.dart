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
    // Mensagem que aparece no painel do mapa.
    if (status == LocalizacaoPermissaoStatus.permitido) {
      return 'GPS ativo';
    }

    if (status == LocalizacaoPermissaoStatus.servicoDesligado) {
      return 'GPS desligado. Ative a localizacao do celular para jogar em campo.';
    }

    if (status == LocalizacaoPermissaoStatus.negado) {
      return 'Permissão de localização negada. O mapa continua aberto, mas a missão fica bloqueada.';
    }

    return 'Permissão de localização bloqueada. Libere a permissão nas configurações do Android.';
  }
}

class LocalizacaoService {
  Future<bool> pedirPermissao() async {
    final resultado = await pedirPermissaoDetalhada();
    return resultado.permitido;
  }

  Future<LocalizacaoPermissaoResultado> pedirPermissaoDetalhada() async {
    // Primeiro vemos se o GPS do celular esta ligado.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocalizacaoPermissaoResultado(
        LocalizacaoPermissaoStatus.servicoDesligado,
      );
    }

    // Depois vemos se o usuario deixou o app usar localizacao.
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
    // Esse stream fica mandando novas posicoes enquanto o aluno anda pelo campus.
    final settings = _locationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 3,
    );

    return Geolocator.getPositionStream(locationSettings: settings);
  }

  Future<Position> posicaoAtual() {
    // Pega uma posicao so, usado quando a tela do mapa abre.
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
    // Android e iOS usam classes diferentes do pacote Geolocator.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        intervalDuration: const Duration(seconds: 1),
      );
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
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
