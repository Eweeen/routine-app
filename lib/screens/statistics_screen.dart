import 'package:flutter/material.dart';
import '../widgets/github_style_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime startDate = DateTime(2020, 1, 1);
  DateTime endDate = DateTime(2025, 12, 31);
  String selectedRoutine = 'Toutes les routines';
  final List<String> routines = ['Toutes les routines', 'Routine Matin', 'Routine Soir'];

  List<Map<String, dynamic>> mockRoutineData = [];

  @override
  void initState() {
    super.initState();
    mockRoutineData = _generateMockData();
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer les données selon la routine sélectionnée
    final filteredData = _filterData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques des Routines'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filtres : Sélection de routine et période

                  DropdownButton<String>(
                    value: selectedRoutine,
                    items: routines.map((routine) {
                      return DropdownMenuItem(
                        value: routine,
                        child: Text(routine),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoutine = value!;
                      });
                    },
                  ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final dateRange = await showDateRangePicker(
                      context: context,
                      initialDateRange: DateTimeRange(start: startDate, end: endDate),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2030),
                    );
                    if (dateRange != null) {
                      setState(() {
                        startDate = dateRange.start;
                        endDate = dateRange.end;
                      });
                    }
                  },
                  child: const Text('Sélectionner une période'),
                ),


            const SizedBox(height: 16),
            // Affichage des routines ou du graphique combiné
            Expanded(
              child: selectedRoutine == 'Toutes les routines'
                  ? ListView.builder(
                itemCount: routines.length - 1, // Ignorer l'option "Toutes les routines"
                itemBuilder: (context, index) {
                  final routineName = routines[index + 1]; // Passer l'index 0
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            routineName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GithubStyleChart(
                            startDate: startDate,
                            endDate: endDate,
                            data: _filterDataForRoutine(routineName),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedRoutine == 'Toutes les routines combinées'
                            ? 'Toutes les routines combinées'
                            : selectedRoutine,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GithubStyleChart(
                        startDate: startDate,
                        endDate: endDate,
                        data: filteredData,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filtrer les données pour la routine sélectionnée ou toutes combinées
  List<Map<String, dynamic>> _filterData() {
    if (selectedRoutine == 'Toutes les routines combinées') {
      // Combiner toutes les routines ensemble
      final combinedData = <DateTime, int>{};
      for (var entry in mockRoutineData) {
        final date = entry['date'] as DateTime;
        final state = entry['state'] as RoutineState;
        combinedData[date] = (combinedData[date] ?? 0) + state.id;
      }

      return combinedData.entries.map((e) {
        return {
          'date': e.key,
          'state': RoutineState(
            id: e.value.clamp(0, 3), // Limiter à un maximum de 3 (plus foncé)
            label: 'Combiné',
          ),
        };
      }).toList();
    } else if (selectedRoutine == 'Toutes les routines') {
      return mockRoutineData;
    } else {
      return _filterDataForRoutine(selectedRoutine);
    }
  }

  // Filtrer les données pour une routine spécifique
  List<Map<String, dynamic>> _filterDataForRoutine(String routineName) {
    return mockRoutineData.where((entry) {
      return entry['routine'] == routineName;
    }).toList();
  }

  // Générer des données fixes pour le test
  List<Map<String, dynamic>> _generateMockData() {
    final List<RoutineState> states = [
      const RoutineState(id: 1, label: 'Faible'),
      const RoutineState(id: 2, label: 'Moyen'),
      const RoutineState(id: 3, label: 'Élevé'),
    ];

    final List<Map<String, dynamic>> data = [];
    final routines = ['Routine Matin', 'Routine Soir'];

    for (int i = 0; i < 365 * 5; i++) {
      final date = DateTime(2020, 1, 1).add(Duration(days: i));
      final randomState = states[i % states.length];
      final routineName = routines[i % routines.length];
      data.add({
        'date': date,
        'state': randomState,
        'routine': routineName,
      });
    }
    return data;
  }
}
