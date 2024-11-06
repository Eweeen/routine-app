import 'package:freezed_annotation/freezed_annotation.dart';

part 'frequency_model.freezed.dart';
part 'frequency_model.g.dart';

@freezed
class Frequency with _$Frequency {
  const factory Frequency({
    required int id,
    required String label,
  }) = _Frequency;

  factory Frequency.fromJson(Map<String, dynamic> json) =>
      _$FrequencyFromJson(json);
}
