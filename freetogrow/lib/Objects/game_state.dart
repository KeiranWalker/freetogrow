class GameState{
  String gameId;
  int state;
  String player1;
  String player2;
  List<(int, bool)> hand1;
  List<(int, bool)> hand2;

  List<int> table;

  GameState({
    this.gameId = "",
    this.state = -1,
    this.player1 = "",
    this.player2 = "",
    this.hand1 = const [],
    this.hand2 = const [],
    this.table = const [],
  });

  int getStatus(){
      return state;
    }
}