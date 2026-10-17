import 'dart:ffi';
import 'dart:math';

class Turnhandler {
  //GameState game;
  // String which_players_turn

  // update Gamestate (Table) from database - main

  // send new gamestate to gui

  // recieve move from gui and update gamestate

  // draw new card
  int drawNewCard(){
    Random random = Random();
    int min = -3;
    int max = 10;
    int randomNumber = min + random.nextInt(max - min + 1);
    return randomNumber;
  }

  // update flowers if required













}