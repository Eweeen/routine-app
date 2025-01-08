import 'package:flutter/material.dart';
import '../db/database.dart';

class RoutineProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _routines = [];
  List<Map<String, dynamic>> get routines => _routines;

  Future<void> loadRoutines() async {
    final dbHelper = DatabaseHelper.instance;
    final data = await dbHelper.getRoutines();
    print('Routines récupérées : $data'); // Vérifiez les données ici
    _routines.clear();
    _routines.addAll(data);
    notifyListeners();
  }


  Future<void> addRoutine(Map<String, dynamic> routine) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insertRoutine(routine);
    await loadRoutines();
  }

  Future<void> updateRoutine(int id, Map<String, dynamic> routine) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateRoutine(id, routine);
    await loadRoutines();
  }

  Future<void> deleteRoutine(int id) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteRoutine(id);
    await loadRoutines();
  }
}
