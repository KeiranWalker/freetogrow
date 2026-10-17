import 'dart:ffi';

class GameState{
  String? gameId;
  int state;
  String? player1;
  String? player2;
  List<int>? hand1;
  List<int>? hand2;

  List<int>? table;

  GameState({
    this.gameId,
    this.state = -1,
    this.player1,
    this.player2,
    this.hand1,
    this.hand2,
    this.table,
  });

  int getStatus(){
      return state;
    }
}