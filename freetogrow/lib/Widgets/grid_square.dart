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
    );
  }
}