import 'package:freetogrow/Objects/game_state.dart';
import 'package:freetogrow/Objects/turn_handler.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';

class Gamehandler {
  final GameStateRepo gameStateRepo = GameStateRepo();
  late GameState gameState;

  Future<void> initialise(String gameId) async {
    final data = await gameStateRepo.getGameData(gameId);

    if (data == null) {
      throw Exception('Game not found');
    }
  }

  Future<void> playGame() async {
    while (gameState.getStatus() != 3 && gameState.getStatus() != -1) {
      final Turnhandler turn = Turnhandler(gameState.getGameId());

      gameState = turn.playTurn(gameState) as GameState;
    }

    // TODO: alert game over
  }
}
