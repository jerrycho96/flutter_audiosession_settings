import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:audio_session/audio_session.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);
  late AudioSession audioSessions;

  ja.AudioPlayer player = ja.AudioPlayer(
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );

  var note = "";
  var status = "Click on start";
  var pitchResult = 0.0;

  @override
  void initState() {
    super.initState();

    // _audioSessionConfigure();
  }

  _audioSessionConfigure() =>
      AudioSession.instance.then((audioSession) async => await audioSession
          .configure(const AudioSessionConfiguration(
            avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
            avAudioSessionCategoryOptions:
                AVAudioSessionCategoryOptions.defaultToSpeaker,
            avAudioSessionMode: AVAudioSessionMode.videoRecording,
            avAudioSessionRouteSharingPolicy:
                AVAudioSessionRouteSharingPolicy.defaultPolicy,
            avAudioSessionSetActiveOptions:
                AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
            // androidAudioAttributes: AndroidAudioAttributes(
            //   contentType: AndroidAudioContentType.music,
            //   flags: AndroidAudioFlags.none,
            //   usage: AndroidAudioUsage.media,
            // ),
            // androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransient,
            // androidWillPauseWhenDucked: true,
          ))
          .then((_) => audioSessions = audioSession));

  Future<void> _startCapture() async {
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);

    setState(() {
      note = "";
      status = "Play something";
    });
  }

  Future<void> _stopCapture() async {
    await _audioRecorder.stop();

    setState(() {
      note = "";
      status = "Click on start";
    });
  }

  void listener(dynamic obj) {
    //Gets the audio sample
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    //Uses pitch_detector_dart library to detect a pitch from the audio sample
    final result = pitchDetectorDart.getPitch(audioSample);

    //If there is a pitch - evaluate it
    if (result.pitched) {
      //Uses the pitchupDart library to check a given pitch for a Guitar
      final handledPitchResult = pitchupDart.handlePitch(result.pitch);

      //Updates the state with the result
      setState(() {
        note = handledPitchResult.note;
        status = handledPitchResult.tuningStatus.toString();
        pitchResult = result.pitch;
      });
    }
  }

  void onError(Object e) {
    print(e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          Center(
              child: Text(
            note,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          )),
          Center(
              child: Text(
            '$pitchResult',
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          )),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('장구 재생'),
                onPressed: () async {
                  await player.setAsset('assets/semachi.wav');
                  player.play();
                },
              ),
              ElevatedButton(
                child: const Text('장구 정지'),
                onPressed: () async {
                  await player.stop();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('장구/녹음 시작'),
                onPressed: () async {
                  await player.setAsset('assets/semachi.wav');
                  _startCapture();
                  player.play();
                  _audioSessionConfigure();
                  // audioSessions!.setActive(true);
                },
              ),
              ElevatedButton(
                child: const Text('장구/녹음 정지'),
                onPressed: () async {
                  await player.stop();

                  await _stopCapture();
                  // audioSessions!.setActive(false);
                },
              ),
            ],
          ),
          const Spacer(),
        ]),
      ),
    );
  }
}
