import 'dart:math';

import 'package:freetogrow/Objects/game_state.dart';
import 'package:freetogrow/Objects/replenish_flowers.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';
import 'package:freetogrow/Repositories/players_repo.dart';

class Turnhandler {
  final GameStateRepo gameStateRepo = GameStateRepo();
  final PlayersRepo playersRepo = PlayersRepo();

  final String gameId;
  String playerId = '';

  Turnhandler(this.gameId);

  Future<GameState> playTurn(
    GameState currentState,
    int move,
    (int, bool) cardPlayed,
    List<int> updatedTable,
  ) async {
    int? state = currentState.state;
    if (state == 1) {
      playerId = currentState.player1;
    } else if (state == 2) {
      playerId = currentState.player2;
    } else {
      currentState.state = -1;
      return currentState;
    }

    List<(int, bool)> hand = await playersRepo.getPlayerHand(playerId);

    if (checkGameEnd(currentState.table, hand)) {
      currentState.state = 3;
      return currentState;
    }

    // Update board with the move received from the GUI.
    currentState.table = updatedTable;

    // Remove the played card from the hand.
    hand.remove(cardPlayed);

    // Update flowers.
    final FlowerService flowerService = FlowerService(currentState);
    currentState = flowerService.populateWithFlowers();

    // Save updated board.
    await gameStateRepo.updateTableData(gameId, currentState.table);

    // Replenish hand to 3 cards.
    while (hand.length < 3) {
      hand.add(drawNewCard());
    }

    // Save updated hand.
    await playersRepo.updatePlayerHand(playerId, hand);

    // Switch turns.
    currentState.state = state == 1 ? 2 : 1;

    return currentState;
  }

  Future<GameState?> getUpdatedGameState() async {
    return await gameStateRepo.getGameData(gameId);
  }

  // draw new card
  (int, bool) drawNewCard() {
    Random random = Random();
    int min = 0;
    int max = 14;
    int randomNumber = min + random.nextInt(max - min + 1);
    bool positive = true;
    if (random.nextInt(10) >= 7) {
      positive = false;
    }
    return (randomNumber, positive); // doesn't have positive or negative
  }

