part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState({required this.clientMode});

  final ClientMode clientMode;

  @override
  List<Object?> get props => [clientMode];
}

final class TodoInitial extends TodoState {
  const TodoInitial({super.clientMode = ClientMode.thin});
}

final class TodoLoading extends TodoState {
  const TodoLoading({required super.clientMode});
}

final class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;

  const TodoLoaded({required this.todos, required super.clientMode});

  @override
  List<Object?> get props => [todos, clientMode];
}

final class TodoError extends TodoState {
  final String error;

  const TodoError({required this.error, required super.clientMode});

  @override
  List<Object?> get props => [error, clientMode];
}
