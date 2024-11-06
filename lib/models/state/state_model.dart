import 'package:freezed_annotation/freezed_annotation.dart';

part 'state_model.freezed.dart';
part 'state_model.g.dart';

@freezed
class State with _$State {
  const factory State({
    required int id,
    required String label,
  }) = _State;

  factory State.fromJson(Map<String, dynamic> json) => _$StateFromJson(json);
}
