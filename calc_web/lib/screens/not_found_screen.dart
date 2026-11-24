import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import 'app_page.dart';

class NotFoundScreen extends StatelessWidget {
  final String location;
  const NotFoundScreen({super.key, required this.location});
  @override
  Widget build(BuildContext context) => AppPage(
    title: '404',
    backPath: '/',
    child: Column(
      children: [
        Text(
          'Страница не найдена',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(location),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.go('/'),
          child: const Text('На главную'),
        ),
      ],
    ),
  );
}
