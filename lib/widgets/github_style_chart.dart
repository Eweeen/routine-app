import 'package:flutter/material.dart';

class RoutineState {
  final int id;
  final String label;

  const RoutineState({required this.id, required this.label});
}

class GithubStyleChart extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final List<Map<String, dynamic>> data;

  const GithubStyleChart({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Générer tous les jours entre startDate et endDate
    final allDays = _generateDays(startDate, endDate);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Affichage des mois au-dessus
          Row(
            children: _buildMonthLabels(allDays),
          ),
          const SizedBox(height: 8),
          // Graphique principal
          Row(
            children: _buildWeekColumns(allDays),
          ),
        ],
      ),
    );
  }

  // Générer une liste de jours entre deux dates
  List<DateTime> _generateDays(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var currentDate = start;

    while (currentDate.isBefore(end.add(const Duration(days: 1)))) {
      days.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return days;
  }

  // Construire les étiquettes des mois
  List<Widget> _buildMonthLabels(List<DateTime> days) {
    final List<Widget> labels = [];
    DateTime? currentMonth;

    for (final date in days) {
      if (currentMonth == null || date.month != currentMonth.month) {
        labels.add(SizedBox(
          width: (14 + 4) * 7, // Largeur pour une semaine (14px par case + 4px d'espace)
          child: Center(
            child: Text(
              '${_monthName(date.month)} ${date.year}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ));
        currentMonth = date;
      }
    }

    return labels;
  }

  // Construire les colonnes hebdomadaires
  List<Widget> _buildWeekColumns(List<DateTime> days) {
    final List<Widget> columns = [];
    for (int i = 0; i < days.length; i += 7) {
      final weekDays = days.skip(i).take(7).toList();
      columns.add(Column(
        children: weekDays.map((date) {
          // Trouver l'état du jour dans les données
          final dayData = data.firstWhere(
                (d) => d['date'].isAtSameMomentAs(date),
            orElse: () => {'state': RoutineState(id: 0, label: 'Aucune donnée')},
          );

          final state = dayData['state'] as RoutineState;

          return Tooltip(
            message: '${date.day}/${date.month}/${date.year} : ${state.label}',
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              width: 14, // Taille compacte pour les cellules
              height: 14,
              decoration: BoxDecoration(
                color: _colorFromValue(state.id),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }).toList(),
      ));
    }

    return columns;
  }

  // Mapper l'état à une couleur uniforme (style GitHub)
  Color _colorFromValue(int value) {
    switch (value) {
      case 0:
        return const Color(0xFFEBEDF0); // Très clair (vide)
      case 1:
        return const Color(0xFF9BE9A8); // Vert clair
      case 2:
        return const Color(0xFF40C463); // Vert moyen
      case 3:
        return const Color(0xFF30A14E); // Vert foncé
      default:
        return const Color(0xFF216E39); // Très foncé
    }
  }

  // Obtenir le nom du mois
  String _monthName(int month) {
    const months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return months[month - 1];
  }
}
