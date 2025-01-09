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
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
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

    int selectedFrequencyId = 1;
    int recurrence = 1;
    List<int> selectedDays = [];

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
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Nouvelle Routine',
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

                        await routineProvider.addRoutine(newRoutine);

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: Text(
                        'Ajouter',
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
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
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
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: Text(
                      'Ajouter',
                      style: const TextStyle(color: Colors.white),
                    ),
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
