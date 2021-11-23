import 'package:just_audio/just_audio.dart' as ja;
import 'package:audio_session/audio_session.dart';

class AudioPlayerUtil {
  late AudioSession audioSessions;
  ja.AudioPlayer player = ja.AudioPlayer(
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );

  AudioPlayerUtil() {
    _audioSessionConfigure();
  }

  _audioSessionConfigure() =>
      AudioSession.instance.then((audioSession) async => await audioSession
          .configure(const AudioSessionConfiguration(
            avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
            avAudioSessionCategoryOptions:
                AVAudioSessionCategoryOptions.defaultToSpeaker,
            avAudioSessionMode: AVAudioSessionMode.defaultMode,
            androidAudioAttributes: AndroidAudioAttributes(
              contentType: AndroidAudioContentType.music,
              flags: AndroidAudioFlags.none,
              usage: AndroidAudioUsage.media,
            ),
            androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransient,
            androidWillPauseWhenDucked: true,
          ))
          .then((_) => audioSessions = audioSession));

  getPlaybackFn(String asset) async {
    await player.setAsset(asset);
    _handleInterruptions();
  }

  stop() async {
    await player.stop();
    await audioSessions.setActive(false);
  }

  _handleInterruptions() async {
    player.playing ? await player.stop() : await player.play();
    await audioSessions.setActive(player.playing);
  }
}
