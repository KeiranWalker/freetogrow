import 'dart:ffi';

import 'package:supabase_flutter/supabase_flutter.dart';

class PlayersRepo {
  final supabase = Supabase.instance.client;

  Future<List<int>> getPlayerHand(String playerId) async {
      final dbhand = await supabase
      .from('players')
      .select('hand')
      .eq('id', playerId);

      List<dynamic> dynamicHand = dbhand as List<dynamic>;

      List<int> hand = [];
      for (var card in dynamicHand){
        int cardInt = card as int;
        hand.add(cardInt);
      }

      return hand;
  }
  
  Future<void> updatePlayerHand(String playerId, List<(int, bool)> hand) async {
    await supabase
        .from('players')
        .update({'hand': hand})
        .eq('id', playerId);
  }
}