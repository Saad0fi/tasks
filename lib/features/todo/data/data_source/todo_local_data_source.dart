import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:tasks/features/todo/data/models/todo_isar_model.dart';

abstract class BaseTodoLocalDataSource {
  Future<Result<Unit, Exception>> createTask(TodoIsarModel task);
  Future<Result<TodoIsarModel, Exception>> getTask(String id);
  Future<Result<List<TodoIsarModel>, Exception>> getTasks();
  Future<Result<Unit, Exception>> updateTask(TodoIsarModel task);

  /// Replaces/merges rows from server by [TodoIsarModel.uuid] (server wins).
  Future<Result<Unit, Exception>> upsertAllFromRemote(
    List<TodoIsarModel> tasks,
  );

  Future<Result<List<TodoIsarModel>, Exception>> getPendingPushTasks();

  Future<Result<Unit, Exception>> clearAll();
}

@LazySingleton(as: BaseTodoLocalDataSource)
class TodoLocalDataSource implements BaseTodoLocalDataSource {
  final Isar _isar;
  TodoLocalDataSource(this._isar);

  @override
  Future<Result<Unit, Exception>> createTask(TodoIsarModel task) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.todoIsarModels.put(task);
      });
      return Result.success(unit);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<TodoIsarModel, Exception>> getTask(String id) async {
    try {
      final task = await _isar.todoIsarModels.getByUuid(id);
      if (task == null) {
        return Result.error(Exception('Task not found'));
      }
      return Result.success(task);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<List<TodoIsarModel>, Exception>> getTasks() async {
    try {
      final tasks = await _isar.todoIsarModels.where().findAll();
      return Result.success(tasks);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<Unit, Exception>> updateTask(TodoIsarModel task) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.todoIsarModels.put(task);
      });
      return Result.success(unit);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<Unit, Exception>> upsertAllFromRemote(
    List<TodoIsarModel> tasks,
  ) async {
    try {
      await _isar.writeTxn(() async {
        for (final t in tasks) {
          await _isar.todoIsarModels.put(t);
        }
      });
      return Result.success(unit);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<List<TodoIsarModel>, Exception>> getPendingPushTasks() async {
    try {
      final tasks = await _isar.todoIsarModels
          .filter()
          .pendingPushEqualTo(true)
          .findAll();
      return Result.success(tasks);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<Unit, Exception>> clearAll() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.todoIsarModels.clear();
      });
      return Result.success(unit);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }
}
