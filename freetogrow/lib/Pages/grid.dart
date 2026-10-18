import 'package:flutter/material.dart';
import 'package:freetogrow/Controllers/load_game_controller.dart';
import 'package:freetogrow/Controllers/take_turn_controller.dart';
import 'package:freetogrow/Objects/turn_handler.dart';
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
  late int moveIndex;
  late (int, bool) cardPlayed;
  bool validMove = false;

  late List<GridSquare>? grid;
  bool loading = true;
  Map<int, String>? playerMappings;
  int? myPlayerNumber;
  bool _hasLoaded = false;
  int? playerTurn;
  List<int>? table;
  List<int>? newTable;

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

    if (globals.playerHand == [] || globals.playerHand!.isEmpty) {
      final handler = Turnhandler(gameId);
      globals.playerHand = [
        handler.drawNewCard(),
        handler.drawNewCard(),
        handler.drawNewCard(),
      ];
    }

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
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_hasLoaded) return;
    _hasLoaded = true;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    userId = args['userId']!;
    gameId = args['gameId']!;

    await load();

    grid = buildGrid(table ?? [1] + List.filled(62, 0) + [2]);
    loading = false;
  }

  void setValidMove(int index, (int, bool) cardPlayedTuple) {
    setState(() {
      moveIndex = index;
      cardPlayed = cardPlayedTuple;
      newTable = table!.toList();
      for (index in getCardIndexes(moveIndex, cardPlayedTuple.$1)) {
        newTable![index] = 4;
      }
      grid = buildGrid(newTable!);
      validMove = true;
    });
  }

  List<GridSquare> buildGrid(List<int> table) {
    return List.generate(64, (index) {
      return GridSquare(
        status: table[index],
        size: MediaQuery.of(context).size.width,
        boardState: table,
        index: index,
        myPlayerNumber: myPlayerNumber!,
        validMoveCallback: setValidMove,
      );
    });
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
                    Text(playerTurn == 1 ? "Playing!" : "Waiting..."),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      myPlayerNumber == 2 ? username : opponentName,
                      style: TextTheme.of(context).headlineSmall,
                    ),
                    Text(playerTurn == 2 ? "Playing!" : "Waiting..."),
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
                  children: loading ? [CircularProgressIndicator()] : grid!,
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Column(
                children: loading
                    ? [ColoredBox(color: Colors.grey)]
                    : [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          spacing: 20,
                          children: List.generate(3, (index) {
                            int num = globals.playerHand![index].$1;
                            bool type = globals.playerHand![index].$2;
                            try {
                              return Draggable<(int, bool)>(
                                data: (num, type),
                                feedback: Opacity(
                                  opacity: 0.7,
                                  child: TileCard(num: num, type: type),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0,
                                  child: TileCard(num: num, type: type),
                                ),
                                child: TileCard(num: num, type: type),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                              return ColoredBox(color: Colors.grey);
                            }
                          }),
                        ),
                      ],
              ),
            ),
          ),
          SizedBox(height: 50),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: FilledButton(
              onPressed: validMove
                  ? () async {
                      await _takeTurnController.takeTurn(
                        gameId,
                        playerTurn,
                        moveIndex,
                        table,
                        cardPlayed,
                      );

                      if (!mounted) return;

                      final updatedTable = List<int>.from(table!);
                      final indexes = getCardIndexes(moveIndex, cardPlayed.$1);

                      final playerValue = playerTurn == 1 ? 1 : 2;
                      final opponentValue = playerTurn == 1 ? 2 : 1;

                      for (final index in indexes) {
                        if (cardPlayed.$2) {
                          updatedTable[index] = playerValue;
                        } else if (updatedTable[index] == opponentValue) {
                          updatedTable[index] = 0;
                        }
                      }

                      setState(() {
                        validMove = false;
                        playerTurn = playerTurn == 1 ? 2 : 1;
                        table = updatedTable;
                        grid = buildGrid(table!);
                      });
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7AD475),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Confirm move", style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
