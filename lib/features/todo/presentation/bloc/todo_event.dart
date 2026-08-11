part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class GetTodosEvent extends TodoEvent {
  /// When false, refresh list without emitting [TodoLoading] (e.g. after toggle).
  final bool showLoading;

  const GetTodosEvent({this.showLoading = true});

  @override
  List<Object> get props => [showLoading];
}

class CreateTodoEvent extends TodoEvent {
  final String title;
  const CreateTodoEvent(this.title);

  @override
  List<Object> get props => [title];
}

class ToggleTodoDoneEvent extends TodoEvent {
  final TodoEntity todo;
  final bool isDone;

  const ToggleTodoDoneEvent({required this.todo, required this.isDone});

  @override
  List<Object> get props => [todo.id ?? '', isDone];
}

class SetClientModeEvent extends TodoEvent {
  final ClientMode mode;

  const SetClientModeEvent(this.mode);

  @override
  List<Object> get props => [mode];
}
