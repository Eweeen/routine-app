import 'dart:math';
import 'package:flutter/material.dart';
import 'package:routine_app/db/database.dart';

import '../utils/notificationsHelper.dart';

class RoutineProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _routines = [];
  bool _isLoading = true; // Indicateur de chargement

  List<Map<String, dynamic>> get routines => _routines;

  bool get isLoading => _isLoading;

  Future<void> loadRoutines() async {
    _isLoading = true; // Début du chargement
    notifyListeners();

    final dbHelper = DatabaseHelper.instance;
    final data = await dbHelper.getRoutines();

    _routines.clear();
    _routines.addAll(data.toList());
    notifyListeners();
  }

  Future<void> loadRoutinesByDate(DateTime date) async {
    final dbHelper = DatabaseHelper.instance;

    // Récupérer les routines correspondant à la date
    final data = await dbHelper.getRoutinesByDate(date);

    // Mettre à jour les routines dans l'état
    _routines.clear();
    _routines.addAll(data.toList());
    notifyListeners();
  }

  Future<void> addRoutine(Map<String, dynamic> routine) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insertRoutine(routine);
    await loadRoutines();

    // Planifier une notification
    if (routine['frequency'] != null) {
      final startDate = DateTime.parse(routine['startDate']);
      final alertDate = DateTime(startDate.year, startDate.month, startDate.day, 12); // Toujours à 12h

      await scheduleRoutineNotification(
        id: Random().nextInt(100000), // ID unique
        title: 'Routine "${routine['name']}"',
        body: 'Ta routine "${routine['name']}" t’attend à 12h !',
        frequency: routine['frequency'],
        startDate: alertDate,
      );
    }
  }

  Future<void> updateRoutine(int id, Map<String, dynamic> routine) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateRoutine(id, routine);
    await loadRoutines();

    // Replanifier la notification si la routine est modifiée
    if (routine['frequency'] != null) {
      final startDate = DateTime.parse(routine['startDate']);
      final alertDate = DateTime(startDate.year, startDate.month, startDate.day, 12); // Toujours à 12h

      await scheduleRoutineNotification(
        id: id,
        title: 'Routine "${routine['name']}" mise à jour',
        body: 'Ta routine "${routine['name']}" est prête à 12h !',
        frequency: routine['frequency'],
        startDate: alertDate,
      );
    }
  }

  Future<void> deleteRoutine(int id) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteRoutine(id);
    await loadRoutines();

  }

  Future<void> deleteAllRoutines() async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteAllRoutines();
    await loadRoutines();
  }
}
