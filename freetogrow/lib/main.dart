import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:freetogrow/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ejfymcrbtiwnypyzfdvm.supabase.co',
    publishableKey: 'sb_publishable_3RBpGjsqsKmE2jAlcWeB5Q_o_UY3oId',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: AppRouter.routes);
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
