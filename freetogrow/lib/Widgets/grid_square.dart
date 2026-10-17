import 'package:flutter/material.dart';


class GridSquare extends StatelessWidget {
  final int status;
  final double size;

  const GridSquare({
    required this.status, 
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration : BoxDecoration(
          color: getColour(status), 
          border: Border.all(width: 0.3)
        )
      )
    );
  }

  dynamic getColour(int number) {
    switch (number) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.pink;
      default:
        return  Colors.black;
    }
  }
  
}