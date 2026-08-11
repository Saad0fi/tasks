import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/core/client_mode/client_mode.dart';
import 'package:tasks/core/client_mode/client_mode_service.dart';
import 'package:tasks/core/di.dart';
import 'package:tasks/features/todo/data/sync/todo_sync_service.dart';
import 'package:tasks/features/todo/domain/entities/todo_entity.dart';
import 'package:tasks/features/todo/domain/use_cases/todos_use_case.dart';
import 'package:tasks/features/todo/presentation/bloc/todo_bloc.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  void _showAddTodoDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('إضافة مهمة'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(labelText: 'المهمة'),
            onSubmitted: (_) {
              final title = controller.text.trim();
              if (title.isEmpty) return;
              context.read<TodoBloc>().add(CreateTodoEvent(title));
              Navigator.pop(dialogContext);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                final title = controller.text.trim();
                if (title.isEmpty) return;
                context.read<TodoBloc>().add(CreateTodoEvent(title));
                Navigator.pop(dialogContext);
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(
        getIt<TodosUseCase>(),
        getIt<ClientModeService>(),
        getIt<TodoSyncService>(),
      )..add(const GetTodosEvent()),
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final isThick = state.clientMode == ClientMode.thick;

          return Scaffold(
            appBar: AppBar(
              title: const Text('المهام'),
              actions: [
                Tooltip(
                  message: isThick
                      ? 'محلي (Isar) — اضغط لاستخدام السحابة'
                      : 'سحابة (Supabase) — اضغط لاستخدام المحلي',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isThick ? 'محلي' : 'سحابة',
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(width: 8),
                        Switch.adaptive(
                          value: isThick,
                          onChanged: (thick) {
                            context.read<TodoBloc>().add(
                              SetClientModeEvent(
                                thick ? ClientMode.thick : ClientMode.thin,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showAddTodoDialog(context),
                  icon: const Icon(Icons.add),
                  tooltip: 'إضافة مهمة',
                ),
              ],
            ),
            body: switch (state) {
              TodoInitial() || TodoLoading() => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              TodoError(:final error) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        error,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () =>
                            context.read<TodoBloc>().add(const GetTodosEvent()),
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              ),
              TodoLoaded(:final todos) when todos.isEmpty => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 64,
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.45,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('لا توجد مهام', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'اضغط + لإضافة مهمة',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TodoLoaded(:final todos) => RefreshIndicator(
                onRefresh: () async {
                  context.read<TodoBloc>().add(
                    const GetTodosEvent(showLoading: false),
                  );
                  await context.read<TodoBloc>().stream.firstWhere(
                    (s) => s is TodoLoaded || s is TodoError,
                  );
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: todos.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _TodoCard(todo: todos[index]);
                  },
                ),
              ),
            },
          );
        },
      ),
    );
  }
}

class _TodoCard extends StatelessWidget {
  const _TodoCard({required this.todo});

  final TodoEntity todo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = todo.isDone ?? false;
    final id = todo.id;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isDone ? 0 : 1,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDone
              ? theme.colorScheme.outline.withValues(alpha: 0.22)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      color: isDone
          ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.65)
          : theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 10, 14, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox.adaptive(
              value: isDone,
              onChanged: id == null
                  ? null
                  : (value) {
                      if (value == null) return;
                      context.read<TodoBloc>().add(
                        ToggleTodoDoneEvent(todo: todo, isDone: value),
                      );
                    },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    todo.title,
                    textAlign: TextAlign.start,
                    style: theme.textTheme.titleMedium?.copyWith(
                      height: 1.25,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      decorationColor: theme.colorScheme.onSurfaceVariant,
                      color: isDone
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                      fontWeight: isDone ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
