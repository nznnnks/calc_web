sealed class CalcResult {
  const CalcResult();
}

class CalcSuccess extends CalcResult {
  final double value;
  const CalcSuccess(this.value);
}

class CalcFailure extends CalcResult {
  final String message;
  const CalcFailure(this.message);
}

double? parseNumber(String? raw) {
  final value = double.tryParse(raw?.trim().replaceAll(',', '.') ?? '');
  return value != null && value.isFinite ? value : null;
}

String? numberValidator(String? raw) {
  if (raw == null || raw.trim().isEmpty) return 'Введите число';
  return parseNumber(raw) == null ? 'Введите конечное число' : null;
}

CalcResult finiteResult(double value) => value.isFinite
    ? CalcSuccess(value)
    : const CalcFailure('Результат слишком велик');
CalcResult calculate(String? rawA, String? op, String? rawB) {
  if ([rawA, op, rawB].any((v) => v == null || v.trim().isEmpty)) {
    return const CalcFailure('Отсутствует обязательный параметр');
  }
  final a = parseNumber(rawA);
  final b = parseNumber(rawB);
  if (a == null || b == null) {
    return const CalcFailure('В адресе переданы некорректные числа');
  }
  return switch (op) {
    '+' => finiteResult(a + b),
    '-' => finiteResult(a - b),
    '*' => finiteResult(a * b),
    '/' =>
      b == 0
          ? const CalcFailure('Деление на ноль невозможно')
          : finiteResult(a / b),
    _ => const CalcFailure('Неизвестная операция'),
  };
}

String formatNumber(double value) {
  if (value == 0) return '0';
  if (value.abs() >= 1e12 || value.abs() < 0.000001) {
    return value.toStringAsExponential(6);
  }
  return value.toStringAsFixed(6).replaceFirst(RegExp(r'\.?0+$'), '');
}