  bool checkGameEnd(List<int> board, List<(int, bool)> cards) {
    for (var card in cards) {
      if (card.$2 == false) {
        return true;
      } else {
        switch (card.$1) {
          case 0:
            // □
            for (var square in board) {
              if (square == 0 || square == 3) {
                return true;
              }
            }
          case 1:
            // □
            // □
            for (var i = 0; i < 56; i++) {
              if (checkSquare(board, i)) {
                int indexToCheck = i + 8;
                if (checkSquare(board, indexToCheck)) {
                  return true;
                }
              }
            }
          case 2:
            // □□
            for (var i = 0; i < 63; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 == 7) {
                  continue;
                }
                int indexToCheck = i + 1;
                if (checkSquare(board, indexToCheck)) {
                  return true;
                }
              }
            }
          case 3:
            // □
            // □
            // □
            for (var i = 0; i < 48; i++) {
              if (checkSquare(board, i)) {
                int indexToCheck1 = i + 8;
                int indexToCheck2 = i + 8;
                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2)) {
                  return true;
                }
              }
            }
          case 4:
            // □□□
            for (var i = 0; i < 62; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 >= 6) {
                  continue;
                }
                int indexToCheck1 = i + 1;
                int indexToCheck2 = i + 2;
                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2)) {
                  return true;
                }
              }
            }
          case 5:
            // □□
            // □
            for (var i = 0; i < 55; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 >= 7) {
                  continue;
                }
                int indexToCheck1 = i + 1;
                int indexToCheck2 = i + 8;
                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2)) {
                  return true;
                }
              }
            }
          case 6:
            // □
            // □□
            for (var i = 0; i < 55; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 >= 7) {
                  continue;
                }
                int indexToCheck1 = i + 8;
                int indexToCheck2 = i + 9;

                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2)) {
                  return true;
                }
              }
            }
          case 7:
            // □□
            //  □
            for (var i = 0; i < 55; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 >= 7) {
                  continue;
                }
                int indexToCheck1 = i + 1;
                int indexToCheck2 = i + 9;

                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2)) {
                  return true;
                }
              }
            }
          case 8:
            //  □
            // □□
            for (var i = 0; i < 56; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 < 1) {
                  continue;
                }
                int indexToCheck1 = i + 7;
                int indexToCheck2 = i + 8;

                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2)) {
                  return true;
                }
              }
            }
          case 9:
            //  □
            // □□
            //  □
            for (var i = 0; i < 48; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 < 1) {
                  continue;
                }
                int indexToCheck1 = i + 7;
                int indexToCheck2 = i + 8;
                int indexToCheck3 = i + 16;

                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2) &&
                    checkSquare(board, indexToCheck3)) {
                  return true;
                }
              }
            }
          case 10:
            //  □
            // □□□
            for (var i = 0; i < 56; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 < 1 || i % 8 >= 7) {
                  continue;
                }
                int indexToCheck1 = i + 7;
                int indexToCheck2 = i + 8;
                int indexToCheck3 = i + 9;

                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2) &&
                    checkSquare(board, indexToCheck3)) {
                  return true;
                }
              }
            }
          case 11:
            // □
            // □□
            // □
            for (var i = 0; i < 47; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 >= 7) {
                  continue;
                }
                int indexToCheck1 = i + 8;
                int indexToCheck2 = i + 9;
                int indexToCheck3 = i + 16;

                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2) &&
                    checkSquare(board, indexToCheck3)) {
                  return true;
                }
              }
            }
          case 12:
            // □□□
            //  □
            for (var i = 0; i < 54; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 >= 6) {
                  continue;
                }
                int indexToCheck1 = i + 1;
                int indexToCheck2 = i + 2;
                int indexToCheck3 = i + 9;

                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2) &&
                    checkSquare(board, indexToCheck3)) {
                  return true;
                }
              }
            }
          case 13:
            // □□□□
            for (var i = 0; i < 61; i++) {
              if (checkSquare(board, i)) {
                if (i % 8 >= 5) {
                  continue;
                }
                int indexToCheck1 = i + 1;
                int indexToCheck2 = i + 2;
                int indexToCheck3 = i + 3;

                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2) &&
                    checkSquare(board, indexToCheck3)) {
                  return true;
                }
              }
            }
          case 14:
            // □
            // □
            // □
            // □
            for (var i = 0; i < 40; i++) {
              if (checkSquare(board, i)) {
                int indexToCheck1 = i + 8;
                int indexToCheck2 = i + 16;
                int indexToCheck3 = i + 24;
                if (checkSquare(board, indexToCheck1) &&
                    checkSquare(board, indexToCheck2) &&
                    checkSquare(board, indexToCheck3)) {
                  return true;
                }
              }
            }
        }
      }
    }
    // switch between card types, different logic per card

    return false;
  }

  bool checkSquare(List<int> board, int index) {
    if (board[index] == 0 || board[index] == 3) {
      return true;
    }
    return false;
  }
}

List<int> getCardIndexes(int move, int cardType) {
  switch (cardType) {
    case 0: // □
      return [move];

    case 1: // □ / □ (vertical 2)
      return [move, move + 8];

    case 2: // □□ (horizontal 2)
      return [move, move + 1];

    case 3: // vertical 3
      return [move, move + 8, move + 16];

    case 4: // horizontal 3
      return [move, move + 1, move + 2];

    case 5: // □□ / □
      return [move, move + 1, move + 8];

    case 6: // □ / □□
      return [move, move + 8, move + 9];

    case 7: // □□ /  □
      return [move, move + 1, move + 9];

    case 8: //  □ / □□
      return [move, move + 7, move + 8];

    case 9: //  □ / □□ /  □
      return [move, move + 7, move + 8, move + 16];

    case 10: //  □ / □□□
      return [move, move + 7, move + 8, move + 9];

    case 11: // □ / □□ / □
      return [move, move + 8, move + 9, move + 16];

    case 12: // □□□ /  □
      return [move, move + 1, move + 2, move + 9];

    case 13: // horizontal 4
      return [move, move + 1, move + 2, move + 3];

    case 14: // vertical 4
      return [move, move + 8, move + 16, move + 24];

    default:
      return [];
  }
}
