import 'dart:ffi';
import 'dart:math';
import 'package:freetogrow/Objects/game_state.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';

class Turnhandler {
  GameStateRepo gameStateRepo = GameStateRepo();
  //GameState game;
  // String which_players_turn

  // update Gamestate (Table) from database - main
  GameState? GetUpdatedGameState() {
    GameState? gameState = gameStateRepo.getTableData('gameId') as GameState?;
    return gameState;
  }
  
  // send new gamestate to gui

  // recieve move from gui and update gamestate

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

  // update flowers if required













}