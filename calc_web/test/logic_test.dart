import 'package:flutter_test/flutter_test.dart';
import 'package:calc_web/logic/calculator.dart';
import 'package:calc_web/logic/currency.dart';

void main() {
  test(
    'Addition with comma',
    () => expect((calculate('1,5', '+', '2') as CalcSuccess).value, 3.5),
  );
  test(
    'Subtraction',
    () => expect((calculate('2', '-', '5') as CalcSuccess).value, -3),
  );
  test(
    'Multiplication',
    () => expect((calculate('-3', '*', '4') as CalcSuccess).value, -12),
  );
  test(
    'Division',
    () => expect((calculate('10', '/', '4') as CalcSuccess).value, 2.5),
  );
  test(
    'Division by zero',
    () => expect(calculate('1', '/', '0'), isA<CalcFailure>()),
  );
  test(
    'Non numeric input',
    () => expect(calculate('abc', '+', '1'), isA<CalcFailure>()),
  );
  test('Missing parameters', () {
    expect(calculate(null, '+', '1'), isA<CalcFailure>());
    expect(calculate('1', null, '1'), isA<CalcFailure>());
    expect(calculate('1', '+', null), isA<CalcFailure>());
  });
  test(
    'Unknown operation',
    () => expect(calculate('1', '^', '2'), isA<CalcFailure>()),
  );
  test('Non finite input and overflow', () {
    for (final value in ['NaN', 'Infinity', '-Infinity']) {
      expect(calculate(value, '+', '1'), isA<CalcFailure>());
    }
    expect(calculate('1e308', '*', '1e308'), isA<CalcFailure>());
  });
  test(
    'Currency conversion',
    () =>
        expect((convertCurrency('2', 'USD', 'RUB') as CalcSuccess).value, 180),
  );
  test(
    'Same currency',
    () => expect(
      (convertCurrency('12.5', 'EUR', 'EUR') as CalcSuccess).value,
      12.5,
    ),
  );
  test('Currency rejects invalid input', () {
    expect(convertCurrency('-1', 'USD', 'RUB'), isA<CalcFailure>());
    expect(convertCurrency('abc', 'USD', 'RUB'), isA<CalcFailure>());
    expect(convertCurrency('1', 'XXX', 'RUB'), isA<CalcFailure>());
    expect(convertCurrency(null, 'USD', 'RUB'), isA<CalcFailure>());
  });
  test('Formatting', () {
    expect(formatNumber(10 / 3), '3.333333');
    expect(formatNumber(100), '100');
    expect(formatNumber(-0.0), '0');
    expect(formatNumber(0.00000001), '1.000000e-8');
  });
}
