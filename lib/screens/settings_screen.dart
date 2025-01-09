import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/routine_provider.dart';
import '../db/database.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Supprimer toutes les routines'),
            subtitle: const Text('Efface toutes les routines enregistrées'),
            onTap: () async {
              final confirmed = await _showConfirmationDialog(
                context,
                'Supprimer toutes les routines',
                'Êtes-vous sûr de vouloir supprimer toutes les routines ? Cette action est irréversible.',
              );
              if (confirmed) {
                await routineProvider.deleteAllRoutines();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Toutes les routines ont été supprimées'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.teal),
            title: const Text('Afficher le nombre de routines'),
            subtitle: const Text('Voir combien de routines sont enregistrées'),
            onTap: () async {
              final count = routineProvider.routines.length;
              _showInfoDialog(context, 'Nombre de routines', 'Il y a actuellement $count routine(s) enregistrée(s).');
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String title, String message) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Confirmer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
