import 'package:flutter/foundation.dart';
import 'package:freetogrow/Objects/game_state.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';

class LoadGameController extends ChangeNotifier {
  final GameStateRepo _gameStateRepo;

  LoadGameController({required this._gameStateRepo});

  String? error;
  bool isLoading = false;
  GameState? gameState;
  int? playerNumber;

  Future<(Map<int, String>, int)?> loadGame(
    String gameId,
    String userId,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      gameState = await _gameStateRepo.getGameData(gameId);

      if (gameState == null) {
        error = 'Game not found';
        return null;
      }
      return (
        {1: gameState!.player1!, 2: gameState!.player2!},
        gameState!.state,
      );
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
