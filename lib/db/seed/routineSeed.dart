import '../../models/frequency/frequency_model.dart';
import '../../models/routine/routine_model.dart';

class RoutineFaker {
  // Générer une liste de routines factices
  List<Routine> generateFakeRoutines(int count) {
    final icons = ['☀️', '🌙', '📚', '🏋️‍♀️', '💻'];
    final frequencies = [
      Frequency(id: 1, label: 'Quotidienne'),
      Frequency(id: 2, label: 'Hebdomadaire'),
      Frequency(id: 3, label: 'Mensuelle'),
      Frequency(id: 4, label: 'Annuelle'),
      Frequency(id: 5, label: 'Une fois'),
    ];

    return List.generate(count, (index) {
      return Routine(
        id: DateTime.now().millisecondsSinceEpoch + index, // Générer un ID unique basé sur l'heure actuelle
        name: 'Routine ${index + 1}',
        startDate: DateTime.now().subtract(Duration(days: index * 10)),
        endDate: DateTime.now().add(Duration(days: (index + 1) * 10)),
        icon: icons[index % icons.length],
        description: 'Description de la routine ${index + 1}',
        alert: null,
        frequency: frequencies[index % frequencies.length],
        recurrence: (index % 5) + 1,
        days: [1, 2, 3, 4, 5, 6, 7].take((index % 7) + 1).toList(),
      );
    });
  }
}
