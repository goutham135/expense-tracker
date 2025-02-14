import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListTile(
        title: const Text("Dark Mode"),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (value) {
            ref.read(themeProvider.notifier).toggleTheme();
          },
        ),
      ),
    );
  }
}
