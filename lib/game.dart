import 'package:tradeable/sound.dart';

enum Player { player1, player2, none }

extension Name on Player {
  String get name => Player.player1 == this ? 'Player 1' : 'Player 2';
}

class MarbleGame {
  late List<List<Player>> board;
  late Player currentPlayer;
  late bool gameWon;
  late Player playerWon;

  MarbleGame() {
    board = List.generate(4, (_) => List.generate(4, (_) => Player.none));
    currentPlayer = Player.player1;
    gameWon = false;
  }

  bool placeMarble(int row, int col) {
    if (board[row][col] == Player.none) {
      board[row][col] = currentPlayer;
      moveMarblesCounterclockwise();
      if (checkWin()) {
        gameWon = true;
        return true;
      }
      switchPlayer();
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

  // bool checkWinCondition(int row, int col) {
  //   return checkLine(row, col, 1, 0) || // Horizontal
  //       checkLine(row, col, 0, 1) || // Vertical
  //       checkLine(row, col, 1, 1) || // Diagonal
  //       checkLine(row, col, 1, -1); // Anti-diagonal
  // }

  // bool checkLine(int row, int col, int dRow, int dCol) {
  //   Player p = board[row][col];
  //   int count = 1;
  //   for (int i = 1; i < 4; i++) {
  //     int r = row + dRow * i;
  //     int c = col + dCol * i;
  //     if (r < 0 || r >= 4 || c < 0 || c >= 4 || board[r][c] != p) break;
  //     count++;
  //   }
  //   for (int i = 1; i < 4; i++) {
  //     int r = row - dRow * i;
  //     int c = col - dCol * i;
  //     if (r < 0 || r >= 4 || c < 0 || c >= 4 || board[r][c] != p) break;
  //     count++;
  //   }
  //   return count >= 4;
  // }

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
