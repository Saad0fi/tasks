import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';

import 'package:tasks/features/todo/data/data_source/todo_local_data_source.dart';
import 'package:tasks/features/todo/data/sync/todo_sync_service.dart';
import 'package:tasks/features/todo/domain/entities/todo_entity.dart';
import 'package:tasks/features/todo/domain/repositories/task_repository_domain.dart';

@lazySingleton
class TodoLocalRepository implements TaskRepositoryDomain {
  TodoLocalRepository(this._localDataSource, this._sync);

  final BaseTodoLocalDataSource _localDataSource;
  final TodoSyncService _sync;

  @override
  Future<Result<Unit, Exception>> createTask(TodoEntity task) {
    return _sync.createLocalFirst(task);
  }

  @override
  Future<Result<TodoEntity, Exception>> getTask(String id) async {
    final result = await _localDataSource.getTask(id);
    return result.when(
      (success) {
        return Result.success(success.toEntity());
      },
      (error) {
        return Result.error(error);
      },
    );
  }

  @override
  Future<Result<List<TodoEntity>, Exception>> getTasks() async {
    final result = await _localDataSource.getTasks();
    return result.when(
      (success) {
        return Result.success(success.map((e) => e.toEntity()).toList());
      },
      (error) {
        return Result.error(error);
      },
    );
  }

  @override
  Future<Result<Unit, Exception>> updateTask(TodoEntity task) {
    return _sync.updateLocalFirst(task);
  }
}
