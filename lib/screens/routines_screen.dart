import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/routineProvider.dart';
class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les routines une seule fois
    Provider.of<RoutineProvider>(context, listen: false).loadRoutines();
  }

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutineProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Routines')),
      body: routineProvider.routines.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: routineProvider.routines.length,
        itemBuilder: (context, index) {
          final routine = routineProvider.routines[index];
          return ListTile(
            title: Text(routine['name']),
            subtitle: Text(routine['description'] ?? 'Pas de description'),
          );
        },
      ),
    );
  }
}
