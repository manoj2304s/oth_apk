import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class BackgroundMusicService extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var volume = 0.5.obs;

  Future<void> playBackgroundMusic() async {
    try {
      await _audioPlayer.setSource(AssetSource('audio/background_story.mp3'));
      await _audioPlayer.setVolume(volume.value);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
      await _audioPlayer.resume();
      isPlaying.value = true;
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  Future<void> pauseBackgroundMusic() async {
    try {
      await _audioPlayer.pause();
      isPlaying.value = false;
    } catch (e) {
      print('Error pausing background music: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _audioPlayer.stop();
      isPlaying.value = false;
    } catch (e) {
      print('Error stopping background music: $e');
    }
  }

  Future<void> setVolume(double value) async {
    try {
      await _audioPlayer.setVolume(value);
      volume.value = value;
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}