import 'dart:ffi';
import 'package:freetogrow/Objects/game_state.dart';
import 'package:freetogrow/Objects/turn_handler.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';

class Gamehandler {
  GameStateRepo gameStateRepo = GameStateRepo();
  GameState gameState = GameState();

  Gamehandler(String player1_id){
    String gameId = gameStateRepo.createNewGame(player1_id) as String;
    gameState = gameStateRepo.getTableData(gameId) as GameState;
  }

  void play_game(){
    while (gameState.getStatus() != 3 && gameState.getStatus() != -1){
      Turnhandler turn = Turnhandler(); 
      //gameturn.playturn();
      }

      
      
  }





  // update Gamestate (Table) from database - main


  // send new gamestate to gui

  // recieve move from gui and update gamestate
}