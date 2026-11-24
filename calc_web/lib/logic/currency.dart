import 'calculator.dart';

// Учебные фиксированные курсы: стоимость единицы валюты в RUB.
const currencyRates = <String, double>{
  'RUB': 1,
  'USD': 90,
  'EUR': 100,
  'CNY': 12.5,
  'GBP': 120,
};
CalcResult convertCurrency(String? rawAmount, String? from, String? to) {
  if (rawAmount == null || from == null || to == null) {
    return const CalcFailure('Отсутствует обязательный параметр');
  }
  final amount = parseNumber(rawAmount);
  if (amount == null) return const CalcFailure('Введите корректную сумму');
  if (amount < 0) return const CalcFailure('Сумма не может быть отрицательной');
  if (!currencyRates.containsKey(from) || !currencyRates.containsKey(to)) {
    return const CalcFailure('Неизвестная валюта');
  }
  return finiteResult(amount * (currencyRates[from]! / currencyRates[to]!));
}
