import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calc_web/settings.dart';

class MemoryPreferences implements SharedPreferencesAsync {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  final values = <String, Object>{};
  @override
  Future<bool?> getBool(String key) async => values[key] as bool?;
  @override
  Future<List<String>?> getStringList(String key) async =>
      values[key] as List<String>?;
  @override
  Future<void> setBool(String key, bool value) async {
    values[key] = value;
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    values[key] = value;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Theme and currency pair survive a new settings instance', () async {
    final storage = MemoryPreferences();
    final original = AppSettings(storage: storage);
    await original.toggleTheme();
    await original.setPair('EUR', 'CNY');
    final restored = AppSettings(storage: storage);
    await restored.load();
    expect(restored.dark, isTrue);
    expect(restored.from, 'EUR');
    expect(restored.to, 'CNY');
    original.dispose();
    restored.dispose();
  });
  test('Invalid saved currency pair falls back to defaults', () async {
    final storage = MemoryPreferences();
    storage.values['currencyPair'] = ['XXX', 'USD'];
    final settings = AppSettings(storage: storage);
    await settings.load();
    expect(settings.from, 'RUB');
    expect(settings.to, 'USD');
    settings.dispose();
  });
}
