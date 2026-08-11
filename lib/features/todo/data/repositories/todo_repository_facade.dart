import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:tasks/core/client_mode/client_mode.dart';
import 'package:tasks/core/client_mode/client_mode_service.dart';
import 'package:tasks/features/todo/data/repositories/todo_loacl_repository.dart';
import 'package:tasks/features/todo/data/repositories/todo_repository_data.dart';
import 'package:tasks/features/todo/domain/entities/todo_entity.dart';
import 'package:tasks/features/todo/domain/repositories/task_repository_domain.dart';

@LazySingleton(as: TaskRepositoryDomain)
class TodoRepositoryFacade implements TaskRepositoryDomain {
  TodoRepositoryFacade(this._thin, this._thick, this._clientMode);

  final TodoRepositoryData _thin;
  final TodoLocalRepository _thick;
  final ClientModeService _clientMode;

  TaskRepositoryDomain get _active =>
      _clientMode.currentMode == ClientMode.thick ? _thick : _thin;

  @override
  Future<Result<Unit, Exception>> createTask(TodoEntity task) =>
      _active.createTask(task);

  @override
  Future<Result<TodoEntity, Exception>> getTask(String id) =>
      _active.getTask(id);

  @override
  Future<Result<List<TodoEntity>, Exception>> getTasks() => _active.getTasks();

  @override
  Future<Result<Unit, Exception>> updateTask(TodoEntity task) =>
      _active.updateTask(task);
}
