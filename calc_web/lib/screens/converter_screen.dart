import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';
import '../logic/currency.dart';
import '../settings.dart';
import 'app_page.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});
  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final form = GlobalKey<FormState>();
  final amount = TextEditingController();
  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    final settings = SettingsScope.of(context);
    context.go(
      Uri(
        path: '/converter/result',
        queryParameters: {
          'amount': amount.text.trim(),
          'from': settings.from,
          'to': settings.to,
        },
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);
    Widget currencyField(bool source) => DropdownButtonFormField<String>(
      key: ValueKey('${source}_${source ? settings.from : settings.to}'),
      initialValue: source ? settings.from : settings.to,
      decoration: InputDecoration(
        labelText: source ? 'Из валюты' : 'В валюту',
        border: const OutlineInputBorder(),
      ),
      items: currencyRates.keys
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
      onChanged: (v) {
        if (v != null) {
          settings.setPair(
            source ? v : settings.from,
            source ? settings.to : v,
          );
        }
      },
    );
    return AppPage(
      title: 'Конвертер валют',
      backPath: '/',
      child: Form(
        key: form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            currencyField(true),
            const SizedBox(height: 20),
            currencyField(false),
            const SizedBox(height: 20),
            TextFormField(
              controller: amount,
              decoration: const InputDecoration(
                labelText: 'Сумма',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) =>
                  numberValidator(v) ??
                  (parseNumber(v)! < 0
                      ? 'Сумма не может быть отрицательной'
                      : null),
              onFieldSubmitted: (_) => submit(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: submit,
              child: const Text('Конвертировать'),
            ),
          ],
        ),
      ),
    );
  }
}
