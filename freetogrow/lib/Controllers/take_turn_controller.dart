import 'package:flutter/foundation.dart';
import 'package:freetogrow/Objects/turn_handler.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';

class TakeTurnController extends ChangeNotifier {
  final GameStateRepo _gameStateRepo;

  TakeTurnController({required this._gameStateRepo});

  Future<void> takeTurn(gameId, playerTurn, move, table, cardPlayed) async {
    final updatedTable = List<int>.from(table);
    final indexes = getCardIndexes(move, cardPlayed.$1);

    final playerValue = playerTurn == 1 ? 1 : 2;
    final opponentValue = playerTurn == 1 ? 2 : 1;

    for (final index in indexes) {
      if (cardPlayed.$2) {
        updatedTable[index] = playerValue;
      } else if (updatedTable[index] == opponentValue) {
        updatedTable[index] = 0;
      }
    }

    table = updatedTable;
    final newPlayerTurn = playerTurn % 2 + 1;

    await _gameStateRepo.takeTurn(gameId, newPlayerTurn, table);
  }

  Future<void> waitForMyTurn(
    String gameId,
    int myPlayerNumber,
    void Function(int state) onStateChanged,
  ) async {
    int? previousState;

    while (true) {
      final game = await _gameStateRepo.getGameData(gameId);
      if (game == null) return;

      if (game.state != previousState) {
        previousState = game.state;
        onStateChanged(game.state!);
      }

      if (game.state == 3) return;

      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
