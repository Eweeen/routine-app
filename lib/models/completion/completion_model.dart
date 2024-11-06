import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:routine_app/models/routine/routine_model.dart';
import 'package:routine_app/models/state/state_model.dart';

part 'completion_model.freezed.dart';
part 'completion_model.g.dart';

@freezed
class Completion with _$Completion {
  const factory Completion({
    required int id,
    required State state,
    String? description,
    String? image,
    required Routine routine,
  }) = _Completion;

  factory Completion.fromJson(Map<String, dynamic> json) =>
      _$CompletionFromJson(json);
}
