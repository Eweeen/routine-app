import 'package:flutter/material.dart';
import 'package:routine_app/providers/completionProvider.dart';
import 'package:routine_app/providers/routineProvider.dart';
import 'package:routine_app/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'db/database.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialiser la base de données
    await DatabaseHelper.instance.database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoutineProvider()),
        ChangeNotifierProvider(create: (_) => CompletionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routine App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(), // Écran principal
    );
  }
}
