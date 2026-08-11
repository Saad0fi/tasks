// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'todo_model.dart';

class TodoModelMapper extends ClassMapperBase<TodoModel> {
  TodoModelMapper._();

  static TodoModelMapper? _instance;
  static TodoModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TodoModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TodoModel';

  static String? _$id(TodoModel v) => v.id;
  static const Field<TodoModel, String> _f$id = Field('id', _$id, opt: true);
  static String _$title(TodoModel v) => v.title;
  static const Field<TodoModel, String> _f$title = Field('title', _$title);
  static String? _$description(TodoModel v) => v.description;
  static const Field<TodoModel, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static bool? _$isDone(TodoModel v) => v.isDone;
  static const Field<TodoModel, bool> _f$isDone = Field(
    'isDone',
    _$isDone,
    key: r'is_done',
    opt: true,
  );
  static DateTime? _$createdAt(TodoModel v) => v.createdAt;
  static const Field<TodoModel, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
    opt: true,
  );
  static DateTime? _$updatedAt(TodoModel v) => v.updatedAt;
  static const Field<TodoModel, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
    opt: true,
  );

  @override
  final MappableFields<TodoModel> fields = const {
    #id: _f$id,
    #title: _f$title,
    #description: _f$description,
    #isDone: _f$isDone,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static TodoModel _instantiate(DecodingData data) {
    return TodoModel(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      isDone: data.dec(_f$isDone),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TodoModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TodoModel>(map);
  }

  static TodoModel fromJson(String json) {
    return ensureInitialized().decodeJson<TodoModel>(json);
  }
}

mixin TodoModelMappable {
  String toJson() {
    return TodoModelMapper.ensureInitialized().encodeJson<TodoModel>(
      this as TodoModel,
    );
  }

  Map<String, dynamic> toMap() {
    return TodoModelMapper.ensureInitialized().encodeMap<TodoModel>(
      this as TodoModel,
    );
  }

  TodoModelCopyWith<TodoModel, TodoModel, TodoModel> get copyWith =>
      _TodoModelCopyWithImpl<TodoModel, TodoModel>(
        this as TodoModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TodoModelMapper.ensureInitialized().stringifyValue(
      this as TodoModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return TodoModelMapper.ensureInitialized().equalsValue(
      this as TodoModel,
      other,
    );
  }

  @override
  int get hashCode {
    return TodoModelMapper.ensureInitialized().hashValue(this as TodoModel);
  }
}

extension TodoModelValueCopy<$R, $Out> on ObjectCopyWith<$R, TodoModel, $Out> {
  TodoModelCopyWith<$R, TodoModel, $Out> get $asTodoModel =>
      $base.as((v, t, t2) => _TodoModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TodoModelCopyWith<$R, $In extends TodoModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  TodoModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TodoModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TodoModel, $Out>
    implements TodoModelCopyWith<$R, TodoModel, $Out> {
  _TodoModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TodoModel> $mapper =
      TodoModelMapper.ensureInitialized();
  @override
  $R call({
    Object? id = $none,
    String? title,
    Object? description = $none,
    Object? isDone = $none,
    Object? createdAt = $none,
    Object? updatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (title != null) #title: title,
      if (description != $none) #description: description,
      if (isDone != $none) #isDone: isDone,
      if (createdAt != $none) #createdAt: createdAt,
      if (updatedAt != $none) #updatedAt: updatedAt,
    }),
  );
  @override
  TodoModel $make(CopyWithData data) => TodoModel(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    isDone: data.get(#isDone, or: $value.isDone),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  TodoModelCopyWith<$R2, TodoModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TodoModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

