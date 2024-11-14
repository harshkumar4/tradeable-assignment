import 'package:flame_audio/flame_audio.dart';

abstract class GameSound {
  static void playBg() => FlameAudio.bgm.play('bg-music.mp3', volume: .2);
  static void onTap() => FlameAudio.play('on-tap.wav');
  static void onGameWon() => FlameAudio.play('victory.wav');
}
