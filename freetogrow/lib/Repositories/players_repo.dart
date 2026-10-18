import 'package:supabase_flutter/supabase_flutter.dart';

class PlayersRepo {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<PostgrestList> createUser({required String username}) async {
    return await _supabaseClient
        .from('players')
        .insert({'name': username})
        .select('id, name');
  }

  Future<List<int>?> getTableData(String playerId) async {
    final dbhand = await _supabaseClient
        .from('players')
        .select('hand')
        .eq('id', playerId);

    List<dynamic> dynamicHand = dbhand as List<dynamic>;

    List<int> hand = [];
    for (var card in dynamicHand) {
      int cardInt = card as int;
      hand.add(cardInt);
    }

    return hand;
  }

  Future<void> updatePlayerHand(String playerId, List<(int, bool)> hand) async {
    await _supabaseClient
        .from('players')
        .update({'hand': hand.map((e) => [e.$1, e.$2]).toList()})
        .eq('id', playerId);
  }

  Future<List<(int, bool)>> getPlayerHand(String playerId) async {
    final response = await _supabaseClient
        .from('players')
        .select('hand')
        .eq('id', playerId)
        .single();

    List<(int, bool)> hand = (response['hand'] as List)
        .map((card) => (card[0] as int, card[1] as bool))
        .toList();

    return hand;
  }
}
