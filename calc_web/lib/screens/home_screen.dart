import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import 'app_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Главная',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Вычисляйте и переводите валюты',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        const Text(
          'Выберите инструмент. Результатом можно поделиться по ссылке.',
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => context.go('/calculator'),
          icon: const Icon(Icons.calculate),
          label: const Text('Калькулятор'),
        ),
        const SizedBox(height: 12),
        FilledButton.tonalIcon(
          onPressed: () => context.go('/converter'),
          icon: const Icon(Icons.currency_exchange),
          label: const Text('Конвертер валют'),
        ),
      ],
    ),
  );
}
