import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:routine_app/models/frequency/frequency_model.dart';

part 'routine_model.freezed.dart';
part 'routine_model.g.dart';

@freezed
class Routine with _$Routine {
  const factory Routine({
    required int id,
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    required String icon,
    String? description,
    DateTime? alert,
    required Frequency frequency,
    required int recurrence,
    required List<int> days,
  }) = _Routine;

  factory Routine.fromJson(Map<String, dynamic> json) =>
      _$RoutineFromJson(json);
}
