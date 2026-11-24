import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';
import 'app_page.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final form = GlobalKey<FormState>();
  final a = TextEditingController();
  final b = TextEditingController();
  String operation = '+';
  @override
  void dispose() {
    a.dispose();
    b.dispose();
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    context.go(
      Uri(
        path: '/calculator/result',
        queryParameters: {
          'a': a.text.trim(),
          'op': operation,
          'b': b.text.trim(),
        },
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Калькулятор',
    backPath: '/',
    child: Form(
      key: form,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: a,
            decoration: const InputDecoration(
              labelText: 'Первое число',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            validator: numberValidator,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: operation,
            decoration: const InputDecoration(
              labelText: 'Операция',
              border: OutlineInputBorder(),
            ),
            items: [
              '+',
              '-',
              '*',
              '/',
            ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (value) => setState(() => operation = value!),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: b,
            decoration: const InputDecoration(
              labelText: 'Второе число',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            validator: numberValidator,
            onFieldSubmitted: (_) => submit(),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: submit, child: const Text('Вычислить')),
        ],
      ),
    ),
  );
}
