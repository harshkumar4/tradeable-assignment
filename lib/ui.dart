import 'package:flutter/material.dart';
import 'package:tradeable/abstract/extensions.dart';
import 'package:tradeable/sound.dart';

import 'game.dart';

void main() {
  runApp(const MarbleGameApp());
}

class MarbleGameApp extends StatelessWidget {
  const MarbleGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  MarbleGame game = MarbleGame();

  void _handleTap(int row, int col) {
    GameSound.onTap();
    if (!game.gameWon && game.placeMarble(row, col)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Two - Player Marble Game"),
      ),
      body: Column(
        children: [
          Text('${game.currentPlayer.name} turn'),
          40.vGap,
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              padding: const EdgeInsets.all(18),
              itemCount: 16,
              itemBuilder: (context, index) {
                int row = index ~/ 4;
                int col = index % 4;
                return GestureDetector(
                  onTap: () => _handleTap(row, col),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    color: game.board[row][col] == Player.player1
                        ? Colors.blue
                        : game.board[row][col] == Player.player2
                            ? Colors.yellow
                            : Colors.grey[300],
                    child: Center(
                      child: Text(
                        game.board[row][col] == Player.none
                            ? ""
                            : (game.board[row][col] == Player.player1
                                ? "P1"
                                : "P2"),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (game.gameWon)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  game = MarbleGame();
                });
              },
              child: const Text('Re play'),
            ),
          if (game.gameWon)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${game.playerWon.name} Wins!",
                style: const TextStyle(fontSize: 24, color: Colors.green),
              ),
            ),
          20.0.vGap,
        ],
      ),
    );
  }
}
