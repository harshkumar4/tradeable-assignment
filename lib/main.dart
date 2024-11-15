import 'package:flutter/material.dart';
import 'package:tradeable/sound.dart';
import 'package:tradeable/ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GameSound.playBg();

    return MaterialApp(
      title: 'Marble Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}
