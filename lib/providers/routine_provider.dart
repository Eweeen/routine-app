import 'package:flutter/material.dart';
import '../db/database.dart';

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

  Future<void> deleteAllRoutines() async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteAllRoutines();
    await loadRoutines();
  }
}
