import 'package:flutter/material.dart';
import 'package:routine_app/providers/completion_provider.dart';
import 'package:routine_app/providers/routine_provider.dart';
import 'package:routine_app/screens/main_screen.dart';
import 'package:routine_app/db/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les fuseaux horaires pour les notifications
  tz.initializeTimeZones();

  // Initialiser les notifications
  await initializeNotifications();

  // Demander les autorisations pour iOS
  await requestNotificationPermission();

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
