import 'package:audioplayers/audioplayers.dart';

class CinematicAudioService {
  CinematicAudioService._();

  static final CinematicAudioService instance = CinematicAudioService._();
  final AudioPlayer _player = AudioPlayer();

  Future<void> playCloudTransition() async {
    try {
      await _player.stop();
      await _player.setVolume(0.65);
      await _player.play(AssetSource('audio/cloud_whoosh.wav'));
    } catch (_) {
      // Nao bloqueia fluxo se audio falhar em plataforma especifica.
    }
  }
}
