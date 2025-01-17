import 'package:flutter/foundation.dart';
import 'package:tradeable/sound.dart';
import 'package:tradeable/utils/stopwatch.dart';

enum Player { player1, player2, none }

extension Name on Player {
  String get name => Player.player1 == this ? 'Player 1' : 'Player 2';
}

class MarbleGame extends ChangeNotifier {
  late List<List<Player>> board;
  late Player currentPlayer;
  late bool gameWon;
  late Player playerWon;
  late int? currentPlayerRemainingTime;

  late CustomStopwatch stopwatch;

  late final int maxPlayerTime;

  MarbleGame() {
    board = List.generate(4, (_) => List.generate(4, (_) => Player.none));
    currentPlayer = Player.player1;
    gameWon = false;
    maxPlayerTime = 30;
    currentPlayerRemainingTime = null;
    stopwatch = CustomStopwatch(
      totalIterations: maxPlayerTime,
      onTick: (p0) {
        currentPlayerRemainingTime = maxPlayerTime - p0;
        notifyListeners();

        GameSound.onTick();
      },
      onComplete: () {
        _switchTurn();
        notifyListeners();
      },
    );
  }

  void _startTimer() {
    stopwatch.startTimer();
  }

  void _switchTurn() {
    moveMarblesCounterclockwise();
    if (checkWin()) {
      gameWon = true;
      stopwatch.cancel();
      return;
    }

    switchPlayer();
    currentPlayerRemainingTime = maxPlayerTime;
    stopwatch.restart();
  }

  bool placeMarble(int row, int col) {
    if (currentPlayerRemainingTime == null) {
      _startTimer();
    }
    if (board[row][col] == Player.none) {
      board[row][col] = currentPlayer;
      moveMarblesCounterclockwise();
      if (checkWin()) {
        gameWon = true;
        stopwatch.cancel();
        return true;
      }

      switchPlayer();
      currentPlayerRemainingTime = maxPlayerTime;
      stopwatch.restart();
      return true;
    }
    return false;
  }

  void moveMarblesCounterclockwise() {
    List<List<Player>> newBoard =
        List.generate(4, (_) => List.generate(4, (_) => Player.none));

    List<List<int>> outerIndices = [
      [0, 0],
      [0, 1],
      [0, 2],
      [0, 3],
      [1, 3],
      [2, 3],
      [3, 3],
      [3, 2],
      [3, 1],
      [3, 0],
      [2, 0],
      [1, 0],
    ];

    final innerIndices = [
      [1, 1],
      [1, 2],
      [2, 2],
      [2, 1],
    ];

    for (int i = 0; i < outerIndices.length; i++) {
      var current = outerIndices[i];
      var next = outerIndices[(i + 1) % outerIndices.length];
      newBoard[next[0]][next[1]] = board[current[0]][current[1]];
    }

    for (int i = 0; i < innerIndices.length; i++) {
      var current = innerIndices[i];
      var next = innerIndices[(i + 1) % innerIndices.length];
      newBoard[next[0]][next[1]] = board[current[0]][current[1]];
    }

    board = newBoard;
  }

  bool checkWin() {
    for (int i = 0; i < 4; i++) {
      if (board[i][0] != Player.none &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][2] == board[i][3]) {
        playerWon = board[i][3];
        GameSound.onGameWon();
        return true;
      }
    }

    for (int i = 0; i < 4; i++) {
      if (board[0][i] != Player.none &&
          board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[2][i] == board[3][i]) {
        playerWon = board[3][i];
        GameSound.onGameWon();
        return true;
      }
    }

    if (board[0][0] != Player.none &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[2][2] == board[3][3]) {
      playerWon = board[3][3];
      GameSound.onGameWon();
      return true;
    }

    if (board[0][3] != Player.none &&
        board[0][3] == board[1][2] &&
        board[1][2] == board[2][1] &&
        board[2][1] == board[3][0]) {
      playerWon = board[3][0];
      GameSound.onGameWon();
      return true;
    }

    return false;
  }

  void switchPlayer() {
    currentPlayer =
        currentPlayer == Player.player1 ? Player.player2 : Player.player1;
  }
}
