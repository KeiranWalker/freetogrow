import 'dart:ffi';

class GameState{
  String gameId = "";
  int status = -1;
  String User1 = "";
  String User2 = "";
  List<Int> hand1 = [];
  List<Int> hand2 = [];

  List<List<Int>> table = [];
}