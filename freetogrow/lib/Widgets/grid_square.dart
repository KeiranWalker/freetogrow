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
      child: ColoredBox(color : getColour(status))
    );
  }

  dynamic getColour(int number) {
    switch (number) {
      case 0:
        Colors.grey;
        break;
      case 1:
        Colors.green;
        break;
      case 2:
        Colors.orange;
      case 3:
        Colors.pink;
    }
  }
  
}