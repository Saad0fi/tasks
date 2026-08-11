import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks/core/client_mode/client_mode.dart';
import 'package:tasks/core/client_mode/client_mode_service.dart';
import 'package:tasks/core/user_facing_error.dart';
import 'package:tasks/features/todo/data/sync/todo_sync_service.dart';
import 'package:tasks/features/todo/domain/entities/todo_entity.dart';
import 'package:tasks/features/todo/domain/use_cases/todos_use_case.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodosUseCase _todosUseCase;
  final ClientModeService _clientMode;
  final TodoSyncService _syncService;

  TodoBloc(this._todosUseCase, this._clientMode, this._syncService)
    : super(TodoInitial(clientMode: _clientMode.currentMode)) {
    on<GetTodosEvent>((event, emit) async {
      final mode = _clientMode.currentMode;
      if (event.showLoading) {
        emit(TodoLoading(clientMode: mode));
      }
      await _syncService.pushPendingToRemote();
      final result = await _todosUseCase.getTasks();
      result.when(
        (success) {
          emit(TodoLoaded(todos: success, clientMode: _clientMode.currentMode));
        },
        (whenError) {
          emit(
            TodoError(
              error: userFacingErrorMessage(whenError),
              clientMode: _clientMode.currentMode,
            ),
          );
        },
      );
    });

    on<SetClientModeEvent>((event, emit) {
      _clientMode.setMode(event.mode);

      // نغير الحالة فوراً إلى Loading مع نمط العميل الجديد
      emit(TodoLoading(clientMode: event.mode));

      // ثم نستدعي جلب البيانات (ونخليها false لأننا أطلقنا الـ Loading خلاص)
      add(const GetTodosEvent(showLoading: false));
    });

    on<ToggleTodoDoneEvent>((event, emit) async {
      final id = event.todo.id;
      if (id == null) return;

      final updated = TodoEntity(
        id: event.todo.id,
        title: event.todo.title,
        description: event.todo.description,
        isDone: event.isDone,
        createdAt: event.todo.createdAt,
        updatedAt: event.todo.updatedAt,
      );

      final result = await _todosUseCase.updateTask(updated);
      result.when(
        (_) => add(const GetTodosEvent(showLoading: false)),
        (whenError) => emit(
          TodoError(
            error: userFacingErrorMessage(whenError),
            clientMode: _clientMode.currentMode,
          ),
        ),
      );
    });

    on<CreateTodoEvent>((event, emit) async {
      emit(TodoLoading(clientMode: _clientMode.currentMode));
      final result = await _todosUseCase.createTask(
        TodoEntity(title: event.title),
      );
      result.when((_) => add(const GetTodosEvent(showLoading: false)), (
        whenError,
      ) {
        emit(
          TodoError(
            error: userFacingErrorMessage(whenError),
            clientMode: _clientMode.currentMode,
          ),
        );
      });
    });
  }
}
