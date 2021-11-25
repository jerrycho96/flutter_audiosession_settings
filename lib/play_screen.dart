import 'dart:typed_data';

import 'package:danso_function/danso_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:just_audio/just_audio.dart' as ja;

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final _flutterMidi = FlutterMidi();
  JungGanBoPlayer jungGanBoPlayer = JungGanBoPlayer();

  ja.AudioPlayer player = ja.AudioPlayer(
    // handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );

  var note = "";
  var status = "Click on start";
  var pitchResult = 0.0;

  @override
  void initState() {
    super.initState();

    load('assets/Dan.sf2');
  }

  void load(String asset) async {
    _flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    _flutterMidi.prepare(sf2: _byte);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('정간보+장구 재생'),
                  onPressed: () async {
                    // _flutterMidi.playMidiNote(midi: 60);
                    await player.setAsset('assets/semachi.wav');
                    player.play();
                    jungGanBoPlayer.play(JungGanBo('title', '4박장단',
                        't|-h|m|h#t|t|t|o#h|h|h|o#t|t|t|o#t|-h|m|h#t|t|t|o#h|h|t|-h#m|o|o|^#'));
                  },
                ),
                ElevatedButton(
                  child: const Text('정간보+장구 정지'),
                  onPressed: () {
                    // _flutterMidi.stopMidiNote(midi: 60);
                    allMidiStop();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('율명 재생'),
                  onPressed: () async {
                    _flutterMidi.playMidiNote(midi: 60);
                  },
                ),
                ElevatedButton(
                  child: const Text('율명 정지'),
                  onPressed: () {
                    _flutterMidi.stopMidiNote(midi: 60);
                  },
                ),
              ],
            ),
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
                  child: const Text('율명 장구 재생'),
                  onPressed: () async {
                    _flutterMidi.playMidiNote(midi: 60);
                    await player.setAsset('assets/semachi.wav');
                    player.play();
                  },
                ),
                ElevatedButton(
                  child: const Text('율명 장구 정지'),
                  onPressed: () async {
                    _flutterMidi.stopMidiNote(midi: 60);
                    await player.stop();
                  },
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
