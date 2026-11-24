import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logic/currency.dart';

class AppSettings extends ChangeNotifier {
  final SharedPreferencesAsync storage;
  AppSettings({SharedPreferencesAsync? storage})
    : storage = storage ?? SharedPreferencesAsync();
  bool dark = false;
  String from = 'RUB';
  String to = 'USD';
  String? storageError;
  Future<void> load() async {
    try {
      dark = await storage.getBool('dark') ?? false;
      final pair = await storage.getStringList('currencyPair');
      if (pair != null &&
          pair.length == 2 &&
          pair.every(currencyRates.containsKey)) {
        from = pair[0];
        to = pair[1];
      }
    } catch (_) {
      storageError = 'Не удалось загрузить настройки браузера';
    }
  }

  Future<void> toggleTheme() async {
    dark = !dark;
    notifyListeners();
    await _save(() => storage.setBool('dark', dark));
  }

  Future<void> setPair(String source, String target) async {
    from = source;
    to = target;
    notifyListeners();
    await _save(() => storage.setStringList('currencyPair', [source, target]));
  }

  Future<void> _save(Future<void> Function() write) async {
    try {
      await write();
      storageError = null;
    } catch (_) {
      storageError = 'Настройки не сохранены: хранилище браузера недоступно';
    }
    notifyListeners();
  }
}

class SettingsScope extends InheritedNotifier<AppSettings> {
  const SettingsScope({
    super.key,
    required AppSettings settings,
    required super.child,
  }) : super(notifier: settings);
  static AppSettings of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SettingsScope>()!.notifier!;
}
