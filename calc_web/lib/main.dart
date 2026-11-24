import 'package:material_ui/material_ui.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';
import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final settings = AppSettings();
  await settings.load();
  runApp(CalcApp(settings: settings));
}

class CalcApp extends StatelessWidget {
  final AppSettings settings;
  final GoRouter? router;
  const CalcApp({super.key, required this.settings, this.router});
  @override
  Widget build(BuildContext context) => SettingsScope(
    settings: settings,
    child: ListenableBuilder(
      listenable: settings,
      builder: (context, _) => MaterialApp.router(
        title: 'Калькулятор и конвертер',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: settings.dark ? ThemeMode.dark : ThemeMode.light,
        routerConfig: router ?? appRouter,
      ),
    ),
  );
}
