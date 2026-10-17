import 'package:flutter/material.dart';
import 'package:freetogrow/Pages/home.dart';

class AppRouter {
  static const String home = "/";

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => HomePage(),
  };
}
