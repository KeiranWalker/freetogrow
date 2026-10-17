import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:freetogrow/Objects/game_state.dart';

class GameStateRepo {
  final supabase = Supabase.instance.client;

  Future<String> createNewGame(String playerId,) async {
    List<int> table = [];
    for (int i = 0; i < 64; i++ ){
      table.add(0);
    }
  final gameId = await supabase.from('game_states').insert({
    'state': 0,
    'player_one': playerId,
    'table': table,
  }).select().single();
  return gameId['id'] as String;
  }
  
  Future<GameState?> getGameData(String gameId) async {
    final data = await supabase
    .from('game_states')
    .select()
    .eq('id', gameId)
    .maybeSingle();

    if (data != null) {
      String gameId = data['id'] as String;
      int state = data['state'] as int;
      String player1 = data['player1'] as String;
      String player2 = data['player2'] as String;
      List<dynamic> rawTable = data['table'] as List<dynamic>;

      // Convert from dynamic type to List<int>
      List<int> table = [];

      for (var value in rawTable) {
        table.add(value) as int;
      }

      GameState gameState = GameState(
        state: state,
        player1: player1,
        player2: player2,
        gameId: gameId,
        table: table
      );
      return gameState;
    } else {
      return null;
    }
    
  }

  Future<void> updateTableData(String gameId, List<int> newTable) async {
    await supabase
        .from('game_states')
        .update({'table': newTable})
        .eq('id', gameId);
  }

  
  // update Gamestate (Table) from database - main

  // send new gamestate to gui

  // recieve move from gui and update gamestate
}