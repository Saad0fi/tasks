import 'package:tasks/features/todo/domain/entities/todo_entity.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class TaskRepositoryDomain {
  Future<Result<List<TodoEntity>, Exception>> getTasks();
  Future<Result<TodoEntity, Exception>> getTask(String id);
  Future<Result<Unit, Exception>> createTask(TodoEntity task);
  Future<Result<Unit, Exception>> updateTask(TodoEntity task);
}
