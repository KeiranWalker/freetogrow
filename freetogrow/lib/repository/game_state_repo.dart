import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:freetogrow/objects/GameState.dart';

class GameStateRepo {
  final supabase = Supabase.instance.client;
  
  Future<GameState?> getTableData(String gameId) async {
    final data = await supabase
    .from('GameState')
    .select()
    .eq('id', gameId)
    .maybeSingle();

    if (data != null) {
      String gameId = data['id'] as String;
      int state = data['state'] as int;
      String player1 = data['player1'] as String;
      String player2 = data['player2'] as String;
      String table = data['table'] as String;

      GameState gameState = GameState(
        state: state,
        player1: player1,
        player2: player2,
        gameId: gameId,
        table: [] // Convert table from string to List
      );
      return gameState;
    } else {
      return null;
    }
    
  }

  
  // update Gamestate (Table) from database - main

  // send new gamestate to gui

  // recieve move from gui and update gamestate
}