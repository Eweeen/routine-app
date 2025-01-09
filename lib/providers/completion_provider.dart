import 'package:flutter/material.dart';

import '../db/database.dart';

class CompletionProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _completions = [];
  List<Map<String, dynamic>> get completions => _completions;

  Future<void> loadCompletions() async {
    final dbHelper = DatabaseHelper.instance;
    final data = await dbHelper.getCompletions();
    _completions.clear();
    _completions.addAll(data);
    notifyListeners();
  }

  Future<void> addCompletion(Map<String, dynamic> completion) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insertCompletion(completion);
    await loadCompletions();
  }

  Future<void> updateCompletion(int id, Map<String, dynamic> completion) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateCompletion(id, completion);
    await loadCompletions();
  }

  Future<void> deleteCompletion(int id) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteCompletion(id);
    await loadCompletions();
  }
}
