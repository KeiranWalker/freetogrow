import 'package:flutter/material.dart';
import '../Objects/turn_handler.dart';

class GridSquare extends StatefulWidget {
  final int status;
  final double size;
  final List<int> boardState;
  final int index;
  final int myPlayerNumber;
  final Function(int, (int, bool)) validMoveCallback;

  const GridSquare({
    super.key,
    required this.status, 
    required this.size,
    required this.boardState,
    required this.index,
    required this.myPlayerNumber,
    required this.validMoveCallback,
  });

  @override
  State<GridSquare> createState() => _GridSquareState();
}

class _GridSquareState extends State<GridSquare>{
  var shapeList = [[0,0,0,0],
                  [1,0,0,0],
                  [0,1,0,0],
                  [1,0,1,0],
                  [0,1,0,1],
                  [0,1,1,0],
                  [1,1,0,0],
                  [0,0,1,1],
                  [1,0,0,1],
                  [1,0,1,1],
                  [1,1,0,1],
                  [1,1,1,0],
                  [0,1,1,1],
                  [0,1,0,2],
                  [1,0,2,0]];

  double opacity = 1;

  bool isAdjacentToPlayerSquare(int index) {
    for (var neighbour in [index + 1, index - 1, index + 8, index - 8]) {
      if (neighbour >= 0 && neighbour <= 63 && widget.boardState[neighbour] == widget.myPlayerNumber) {
        return true;
      }
    }
    return false;
  }

  bool willOverflow(int index, int shape) {
    int shapeWidth = shapeList[shape][0] + shapeList[shape][2] + 1;
    if (shapeWidth + index%8 > 8) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<(int, bool)>(
      builder: (context, candidateItems, rejectedItems) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Opacity(
            opacity: opacity,
            child: DecoratedBox(
              decoration : BoxDecoration(
                color: getColour(widget.status), 
                border: Border.all(width: 0.3)
              )
            ),
          )
        );
      },
      onAcceptWithDetails: (details) {
        int num = details.data.$1;
        bool type = details.data.$2;
        setState(() {
          opacity = 1;
          if (type) {
            if (widget.status == 1 || widget.status == 2 || willOverflow(widget.index, num)) {
              return;
            } else {
              List<int> cardIndexes = getCardIndexes(widget.index, num);
              bool isAdjacentToPlayer = false;
              for (var index in cardIndexes) {
                if (index < 0 || index > 63 || widget.boardState[index] == 1 || widget.boardState[index] == 2 || willOverflow(index, num)) {
                  return;
                } else if (isAdjacentToPlayerSquare(index)) {
                    isAdjacentToPlayer = true;
                }
              }
              if (isAdjacentToPlayer) {
                widget.validMoveCallback(widget.index, details.data);
              }
            }
          } else {
            List<int> cardIndexes = getCardIndexes(widget.index, details.data.$1);
            if (willOverflow(widget.index, num)) {
              return;
            } else {
              for (var index in cardIndexes) {
                if (index < 0 || index > 63) {
                  return;
                }
              }
            }
            widget.validMoveCallback(widget.index, details.data);
          }
        });
      }, 
      onMove: (details) {
        setState(() {
          opacity = 0.5;
        });
      },
      onLeave:(data) {
        setState(() {
          opacity = 1;
        });
      },
    );
  }

  dynamic getColour(int number) {
    switch (number) {
      case 0: //neutral
        return Colors.grey;
      case 1: //claimed by player 1
        return Colors.green;
      case 2: //claimed by player 2
        return Colors.pink;
      case 3: //flower
        return Colors.blue;
      case 4: //selected
        return Colors.orange;
      default:
        return  Colors.black;
    }
  }
  
}