import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/widgets/restart_widget.dart';

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  var _value = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text('value: $_value'),
            ElevatedButton(
              onPressed: () => setState(() => _value++),
              child: const Text('increment'),
            ),
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => RestartWidget.restartApp(context),
                child: const Text('restart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('restartApp tears down and recreates the wrapped subtree', (
    tester,
  ) async {
    await tester.pumpWidget(const RestartWidget(child: _Counter()));

    await tester.tap(find.text('increment'));
    await tester.tap(find.text('increment'));
    await tester.pump();
    expect(find.text('value: 2'), findsOneWidget);

    await tester.tap(find.text('restart'));
    await tester.pump();

    expect(find.text('value: 0'), findsOneWidget);
  });

  testWidgets('restartApp is a no-op with no RestartWidget ancestor', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => RestartWidget.restartApp(context),
            child: const Text('restart'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('restart'));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
