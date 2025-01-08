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
    if (data.isEmpty) {
      return const Center(
        child: Text('Aucune donnée à afficher'),
      );
    }

    final days = _generateDays(startDate, endDate);
    final indexedData = _indexData(data);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: CustomPaint(
        painter: GithubChartPainter(days, indexedData),
        size: Size((days.length / 7 * 18).toDouble(), 120),
      ),
    );
  }

  List<DateTime> _generateDays(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var currentDate = start;

    while (currentDate.isBefore(end.add(const Duration(days: 1)))) {
      days.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return days;
  }

  Map<DateTime, RoutineState> _indexData(List<Map<String, dynamic>> data) {
    final index = <DateTime, RoutineState>{};
    for (var entry in data) {
      final date = entry['date'] as DateTime?;
      final state = entry['state'] as RoutineState?;
      if (date != null && state != null) {
        index[date] = state;
      }
    }
    return index;
  }
}

class GithubChartPainter extends CustomPainter {
  final List<DateTime> days;
  final Map<DateTime, RoutineState> indexedData;

  GithubChartPainter(this.days, this.indexedData);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final cellSize = 14.0;
    final gap = 4.0;

    for (int i = 0; i < days.length; i++) {
      final x = (i ~/ 7) * (cellSize + gap);
      final y = (i % 7) * (cellSize + gap);

      final date = days[i];
      final state = indexedData[date] ?? RoutineState(id: 0, label: 'Aucune donnée');
      paint.color = _colorFromValue(state.id);

      canvas.drawRect(
        Rect.fromLTWH(x.toDouble(), y.toDouble(), cellSize, cellSize),
        paint,
      );
    }
  }

  Color _colorFromValue(int value) {
    switch (value) {
      case 0:
        return const Color(0xFFEBEDF0);
      case 1:
        return const Color(0xFF9BE9A8);
      case 2:
        return const Color(0xFF40C463);
      case 3:
        return const Color(0xFF30A14E);
      default:
        return const Color(0xFF216E39);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
