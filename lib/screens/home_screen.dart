import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MonthView(
        cellAspectRatio: 1,
      ),
    );
  }
}
