import 'package:geolocator/geolocator.dart';

class LocalizacaoService {
  Future<bool> pedirPermissao() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Stream<Position> acompanharPosicao() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 3,
    );

    return Geolocator.getPositionStream(locationSettings: settings);
  }

  Future<Position> posicaoAtual() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
