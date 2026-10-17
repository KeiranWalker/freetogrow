import 'package:flutter/material.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';
import 'package:freetogrow/Repositories/players_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateUserController extends ChangeNotifier {
  final PlayersRepo _playersRepo;
  final GameStateRepo _gameStateRepo;

  CreateUserController(this._playersRepo, this._gameStateRepo);

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
      final String userId = response!.first['id'];

      response = await _gameStateRepo.isPendingGame();

      late final String gameId;

      if (response!.isNotEmpty) {
        gameId = response!.first['id'];
        await _gameStateRepo.backFillGame(gameId, userId);
      } else {
        gameId = await _gameStateRepo.createNewGame(userId);
      }

      while (!await _gameStateRepo.hasSecondPlayer(gameId)) {
        await Future.delayed(const Duration(seconds: 2));
      }

      return userId;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
