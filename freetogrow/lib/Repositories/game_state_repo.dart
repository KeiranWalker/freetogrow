import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:freetogrow/Objects/game_state.dart';

class GameStateRepo {
  final supabase = Supabase.instance.client;

  Future<String> createNewGame(String player1_id, String player2_id ) async {
    List<List<int>> table = [];
    for (int i = 0; i < 8; i++ ){
      List<int> newRow = [];
      for (int j = 0; j < 8; j++ ){
        newRow.add(0);
        }
      table.add(newRow);
    }
  final gameId = await supabase.from('game_states').insert({
    'state': 2,
    'player_one': player1_id,
    'player_two': player2_id,
    'table': table,
  }).select().single();;
  return gameId['id'] as String;
  }
  
  Future<GameState?> getTableData(String gameId) async {
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

      // Convert from dynamic type to List<List<int>>
      List<List<int>> table = [];

      for (var row in rawTable) {
        List<dynamic> castedRow = row as List<dynamic>;

        List<int> newRow = [];
        for (var value in castedRow) {
          newRow.add(value as int);
        }
        table.add(newRow);
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

  Future<void> updateTableData(String gameId, List<List<int>> newTable, List<int> hand) async {
    await supabase
        .from('game_states')
        .update({'table': newTable})
        .eq('id', gameId);
  }

  
  // update Gamestate (Table) from database - main

  // send new gamestate to gui

  // recieve move from gui and update gamestate
}