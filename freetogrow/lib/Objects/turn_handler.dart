import 'dart:math';

import 'package:freetogrow/Objects/game_state.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';
import 'package:freetogrow/Repositories/players_repo.dart';

class Turnhandler {
  final GameStateRepo gameStateRepo = GameStateRepo();
  final PlayersRepo playersRepo = PlayersRepo();

  final String gameId;
  String playerId = '';

  Turnhandler(this.gameId);

  Future<void> playTurn() async {
    // Get updated board
    final GameState? updatedState = await getUpdatedGameState();

    if (updatedState == null) return;

    // Determine whose turn it is
    if (updatedState.state == 1) {
      playerId = updatedState.player1!;
    } else if (updatedState.state == 2) {
      playerId = updatedState.player2!;
    } else {
      return;
    }

    // Get player hand
    final List<(int, bool)> hand = await playersRepo.getPlayerHand(playerId);

    // Send board and hand to GUI
    // TODO: Receive updated board from GUI
    final List<int> updatedTable = updatedState.table as List<int>;

    // TODO: Receive updated hand from GUI
    final List<(int, bool)> newHand = List.from(hand);

    // TODO: Check whether the game has ended
    // TODO: Update flowers

    // Save updated board
    await gameStateRepo.updateTableData(gameId, updatedTable);

    // Generate new cards until the hand contains 3 cards
    while (newHand.length < 3) {
      newHand.add(drawNewCard());
    }

    // Save updated hand
    // await playersRepo.updatePlayerHand(playerId, newHand);
  }

  Future<GameState?> getUpdatedGameState() async {
    return await gameStateRepo.getGameData(gameId);
  }

  (int, bool) drawNewCard() {
    final random = Random();

    final int randomNumber = random.nextInt(15);
    final bool positive = random.nextInt(10) < 7;

    return (randomNumber, positive);
  }
}
