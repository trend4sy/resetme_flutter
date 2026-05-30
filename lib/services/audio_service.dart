import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioPlayer? _player;
  bool _isPlaying = false;
  double _volume = 0.5;
  String? _currentAsset;

  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  String? get currentAsset => _currentAsset;

  Future<void> playSound(String assetPath, {bool loop = true}) async {
    await stop();
    _player = AudioPlayer();
    _currentAsset = assetPath;
    if (loop) {
      _player?.setReleaseMode(ReleaseMode.loop);
    }
    await _player?.setVolume(_volume);
    await _player?.play(AssetSource(assetPath));
    _isPlaying = true;
  }

  Future<void> stop() async {
    await _player?.stop();
    await _player?.dispose();
    _player = null;
    _isPlaying = false;
    _currentAsset = null;
  }

  Future<void> setVolume(double vol) async {
    _volume = vol.clamp(0.0, 1.0);
    await _player?.setVolume(_volume);
  }

  Future<void> pause() async {
    await _player?.pause();
    _isPlaying = false;
  }

  Future<void> resume() async {
    await _player?.resume();
    _isPlaying = true;
  }

  void dispose() {
    stop();
  }
}
