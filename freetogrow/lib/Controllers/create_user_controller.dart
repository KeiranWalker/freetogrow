import 'package:flutter/material.dart';
import 'package:freetogrow/Repositories/players_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateUserController extends ChangeNotifier {
  final PlayersRepo _playersRepo;

  CreateUserController(this._playersRepo);

  bool isLoading = false;
  String? error;
  PostgrestList? response;

  Future<String?> createUser({required String username}) async {
    try {
      isLoading = true;
      error = null;
      response = null;
      notifyListeners();

      response = await _playersRepo.createUser(username: username);
      final String id = response!.first['id'];
    } catch (e) {
      error = e.toString();
      return null;
    }
  }
}
