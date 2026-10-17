import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('You are a bold one!'))),
    );
  }
}

/*
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
  [1,2,0,0],
  [0,1,2,0],
  [0,0,1,2],
  [2,0,0,1],
  [2,1,0,0],
  [0,2,1,0],
  [0,0,2,1],
  [1,0,0,2],
  [1,0,2,0],
*/