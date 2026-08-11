import 'package:multiple_result/multiple_result.dart';
import 'package:tasks/features/todo/domain/entities/todo_entity.dart';
import 'package:tasks/features/todo/domain/repositories/task_repository_domain.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TodosUseCase {
  final TaskRepositoryDomain _taskRepositoryDomain;

  TodosUseCase(this._taskRepositoryDomain);

  Future<Result<List<TodoEntity>, Exception>> getTasks() async {
    return _taskRepositoryDomain.getTasks();
  }

  Future<Result<Unit, Exception>> createTask(TodoEntity task) async {
    return _taskRepositoryDomain.createTask(task);
  }

  Future<Result<Unit, Exception>> updateTask(TodoEntity task) async {
    return _taskRepositoryDomain.updateTask(task);
  }
}
