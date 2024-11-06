// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Completion _$CompletionFromJson(Map<String, dynamic> json) {
  return _Completion.fromJson(json);
}

/// @nodoc
mixin _$Completion {
  int get id => throw _privateConstructorUsedError;
  State get state => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  Routine get routine => throw _privateConstructorUsedError;

  /// Serializes this Completion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Completion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompletionCopyWith<Completion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletionCopyWith<$Res> {
  factory $CompletionCopyWith(
          Completion value, $Res Function(Completion) then) =
      _$CompletionCopyWithImpl<$Res, Completion>;
  @useResult
  $Res call(
      {int id,
      State state,
      String? description,
      String? image,
      Routine routine});

  $StateCopyWith<$Res> get state;
  $RoutineCopyWith<$Res> get routine;
}

/// @nodoc
class _$CompletionCopyWithImpl<$Res, $Val extends Completion>
    implements $CompletionCopyWith<$Res> {
  _$CompletionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Completion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? state = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? routine = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as State,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      routine: null == routine
          ? _value.routine
          : routine // ignore: cast_nullable_to_non_nullable
              as Routine,
    ) as $Val);
  }

  /// Create a copy of Completion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StateCopyWith<$Res> get state {
    return $StateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value) as $Val);
    });
  }

  /// Create a copy of Completion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoutineCopyWith<$Res> get routine {
    return $RoutineCopyWith<$Res>(_value.routine, (value) {
      return _then(_value.copyWith(routine: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompletionImplCopyWith<$Res>
    implements $CompletionCopyWith<$Res> {
  factory _$$CompletionImplCopyWith(
          _$CompletionImpl value, $Res Function(_$CompletionImpl) then) =
      __$$CompletionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      State state,
      String? description,
      String? image,
      Routine routine});

  @override
  $StateCopyWith<$Res> get state;
  @override
  $RoutineCopyWith<$Res> get routine;
}

/// @nodoc
class __$$CompletionImplCopyWithImpl<$Res>
    extends _$CompletionCopyWithImpl<$Res, _$CompletionImpl>
    implements _$$CompletionImplCopyWith<$Res> {
  __$$CompletionImplCopyWithImpl(
      _$CompletionImpl _value, $Res Function(_$CompletionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Completion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? state = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? routine = null,
  }) {
    return _then(_$CompletionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as State,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      routine: null == routine
          ? _value.routine
          : routine // ignore: cast_nullable_to_non_nullable
              as Routine,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompletionImpl implements _Completion {
  const _$CompletionImpl(
      {required this.id,
      required this.state,
      this.description,
      this.image,
      required this.routine});

  factory _$CompletionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompletionImplFromJson(json);

  @override
  final int id;
  @override
  final State state;
  @override
  final String? description;
  @override
  final String? image;
  @override
  final Routine routine;

  @override
  String toString() {
    return 'Completion(id: $id, state: $state, description: $description, image: $image, routine: $routine)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.routine, routine) || other.routine == routine));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, state, description, image, routine);

  /// Create a copy of Completion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletionImplCopyWith<_$CompletionImpl> get copyWith =>
      __$$CompletionImplCopyWithImpl<_$CompletionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompletionImplToJson(
      this,
    );
  }
}

abstract class _Completion implements Completion {
  const factory _Completion(
      {required final int id,
      required final State state,
      final String? description,
      final String? image,
      required final Routine routine}) = _$CompletionImpl;

  factory _Completion.fromJson(Map<String, dynamic> json) =
      _$CompletionImpl.fromJson;

  @override
  int get id;
  @override
  State get state;
  @override
  String? get description;
  @override
  String? get image;
  @override
  Routine get routine;

  /// Create a copy of Completion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletionImplCopyWith<_$CompletionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
