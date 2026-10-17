import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:freetogrow/Objects/game_state.dart';

class GameStateRepo {
  final _supbaseClient = Supabase.instance.client;

  Future<String> createNewGame(String player1_id) async {
    List<List<int>> table = [];
    for (int i = 0; i < 8; i++) {
      List<int> newRow = [];
      for (int j = 0; j < 8; j++) {
        newRow.add(0);
      }
      table.add(newRow);
    }

    final gameId = await _supbaseClient
        .from('game_states')
        .insert({'state': 0, 'player_one': player1_id, 'table': table})
        .select()
        .single();
    return gameId['id'] as String;
  }

  Future<void> backFillGame(String gamedId, userId) async {
    await _supbaseClient
        .from('game_states')
        .update({'state': 2, 'player_two': userId})
        .eq('id', gamedId);
  }

  Future<GameState?> getTableData(String gameId) async {
    final data = await _supbaseClient
        .from('game_states')
        .select()
        .eq('id', gameId)
        .maybeSingle();

    if (data != null) {
      String gameId = data['id'] as String;
      int state = data['state'] as int;
      String player1 = data['player_one'] as String;
      String player2 = data['player_two'] as String;
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
        table: table,
      );
      return gameState;
    } else {
      return null;
    }
  }

  Future<void> updateTableData(
    String gameId,
    List<List<int>> newTable,
    List<int> hand,
  ) async {
    await _supbaseClient
        .from('game_states')
        .update({'table': newTable})
        .eq('id', gameId);
  }

  Future<PostgrestList> isPendingGame() {
    return _supbaseClient
        .from('game_states')
        .select('id')
        .eq('state', 0)
        .isFilter('player_two', null);
  }

  Future<bool> hasSecondPlayer(String gameId) async {
    final response = await _supbaseClient
        .from('game_states')
        .select('player_two')
        .eq('id', gameId)
        .single();

    return response['player_two'] != null;
  }

  // update Gamestate (Table) from database - main

  // send new gamestate to gui

  // recieve move from gui and update gamestate
}
