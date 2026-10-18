import 'package:flutter/material.dart';

class TileCard extends StatelessWidget {
  final int num;
  final bool type; // false - neg & true is positive

  const TileCard({super.key, required this.num, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 205, 205, 205),
          ),
          child: Column(
            children: [
              SizedBox(height: 25),
              SizedBox(
                width: 80,
                height: 80,
                child: Row(
                  children: [
                    Expanded(child: Image.asset('assets/Shapes/shape-$num-${type ? 'plus' : 'neg'}.png', fit: BoxFit.contain,))
                  ],
                ),
              ),
              SizedBox(height: 25)
            ],
          ),
        ),
      ),
    );
  }
}
