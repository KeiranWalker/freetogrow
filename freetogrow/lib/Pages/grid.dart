import 'package:flutter/material.dart';
import 'package:freetogrow/Controllers/load_game_controller.dart';
import 'package:freetogrow/Controllers/take_turn_controller.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';

import '../Widgets/grid_square.dart';
import '../Widgets/tile_card.dart';
import '../globals.dart' as globals;

class GridPage extends StatefulWidget {
  const GridPage({super.key});

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  late final LoadGameController _loadGameController;
  late final TakeTurnController _takeTurnController;
  late String userId;
  late String gameId;

  Map<int, String>? playerMappings;
  int? myPlayerNumber;
  bool _hasLoaded = false;
  int? playerTurn;
  List<int>? table;

  @override
  void initState() {
    _loadGameController = LoadGameController(gameStateRepo: GameStateRepo());
    _takeTurnController = TakeTurnController(gameStateRepo: GameStateRepo());
    super.initState();
  }

  @override
  void dispose() {
    _loadGameController.dispose();
    _takeTurnController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    final results = await _loadGameController.loadGame(gameId, userId);
    final mappings = results!.$1;
    playerTurn = results.$2;
    table = results.$3;

    if (!mounted) return;

    setState(() {
      playerMappings = mappings;

      if (mappings != null) {
        if (mappings[1] == userId) {
          myPlayerNumber = 1;
        } else if (mappings[2] == userId) {
          myPlayerNumber = 2;
        }
      }
    });

    if (myPlayerNumber != null && playerTurn != 3) {
      waitForMyTurn();
    }
  }

  Future<void> waitForMyTurn() async {
    await _takeTurnController.waitForMyTurn(gameId, myPlayerNumber!, (
      state,
    ) async {
      final results = await _loadGameController.loadGame(gameId, userId);

      if (!mounted || results == null) return;

      setState(() {
        playerTurn = results.$2;
        table = results.$3;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasLoaded) return;
    _hasLoaded = true;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    userId = args['userId']!;
    gameId = args['gameId']!;

    load();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    userId = args['userId']!;
    gameId = args['gameId']!;

    final String username = args['username']!;
    final String opponentName = args['opponentName']!;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      myPlayerNumber == 1 ? username : opponentName,
                      style: TextTheme.of(context).headlineSmall,
                    ),
                    Text(playerTurn == 1 ? "Your turn!" : "Waiting..."),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      myPlayerNumber == 2 ? username : opponentName,
                      style: TextTheme.of(context).headlineSmall,
                    ),
                    Text(playerTurn == 2 ? "Your turn!" : "Waiting..."),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 75),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: ClipRRect(
                child: GridView.count(
                  controller: ScrollController(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  crossAxisCount: 8,
                  children: List.generate(64, (index) {
                    return GridSquare(
                      status: index % 4,
                      size: MediaQuery.of(context).size.width,
                    );
                  }),
                ),
              ),
            ),
          ),
          SizedBox(height: 75),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 20,
                  children: List.generate(3, (index) {
                    try {
                      return TileCard(
                        num: globals.playerHand![index].$1,
                        type: globals.playerHand![index].$2,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                      return ColoredBox(color: Colors.grey);
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
