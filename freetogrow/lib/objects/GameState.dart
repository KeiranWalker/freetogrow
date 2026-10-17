import 'dart:ffi';

class GameState{
  String? gameId;
  int? state;
  String? player1;
  String? player2;
  List<Int>? hand1;
  List<Int>? hand2;

  List<List<Int>>? table;

  GameState({
    this.gameId,
    this.state,
    this.player1,
    this.player2,
    this.hand1,
    this.hand2,
    this.table,
  });
}