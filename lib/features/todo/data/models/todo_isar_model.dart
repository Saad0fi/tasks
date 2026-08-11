import 'package:isar_community/isar.dart';
import 'package:tasks/features/todo/domain/entities/todo_entity.dart';
import 'package:uuid/uuid.dart';

part 'todo_isar_model.g.dart';

@collection
class TodoIsarModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  late String title;
  String? description;
  bool isDone = false;
  DateTime? createdAt;
  DateTime? updatedAt;

  bool pendingPush = false;
  DateTime? lastSyncedAt;

  TodoEntity toEntity() {
    return TodoEntity(
      id: uuid,
      title: title,
      description: description,
      isDone: isDone,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static TodoIsarModel fromEntity(TodoEntity entity) {
    final model = TodoIsarModel();

    model.uuid = entity.id ?? Uuid().v4();
    model.title = entity.title;
    model.description = entity.description;
    model.isDone = entity.isDone ?? false;
    model.createdAt = entity.createdAt;
    model.updatedAt = entity.updatedAt;

    return model;
  }
}
