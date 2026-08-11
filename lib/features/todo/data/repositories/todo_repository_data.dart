import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:tasks/features/todo/data/data_source/todo_remote_data_source.dart';
import 'package:tasks/features/todo/data/models/todo_model.dart';
import 'package:tasks/features/todo/data/sync/todo_sync_service.dart';
import 'package:tasks/features/todo/domain/entities/todo_entity.dart';
import 'package:tasks/features/todo/domain/repositories/task_repository_domain.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class TodoRepositoryData implements TaskRepositoryDomain {
  TodoRepositoryData(this.remoteDataSource, this._sync);

  final BaseTodoRemoteDataSource remoteDataSource;
  final TodoSyncService _sync;

  @override
  Future<Result<Unit, Exception>> createTask(TodoEntity task) async {
    final now = DateTime.now();
    final withId = TodoEntity(
      id: task.id ?? const Uuid().v4(),
      title: task.title,
      description: task.description,
      isDone: task.isDone ?? false,
      createdAt: task.createdAt ?? now,
      updatedAt: task.updatedAt ?? now,
    );
    final model = TodoModel(
      id: withId.id,
      title: withId.title,
      description: withId.description,
      isDone: withId.isDone,
      createdAt: withId.createdAt,
      updatedAt: withId.updatedAt,
    );
    final result = await remoteDataSource.createTask(model);
    return result.when((_) async {
      await _sync.upsertToLocal(withId);
      return Result.success(unit);
    }, Result.error);
  }

  @override
  Future<Result<TodoEntity, Exception>> getTask(String id) {
    return remoteDataSource.getTask(id);
  }

  @override
  Future<Result<List<TodoEntity>, Exception>> getTasks() {
    return remoteDataSource.getTasks();
  }

  @override
  Future<Result<Unit, Exception>> updateTask(TodoEntity task) async {
    final model = TodoModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isDone: task.isDone,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
    final result = await remoteDataSource.updateTask(model);
    return result.when((_) async {
      await _sync.upsertToLocal(task);
      return Result.success(unit);
    }, Result.error);
  }
}
