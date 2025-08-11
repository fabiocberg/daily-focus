import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/today_controller.dart';
import '../../domain/value_objects/task_title.dart';
import '../../domain/entities/task.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(todayTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyFocus'),
        actions: [
          IconButton(
            tooltip: 'Histórico',
            onPressed: () => context.go('/history'),
            icon: const Icon(Icons.history),
          ),
          IconButton(
            tooltip: 'Configurações',
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'reset') {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Recomeçar dia'),
                    content: const Text('Isso vai limpar as tarefas de hoje.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                      FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmar')),
                    ],
                  ),
                );
                if (ok == true) {
                  await ref.read(todayTasksProvider.notifier).resetDay();
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'reset', child: Text('Recomeçar dia')),
            ],
          )
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (tasks) => tasks.isEmpty ? const _EmptyToday() : _TasksList(tasks: tasks),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    String? errorText;
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text('Nova prioridade'),
              content: TextField(
                controller: controller,
                autofocus: true,
                maxLength: 40,
                decoration: InputDecoration(
                  hintText: 'Ex: Revisar PR #42',
                  errorText: errorText,
                ),
                onSubmitted: (_) => _submit(ctx, ref, controller.text, (e) => setState(() => errorText = e)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => _submit(ctx, ref, controller.text, (e) => setState(() => errorText = e)),
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submit(BuildContext ctx, WidgetRef ref, String raw, void Function(String?) setError) async {
    try {
      final title = TaskTitle.create(raw).value;
      await ref.read(todayTasksProvider.notifier).addTask(title);
      if (ctx.mounted) Navigator.pop(ctx);
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Tarefa adicionada')));
      }
    } on ArgumentError catch (e) {
      setError(e.message);
    } on StateError catch (e) {
      setError(e.message);
    } catch (e) {
      setError('Erro inesperado');
    }
  }
}

class _EmptyToday extends StatelessWidget {
  const _EmptyToday();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 64),
            const SizedBox(height: 12),
            Text(
              'Defina até 3 prioridades para hoje',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Toque em “Adicionar” para começar.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TasksList extends ConsumerWidget {
  const _TasksList({required this.tasks});
  final List<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (_, i) {
        final t = tasks[i];
        return ListTile(
          leading: Checkbox(
            value: t.done,
            onChanged: (_) => ref.read(todayTasksProvider.notifier).toggleTask(t.id),
          ),
          title: Text(
            t.title,
            style: TextStyle(
              decoration: t.done ? TextDecoration.lineThrough : null,
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
    );
  }
}