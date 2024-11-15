import 'package:flutter/material.dart';
import 'package:tradeable/abstract/extensions.dart';
import 'package:tradeable/sound.dart';
import 'package:tradeable/widgets/win_confetti.dart';

import 'game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late MarbleGame game;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    game = MarbleGame();
    game.addListener(() {
      setState(() {});
    });
  }

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${game.currentPlayer.name}',
                ),
                Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value:
                          ((game.currentPlayerRemainingTime?.toDouble() ?? 0) /
                              30.0),
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                    Text('${game.currentPlayerRemainingTime ?? 30}'),
                  ],
                )
              ],
            ),
          ),
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

                final player = game.board[row][col];
                return GestureDetector(
                  onTap: () => _handleTap(row, col),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    color: player == Player.player1
                        ? Colors.blue
                        : player == Player.player2
                            ? Colors.yellow
                            : Colors.grey[300],
                    child: Center(
                      child: Text(
                        player == Player.none
                            ? ""
                            : (player == Player.player1 ? "P1" : "P2"),
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
                  init();
                });
              },
              child: const Text('Re play'),
            ),
          if (game.gameWon)
            WinConfettiWidget(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${game.playerWon.name} Wins!",
                  style: const TextStyle(fontSize: 24, color: Colors.green),
                ),
              ),
            ),
          20.0.vGap,
        ],
      ),
    );
  }
}
