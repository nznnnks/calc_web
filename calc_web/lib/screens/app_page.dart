import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../settings.dart';

class AppPage extends StatelessWidget {
  final String title;
  final Widget child;
  final String? backPath;
  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.backPath,
  });
  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: backPath == null
            ? null
            : IconButton(
                tooltip: 'Назад',
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go(backPath!),
              ),
        title: Text(title),
        actions: [
          IconButton(
            tooltip: settings.dark ? 'Светлая тема' : 'Тёмная тема',
            onPressed: settings.toggleTheme,
            icon: Icon(settings.dark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (settings.storageError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        settings.storageError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
