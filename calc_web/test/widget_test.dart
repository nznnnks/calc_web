import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calc_web/main.dart';
import 'package:calc_web/router.dart';
import 'package:calc_web/settings.dart';
import 'settings_test.dart' show MemoryPreferences;

void main() {
  for (final width in [360.0, 1920.0]) {
    for (final path in [
      '/',
      '/calculator',
      '/converter',
      '/calculator/result?a=10&op=%2B&b=5',
      '/calculator/result',
      '/qwerty',
    ]) {
      testWidgets('$path at width $width', (tester) async {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final router = createRouter(initialLocation: path);
        final settings = AppSettings(storage: MemoryPreferences());
        await tester.pumpWidget(CalcApp(settings: settings, router: router));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        if (path.contains('a=10')) expect(find.text('15'), findsOneWidget);
        if (path == '/calculator/result') {
          expect(
            find.text('Отсутствует обязательный параметр'),
            findsOneWidget,
          );
        }
        if (path == '/qwerty') {
          expect(find.text('Страница не найдена'), findsOneWidget);
        }
        await tester.pumpWidget(const SizedBox.shrink());
        router.dispose();
        settings.dispose();
      });
    }
  }
  testWidgets('Validation and query navigation', (tester) async {
    final router = createRouter(initialLocation: '/calculator');
    final settings = AppSettings(storage: MemoryPreferences());
    await tester.pumpWidget(CalcApp(settings: settings, router: router));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Вычислить'));
    await tester.pumpAndSettle();
    expect(find.text('Введите число'), findsNWidgets(2));
    await tester.enterText(find.byType(TextFormField).first, '1,5');
    await tester.enterText(find.byType(TextFormField).last, '2');
    await tester.tap(find.text('Вычислить'));
    await tester.pumpAndSettle();
    expect(find.text('3.5'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.queryParameters['op'],
      '+',
    );
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    settings.dispose();
  });
}
