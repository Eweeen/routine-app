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
    Provider.of<RoutineProvider>(context, listen: false).loadRoutines();
  }

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Routines'),
        backgroundColor: Colors.teal,
      ),
      body: routineProvider.routines.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: routineProvider.routines.length,
        itemBuilder: (context, index) {
          final routine = routineProvider.routines[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.withOpacity(0.2),
                child: Text(routine['icon'] ?? '🔔'),
              ),
              title: Text(routine['name']),
              subtitle: Text(routine['description'] ?? 'Pas de description'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _showRoutineForm(context, routine: routine, isEditing: true);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      routineProvider.deleteRoutine(routine['id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showRoutineForm(context);
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showRoutineForm(BuildContext context, {Map<String, dynamic>? routine, bool isEditing = false}) {
    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);

    final nameController = TextEditingController(text: routine?['name'] ?? '');
    final descriptionController = TextEditingController(text: routine?['description'] ?? '');
    final iconController = TextEditingController(text: routine?['icon'] ?? '🔔');
    final startDateController = TextEditingController(text: routine?['startDate'] ?? '');
    final endDateController = TextEditingController(text: routine?['endDate'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Modifier Routine' : 'Nouvelle Routine',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: iconController,
                decoration: const InputDecoration(labelText: 'Icône', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: startDateController,
                decoration: const InputDecoration(labelText: 'Date de début', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: endDateController,
                decoration: const InputDecoration(labelText: 'Date de fin', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final newRoutine = {
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'icon': iconController.text,
                    'startDate': startDateController.text,
                    'endDate': endDateController.text.isEmpty ? null : endDateController.text,
                    'alert': null,
                    'frequencyId': 1,
                    'recurrence': 1,
                    'days': '1,2,3,4,5',
                  };

                  if (isEditing) {
                    await routineProvider.updateRoutine(routine!['id'], newRoutine);
                  } else {
                    await routineProvider.addRoutine(newRoutine);
                  }

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text(isEditing ? 'Modifier' : 'Ajouter'),
              ),
            ],
          ),
        );
      },
    );
  }
}
