import 'dart:ffi';
import 'dart:math';
import 'package:freetogrow/Objects/game_state.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';
import 'package:freetogrow/Repositories/players_repo.dart';

class Turnhandler {
  GameStateRepo gameStateRepo = GameStateRepo();
  PlayersRepo playersRepo = PlayersRepo();
  String gameId;
  String playerId = "";

  Turnhandler (this.gameId);

  void playTurn(){
    // Get updated board
    GameState? updatedState = getUpdatedGameState();
    if (updatedState == null){
      return;
    }

    int? state = updatedState.state;
    if (state == 1){
      playerId = updatedState.player1 as String;
    } else if (state == 2){
      playerId = updatedState.player2 as String;
    } else {
      // error
      return;
    }


    // Get Player Hand
    List<int> hand = playersRepo.getPlayerHand(playerId) as List<int>;

    // Send board to GUI
      // updatedState.board e.g.
    // Send player hand to gui
    // Recieve updated board from gui
    List<List<int>> updatedTable = [];
    // Recieve updated hand from gui
    List<int> newHand = [];


    // Check if game has ended, if so change game status to 3 and return


    // Update flowers

    // Send updated board to db
    gameStateRepo.updateTableData(gameId, updatedTable);

    // Generate new card
    while (newHand.length < 3){
      int card = drawNewCard();
      newHand.add(card);
    }
    // Send updated hand to db
    playersRepo.updatePlayerHand(playerId, newHand);
  }

  // update Gamestate (Table) from database - main
  GameState? getUpdatedGameState() {
    GameState? gameState = gameStateRepo.getGameData(gameId) as GameState?;
    return gameState;
  }

  // draw new card
  (int, bool) drawNewCard(){
    Random random = Random();
    int min = 0;
    int max = 14;
    int randomNumber = min + random.nextInt(max - min + 1);
    bool positive = true;
    if (random.nextInt(10) >= 7){
      positive = false;
    }
    return (randomNumber, positive); // doesn't have positive or negative
  }
}