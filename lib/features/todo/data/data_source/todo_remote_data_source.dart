import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasks/features/todo/data/models/todo_model.dart';

abstract class BaseTodoRemoteDataSource {
  Future<Result<List<TodoModel>, Exception>> getTasks();
  Future<Result<TodoModel, Exception>> getTask(String id);
  Future<Result<Unit, Exception>> createTask(TodoModel task);
  Future<Result<Unit, Exception>> updateTask(TodoModel task);
}

@LazySingleton(as: BaseTodoRemoteDataSource)
class TodoRemoteDataSource implements BaseTodoRemoteDataSource {
  final SupabaseClient _supabase;
  TodoRemoteDataSource(this._supabase);

  @override
  createTask(task) async {
    try {
      final data = <String, dynamic>{
        'title': task.title,
        'description': task.description,
        'is_done': task.isDone ?? false,
      };
      final id = task.id;
      if (id != null && id.isNotEmpty) {
        data['id'] = id;
      }
      await _supabase.from('todos').insert(data);
      return Result.success(unit);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  getTask(String id) async {
    try {
      final response = await _supabase
          .from('todos')
          .select()
          .eq('id', id)
          .single();
      return Result.success(TodoModelMapper.fromMap(response));
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  getTasks() async {
    try {
      final response = await _supabase.from('todos').select();
      return Result.success(
        response.map((e) => TodoModelMapper.fromMap(e)).toList(),
      );
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<Unit, Exception>> updateTask(TodoModel task) async {
    final id = task.id;
    if (id == null) {
      return Result.error(Exception('Task id is required to update'));
    }
    try {
      await _supabase
          .from('todos')
          .update({'is_done': task.isDone ?? false})
          .eq('id', id);
      return Result.success(unit);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }
}
