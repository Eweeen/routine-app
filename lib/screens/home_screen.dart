import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:routine_app/providers/completion_provider.dart';
import 'package:routine_app/widgets/image_picker.dart';
import '../providers/routine_provider.dart';

String formatDate(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les routines une seule fois
    Provider.of<RoutineProvider>(context, listen: false)
        .loadRoutinesByDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutineProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
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
                          icon: const Icon(Icons.assignment_turned_in_outlined,
                              color: Colors.blue),
                          onPressed: () {
                            _showValidTask(context, routine: routine);
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

  void _showRoutineForm(BuildContext context) {
    final routineProvider =
        Provider.of<RoutineProvider>(context, listen: false);

    final nameController = TextEditingController(text: '');
    final descriptionController = TextEditingController(text: '');
    final iconController = TextEditingController(text: '🔔');
    final startDateController = TextEditingController(text: '');
    final endDateController = TextEditingController(text: '');

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
                'Nouvelle Routine',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const ValueKey('name'),
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Nom', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const ValueKey('description'),
                controller: descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const ValueKey('icon'),
                controller: iconController,
                decoration: const InputDecoration(
                    labelText: 'Icône', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              InputDatePickerFormField(
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDate: DateTime.now(),
                onDateSubmitted: (date) {
                  startDateController.text = formatDate(date);
                },
                fieldLabelText: 'Date de début',
              ),
              const SizedBox(height: 16),
              InputDatePickerFormField(
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDate: DateTime.now(),
                onDateSubmitted: (date) {
                  endDateController.text = formatDate(date);
                },
                fieldLabelText: 'Date de fin',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final newRoutine = {
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'icon': iconController.text,
                    'startDate': startDateController.text,
                    'endDate': endDateController.text.isEmpty
                        ? null
                        : endDateController.text,
                    'alert': null,
                    'frequencyId': 1,
                    'recurrence': 1,
                    'days': '1,2,3,4,5',
                  };

                  await routineProvider.addRoutine(newRoutine);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text('Ajouter'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showValidTask(BuildContext context,
      {required Map<String, dynamic> routine}) {
    final completionProvider =
        Provider.of<CompletionProvider>(context, listen: false);

    int selectedState = 1; // Par défaut : Non Complété
    final descriptionController = TextEditingController(text: '');
    final routineId = routine['id'];
    File? selectedImage;

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Valider la routine : ${routine['name']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),
                  // Boutons radios pour choisir le statut
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statut de la complétion',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      RadioListTile<int>(
                        title: const Text('Non Complété'),
                        value: 1,
                        groupValue: selectedState,
                        onChanged: (value) {
                          setModalState(() {
                            selectedState = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        title: const Text('Partiellement Complété'),
                        value: 2,
                        groupValue: selectedState,
                        onChanged: (value) {
                          setModalState(() {
                            selectedState = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        title: const Text('Complété'),
                        value: 3,
                        groupValue: selectedState,
                        onChanged: (value) {
                          setModalState(() {
                            selectedState = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Champs pour l'état et la description
                  TextField(
                    key: const ValueKey('description'),
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Description', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  // Afficher l'image sélectionnée
                  if (selectedImage != null)
                    Image.file(
                      File(selectedImage!.path),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 16),
                  // Boutons pour prendre une photo
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Prendre une photo'),
                    onTap: () async {
                      final picker = CompletionImagePicker();
                      final image = await picker.pickImage(ImageSource.camera);
                      if (image != null) {
                        setModalState(() {
                          selectedImage = image;
                        });
                      }
                    },
                  ),
                  // Boutons pour choisir une image depuis la galerie
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Choisir depuis la galerie'),
                    onTap: () async {
                      final picker = CompletionImagePicker();
                      final image = await picker.pickImage(ImageSource.gallery);
                      if (image != null) {
                        setModalState(() {
                          selectedImage = image;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final newCompletion = {
                        'stateId': selectedState,
                        'description': descriptionController.text,
                        'image': selectedImage
                            ?.path, // Enregistrer le chemin de l'image
                        'routineId': routineId,
                        'date': formatDate(DateTime.now()),
                      };

                      // Ajouter la complétion
                      await completionProvider.addCompletion(newCompletion);

                      // Recharger les routines après la complétion
                      await Provider.of<RoutineProvider>(context, listen: false)
                          .loadRoutinesByDate(DateTime.now());

                      // Fermer la modal
                      Navigator.pop(context);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: const Text('Valider'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
