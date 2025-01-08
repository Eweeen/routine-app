import 'package:flutter/material.dart';
import 'package:routine_app/providers/completionProvider.dart';
import 'package:routine_app/providers/routineProvider.dart';
import 'package:routine_app/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'db/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assure l'initialisation

  final dbHelper = DatabaseHelper.instance;

  // Faker : Insérer des routines dans la base de données
  await dbHelper.insertFakeRoutines(10);
  final routines = await dbHelper.getRoutines();
  for (final routine in routines) {
    print(routine);
  }
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
