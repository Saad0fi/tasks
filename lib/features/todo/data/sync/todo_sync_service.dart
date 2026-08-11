import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:tasks/features/todo/data/data_source/todo_local_data_source.dart';
import 'package:tasks/features/todo/data/data_source/todo_remote_data_source.dart';
import 'package:tasks/features/todo/data/models/todo_isar_model.dart';
import 'package:tasks/features/todo/data/models/todo_model.dart';
import 'package:tasks/features/todo/domain/entities/todo_entity.dart';
import 'package:uuid/uuid.dart';

/// Pulls remote todos into Isar and pushes local writes when online.
@lazySingleton
class TodoSyncService {
  TodoSyncService(this._remote, this._local);

  final BaseTodoRemoteDataSource _remote;
  final BaseTodoLocalDataSource _local;

  /// Wipes Isar todos. Does not delete cloud data.
  Future<Result<Unit, Exception>> clearLocal() => _local.clearAll();

  /// Retries local rows that failed to reach the server (e.g. created offline).
  Future<void> pushPendingToRemote() async {
    final result = await _local.getPendingPushTasks();
    if (!result.isSuccess()) return;

    final pending = result.tryGetSuccess();
    if (pending == null || pending.isEmpty) return;

    for (final model in pending) {
      final entity = model.toEntity();
      if (model.lastSyncedAt == null) {
        await _tryPushCreate(entity, model);
      } else {
        await _tryPushUpdate(entity, model);
      }
    }
  }

  /// Best-effort: if the network fails, returns without throwing (local DB unchanged).
  Future<void> pullRemoteIntoLocal() async {
    final result = await _remote.getTasks();
    if (!result.isSuccess()) return;

    final models = result.tryGetSuccess();
    if (models == null) return;

    final batch = <TodoIsarModel>[];
    for (final m in models) {
      final id = m.id;
      if (id == null || id.isEmpty) continue;
      final row = TodoIsarModel.fromEntity(
        TodoEntity(
          id: m.id,
          title: m.title,
          description: m.description,
          isDone: m.isDone,
          createdAt: m.createdAt,
          updatedAt: m.updatedAt,
        ),
      );
      row.pendingPush = false;
      row.lastSyncedAt = DateTime.now();
      batch.add(row);
    }

    await _local.upsertAllFromRemote(batch);
  }

  /// Keeps Isar in sync after a successful cloud write (create/update).
  Future<void> upsertToLocal(TodoEntity entity) async {
    final id = entity.id;
    if (id == null || id.isEmpty) return;

    final row = TodoIsarModel.fromEntity(entity);
    row.pendingPush = false;
    row.lastSyncedAt = DateTime.now();
    await _local.upsertAllFromRemote([row]);
  }

  /// Local-first create; pushes to remote when online (local row kept if push fails).
  Future<Result<Unit, Exception>> createLocalFirst(TodoEntity task) async {
    final entity = _withIdAndTimestamps(task);
    final model = TodoIsarModel.fromEntity(entity)..pendingPush = true;

    final localResult = await _local.createTask(model);
    return localResult.when((_) async {
      await _tryPushCreate(entity, model);
      return Result.success(unit);
    }, Result.error);
  }

  /// Local-first update; pushes to remote when online.
  Future<Result<Unit, Exception>> updateLocalFirst(TodoEntity task) async {
    final id = task.id;
    if (id == null || id.isEmpty) {
      return Result.error(Exception('Task id is required to update'));
    }

    final entity = TodoEntity(
      id: id,
      title: task.title,
      description: task.description,
      isDone: task.isDone ?? false,
      createdAt: task.createdAt,
      updatedAt: DateTime.now(),
    );
    final model = TodoIsarModel.fromEntity(entity)..pendingPush = true;

    final localResult = await _local.updateTask(model);
    return localResult.when((_) async {
      await _tryPushUpdate(entity, model);
      return Result.success(unit);
    }, Result.error);
  }

  Future<void> _tryPushCreate(TodoEntity entity, TodoIsarModel model) async {
    final remote = await _remote.createTask(_toModel(entity));
    if (!remote.isSuccess()) return;

    model.pendingPush = false;
    model.lastSyncedAt = DateTime.now();
    await _local.updateTask(model);
  }

  Future<void> _tryPushUpdate(TodoEntity entity, TodoIsarModel model) async {
    final remote = await _remote.updateTask(_toModel(entity));
    if (!remote.isSuccess()) return;

    model.pendingPush = false;
    model.lastSyncedAt = DateTime.now();
    await _local.updateTask(model);
  }

  TodoEntity _withIdAndTimestamps(TodoEntity task) {
    final now = DateTime.now();
    return TodoEntity(
      id: task.id ?? const Uuid().v4(),
      title: task.title,
      description: task.description,
      isDone: task.isDone ?? false,
      createdAt: task.createdAt ?? now,
      updatedAt: task.updatedAt ?? now,
    );
  }

  TodoModel _toModel(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isDone: entity.isDone,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
