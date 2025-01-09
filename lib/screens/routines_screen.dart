import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/routine_provider.dart';

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
                    subtitle:
                        Text(routine['description'] ?? 'Pas de description'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () {
                            _showRoutineForm(context,
                                routine: routine, isEditing: true);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () {
                            _confirmDelete(
                                context, routine['id'], routineProvider);
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
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Confirmation avant de supprimer une routine
  void _confirmDelete(
      BuildContext context, int id, RoutineProvider routineProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer cette routine ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await routineProvider.deleteRoutine(id);
                Navigator.pop(context);
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Formulaire d'ajout/modification
  void _showRoutineForm(BuildContext context,
      {Map<String, dynamic>? routine, bool isEditing = false}) {
    final routineProvider =
        Provider.of<RoutineProvider>(context, listen: false);

    final nameController = TextEditingController(text: routine?['name'] ?? '');
    final descriptionController =
        TextEditingController(text: routine?['description'] ?? '');
    final iconController =
        TextEditingController(text: routine?['icon'] ?? '🔔');
    final startDateController =
        TextEditingController(text: routine?['startDate'] ?? '');
    final endDateController =
        TextEditingController(text: routine?['endDate'] ?? '');

    int selectedFrequencyId = routine?['frequencyId'] ?? 1;
    int recurrence = routine?['recurrence'] ?? 1;
    List<int> selectedDays = (routine != null && routine['days'] != null)
        ? (routine['days'] as String)
            .split(',')
            .map((e) => int.parse(e))
            .toList()
        : [];

    final daysOfWeek = {
      1: 'Lundi',
      2: 'Mardi',
      3: 'Mercredi',
      4: 'Jeudi',
      5: 'Vendredi',
      6: 'Samedi',
      7: 'Dimanche',
    };

    final frequencies = {
      1: 'Quotidienne',
      2: 'Hebdomadaire',
      3: 'Mensuelle',
      4: 'Annuelle',
      5: 'Une fois',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEditing ? 'Modifier Routine' : 'Nouvelle Routine',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          labelText: 'Nom', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: iconController,
                      decoration: const InputDecoration(
                          labelText: 'Icône', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: startDateController,
                      decoration: const InputDecoration(
                          labelText: 'Date de début',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: endDateController,
                      decoration: const InputDecoration(
                          labelText: 'Date de fin',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: selectedFrequencyId,
                      decoration: const InputDecoration(
                          labelText: 'Fréquence', border: OutlineInputBorder()),
                      items: frequencies.entries
                          .map((entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedFrequencyId = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller:
                          TextEditingController(text: recurrence.toString()),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Récurrence',
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        setModalState(() {
                          recurrence = int.parse(value);
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: daysOfWeek.entries.map((entry) {
                        return ChoiceChip(
                          label: Text(entry.value),
                          selected: selectedDays.contains(entry.key),
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                selectedDays.add(entry.key);
                              } else {
                                selectedDays.remove(entry.key);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            descriptionController.text.isEmpty ||
                            selectedDays.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Veuillez remplir tous les champs obligatoires !'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final newRoutine = {
                          'name': nameController.text,
                          'description': descriptionController.text,
                          'icon': iconController.text,
                          'startDate': startDateController.text,
                          'endDate': endDateController.text.isEmpty
                              ? null
                              : endDateController.text,
                          'alert': null,
                          'frequencyId': selectedFrequencyId,
                          'recurrence': recurrence,
                          'days': selectedDays.join(','),
                        };

                        if (isEditing) {
                          await routineProvider.updateRoutine(
                              routine!['id'], newRoutine);
                        } else {
                          await routineProvider.addRoutine(newRoutine);
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: Text(
                        isEditing ? 'Modifier' : 'Ajouter',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
