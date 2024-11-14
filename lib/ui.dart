import 'package:flutter/material.dart';

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
  final MarbleGame game = MarbleGame();

  void _handleTap(int row, int col) {
    if (!game.gameWon && game.placeMarble(row, col)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Two-Player Marble Game"),
      ),
      body: Column(
        children: [
          Text('${game.currentPlayer} turn'),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
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
                            ? Colors.red
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Player ${game.currentPlayer == Player.player1 ? "1" : "2"} Wins!",
                style: const TextStyle(fontSize: 24, color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}
