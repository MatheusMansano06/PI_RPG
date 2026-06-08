import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  AudioManager._internal();

  static const String _bgmAsset = 'musicas/musica.mp3';
  static const String _sfxFolder = 'musicas';

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isBgmPlaying = false;
  bool _hasStartedBgm = false;

  Future<void> playBgm() async {
    if (_isBgmPlaying) return;

    try {
      // Musica em loop para acompanhar todas as telas.
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

      if (_hasStartedBgm) {
        await _bgmPlayer.resume();
      } else {
        await _bgmPlayer.play(AssetSource(_bgmAsset));
        _hasStartedBgm = true;
      }

      _isBgmPlaying = true;
    } catch (_) {
      _isBgmPlaying = false;
    }
  }

  Future<void> pauseBgm() async {
    if (!_isBgmPlaying) return;

    await _bgmPlayer.pause();
    _isBgmPlaying = false;
  }

  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
    _isBgmPlaying = false;
    _hasStartedBgm = false;
  }

  Future<void> playSfx(String fileName) async {
    // Usado por botoes e respostas das perguntas.
    await playBgm();
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('$_sfxFolder/$fileName'));
  }

  void playClick() => playSfx('click.mp3');
  void playCorrect() => playSfx('correct.mp3');
  void playWrong() => playSfx('wrong.mp3');

  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
