import 'package:supabase_flutter/supabase_flutter.dart';

class PlayersRepo {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<(int, bool)>> getPlayerHand(String playerId) async {
      final response = await _supabaseClient
      .from('players')
      .select('hand')
      .eq('id', playerId)
      .single();

      List<(int, bool)> hand = (response['hand'] as List).map((card) => (card[0] as int, card[1] as bool)).toList();

      return hand;
  }
  
  Future<void> updatePlayerHand(String playerId, List<(int, bool)> hand) async {
    await _supabaseClient
        .from('players')
        .update({'hand': hand.map((e) => [e.$1, e.$2]).toList()})
        .eq('id', playerId);
  }
}
