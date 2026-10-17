// mess that some uniformed people may call code was Finlays but I just edited it as the structure change.
// therefore I shouldn;t be blamed for this atrocity
import 'package:freetogrow/Objects/game_state.dart';
import 'dart:math';

class FlowerService {
  final GameState gameState;

  FlowerService (this.gameState);

  GameState populateWithFlowers() {
    // so it appears that this bit counts the number of flowers and the number of open squares
    int flowerCount = 0;
    int openCount = 0;
    dynamic table = gameState.table;
    for (int tile in table){
      if (tile == 0 || tile == 3) {
        openCount += 1;
        if (tile == 3) {
          flowerCount += 1;
        }
      }
    }

    // we want less flowers if there are less open spaces - this bit figures out how many 
    int expectedCount;
    switch (openCount) {
      case >32:
        expectedCount = 3;
        break;
      case >16:
        expectedCount = 2;
        break;
      case > 8:
        expectedCount = 1;
        break;
      default:
        expectedCount = 0;
        break;
    }


    // we can't just index a rand num between 1 and 64 as it needs to be an open square hence this mess which I refuse to touch
    while (flowerCount < expectedCount) {
        var rng = Random();
        int random = rng.nextInt(openCount);
        while (random > 0) {
          for (int tile in table) {
            if (tile == 0) {
              if (random == 0) {
                tile = 3;
                random -= 1;
                break;
              }
              random -= 1; 
            }
            if (random == -1) {
              break;
            }
          }
        }
        flowerCount -= 1;
    }
    gameState.table = table;
    return gameState;
  }
}