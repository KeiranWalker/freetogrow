import 'package:supabase_flutter/supabase_flutter.dart';

class PlayersRepo {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<PostgrestList> createUser({required String username}) async {
    return await _supabaseClient
        .from('players')
        .insert({'name': username})
        .select('id');
  }
}
