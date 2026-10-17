import 'dart:ffi';

import 'package:freetogrow/Objects/game_state.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';

class Gamehandler {
  GameStateRepo gameStateRepo = GameStateRepo();
  GameState? gameState;

  Gamehandler(String player1_id, String player2_id) {
    String gameId = gameStateRepo.createNewGame(player1_id) as String;
    gameState = gameStateRepo.getTableData(gameId) as GameState?;
  }
}

// update Gamestate (Table) from database - main

// send new gamestate to gui

// recieve move from gui and update gamestate
