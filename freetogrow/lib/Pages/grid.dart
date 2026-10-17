import 'package:flutter/material.dart';
import '../Widgets/grid_square.dart';
import '../Widgets/tile_card.dart';
import '../globals.dart' as globals;

class GridPage extends StatefulWidget {
  const GridPage ({super.key});

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Player 1", style: TextTheme.of(context).headlineSmall,),
                    Text("Waiting...")
                  ]
                ,),
                Column(
                  children: [
                    Text("Player 2", style: TextTheme.of(context).headlineSmall,),
                    Text("Your turn!")
                  ]
                ,)
              ]
            ,),
          ),
          SizedBox(height: 75,),
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
                    return GridSquare(status: index%4, size: MediaQuery.of(context).size.width);
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
                      return TileCard(num: globals.playerHand![index].$1, type: globals.playerHand![index].$2);
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                      return ColoredBox(color: Colors.grey);
                    }
                   
                  }),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}