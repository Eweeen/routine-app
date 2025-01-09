import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/routine_provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RoutineProvider>(context, listen: false).loadRoutines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutineProvider>(context);

    if (routineProvider.routines.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final filteredData = _filterData(routineProvider.routines);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques des Routines'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filtres : Sélection de routine et période
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedRoutine,
                    isExpanded: true,
                    items: [
                      'Toutes les routines',
                      ...routineProvider.routines
                          .map((routine) => routine['name'] as String),
                    ].map((routineName) {
                      return DropdownMenuItem<String>(
                        value: routineName,
                        child: Text(routineName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoutine = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final dateRange = await showDateRangePicker(
                      context: context,
                      initialDateRange:
                          DateTimeRange(start: startDate, end: endDate),
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
                  child: const Text('Période'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Affichage des routines ou du graphique combiné
            Expanded(
              child: selectedRoutine == 'Toutes les routines'
                  ? ListView.builder(
                      itemCount: routineProvider.routines.length,
                      itemBuilder: (context, index) {
                        final routine = routineProvider.routines[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  routine['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GithubStyleChart(
                                  startDate: startDate,
                                  endDate: endDate,
                                  data: _filterDataForRoutine(routine['name'],
                                      routineProvider.routines),
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
                              selectedRoutine,
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

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> routines) {
    if (selectedRoutine == 'Toutes les routines') {
      return routines;
    } else {
      return routines
          .where((routine) => routine['name'] == selectedRoutine)
          .toList();
    }
  }

  List<Map<String, dynamic>> _filterDataForRoutine(
      String routineName, List<Map<String, dynamic>> routines) {
    return routines.where((routine) => routine['name'] == routineName).toList();
  }
}
