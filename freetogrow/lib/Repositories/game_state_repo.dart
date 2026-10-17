import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:freetogrow/Objects/game_state.dart';

class GameStateRepo {
  final _supabaseClient = Supabase.instance.client;

  Future<String> createNewGame(String playerId) async {
    final List<int> table = List.filled(64, 0);

    final game = await _supabaseClient
        .from('game_states')
        .insert({'state': 0, 'player_one': playerId, 'table': table})
        .select()
        .single();

    return game['id'] as String;
  }

  Future<void> backFillGame(String gameId, String userId) async {
    await _supabaseClient
        .from('game_states')
        .update({'state': 2, 'player_two': userId})
        .eq('id', gameId);
  }

  Future<GameState?> getGameData(String gameId) async {
    final data = await _supabaseClient
        .from('game_states')
        .select()
        .eq('id', gameId)
        .maybeSingle();

    if (data == null) return null;

    final List<int> table = List<int>.from(data['table'] as List);

    return GameState(
      state: data['state'] as int,
      player1: data['player_one'] as String,
      player2: data['player_two'] as String,
      gameId: data['id'] as String,
      table: table,
    );
  }

  Future<void> updateTableData(String gameId, List<int> newTable) async {
    await _supabaseClient
        .from('game_states')
        .update({'table': newTable})
        .eq('id', gameId);
  }

  Future<PostgrestList> isPendingGame() {
    return _supabaseClient
        .from('game_states')
        .select('id')
        .eq('state', 0)
        .isFilter('player_two', null);
  }

  Future<bool> hasSecondPlayer(String gameId) async {
    final response = await _supabaseClient
        .from('game_states')
        .select('player_two')
        .eq('id', gameId)
        .single();

    return response['player_two'] != null;
  }
}
