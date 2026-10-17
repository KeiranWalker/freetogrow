import 'package:flutter/material.dart';
import 'package:freetogrow/Pages/home.dart';
import 'package:freetogrow/Pages/grid.dart';

class AppRouter {
  static const String home = "/";
  static const String grid = "/grid";

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => HomePage(),
    grid: (context) => GridPage(),
  };
}
