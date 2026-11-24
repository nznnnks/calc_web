import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';
import '../logic/currency.dart';
import 'app_page.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final uri = GoRouterState.of(context).uri;
    final q = uri.queryParameters;
    final currency = uri.path == '/converter/result';
    final keys = currency ? ['amount', 'from', 'to'] : ['a', 'op', 'b'];
    final repeated = keys.any(
      (k) => (uri.queryParametersAll[k]?.length ?? 0) > 1,
    );
    final result = repeated
        ? const CalcFailure('Параметры не должны повторяться')
        : currency
        ? convertCurrency(q['amount'], q['from'], q['to'])
        : calculate(q['a'], q['op'], q['b']);
    return AppPage(
      title: 'Результат',
      backPath: currency ? '/converter' : '/calculator',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            result is CalcSuccess
                ? Icons.check_circle_outline
                : Icons.error_outline,
            size: 48,
          ),
          const SizedBox(height: 16),
          if (result is CalcSuccess) ...[
            Text(
              currency
                  ? "${q['amount']} ${q['from']} → ${q['to']}"
                  : "${q['a']} ${q['op']} ${q['b']}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            SelectableText(
              '${formatNumber(result.value)}${currency ? " ${q['to']}" : ""}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ] else if (result is CalcFailure)
            Text(
              result.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () =>
                context.go(currency ? '/converter' : '/calculator'),
            child: const Text('Вернуться к форме'),
          ),
        ],
      ),
    );
  }
}
