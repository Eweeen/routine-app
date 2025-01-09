import 'dart:math';
import 'package:flutter/material.dart';
import 'package:routine_app/db/database.dart';

import '../utils/notificationsHelper.dart';

class RoutineProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _routines = [];
  List<Map<String, dynamic>> get routines => _routines;

  Future<void> loadRoutines() async {
    final dbHelper = DatabaseHelper.instance;
    final data = await dbHelper.getRoutines();

    _routines.clear();
    _routines.addAll(data.map((routine) {
      return {
        ...routine,
        'date': routine['date'] != null ? DateTime.parse(routine['date']) : null,
      };
    }).toList());
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
}
