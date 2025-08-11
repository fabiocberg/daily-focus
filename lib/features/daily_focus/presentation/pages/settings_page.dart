import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Tema'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(switch (mode) {
                  ThemeMode.system => 'Automático (sistema)',
                  ThemeMode.light => 'Claro',
                  ThemeMode.dark => 'Escuro',
                }),
                const SizedBox(height: 8),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('Auto'),
                      icon: Icon(Icons.brightness_auto),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Claro'),
                      icon: Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Escuro'),
                      icon: Icon(Icons.dark_mode),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (s) {
                    ref.read(themeModeProvider.notifier).state = s.first;
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SwitchListTile.adaptive(
            value: false,
            onChanged: (v) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sync mock em breve')),
              );
            },
            title: const Text('Sincronizar com nuvem (mock)'),
            subtitle: const Text('Demonstração de integração com API'),
          ),
          const Divider(height: 1),
          const AboutListTile(
            applicationName: 'DailyFocus',
            applicationVersion: '1.0.0',
          ),
        ],
      ),
    );
  }
}