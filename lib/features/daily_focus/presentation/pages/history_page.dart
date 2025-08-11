import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/history_controller.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(historyProvider);
    final df = DateFormat('EEE, dd/MM', 'pt_BR');

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico (7 dias)')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (map) {
          final entries = map.entries.toList()
            ..sort((a, b) => b.key.compareTo(a.key)); // mais recente primeiro
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (_, i) {
              final e = entries[i];
              final done = e.value.where((t) => t.done).length;
              final total = e.value.length;
              final percent = total == 0 ? 0.0 : done / total;
              return ListTile(
                title: Text(df.format(e.key)),
                subtitle: Text('$done/$total concluídas'),
                trailing: SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(value: total == 0 ? null : percent),
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
          );
        },
      ),
    );
  }
}