import 'package:danso_ios_speaker_pilot/play_screen.dart';
import 'package:danso_ios_speaker_pilot/record_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('장구/녹음 화면'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const RecordScreen(title: '장구 소리/녹음')));
              },
            ),
            ElevatedButton(
              child: const Text('장구/단소 재생 화면'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PlayScreen(title: '장구/단소 소리')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
