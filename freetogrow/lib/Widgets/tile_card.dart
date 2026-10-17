import 'package:flutter/material.dart';

class TileCard extends StatelessWidget {
  final int num;
  final bool type; // false - neg & true is positive

  const TileCard({super.key, required this.num, required this.type});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/shape-$num-${type ? 'plus' : 'neg'}.png');
  }
}
