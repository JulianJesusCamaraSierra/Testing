import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:proyecto/led_widget.dart';
import 'package:proyecto/control_panel_widget.dart';

void main() {

  testWidgets('LEDWidget shows green when isOn=true', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LEDWidget(isOn: true),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));

    expect(icon.color, Colors.green);
  });

  testWidgets('LEDWidget shows grey when isOn=false', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LEDWidget(isOn: false),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));

    expect(icon.color, Colors.grey);
  });

  testWidgets('ControlPanelWidget starts at 0', (tester) async {
    await tester.pumpWidget(const ControlPanelWidget());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('One tap increments counter to 1', (tester) async {
    await tester.pumpWidget(const ControlPanelWidget());

    await tester.tap(find.byKey(const Key('fab')));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Five taps increment counter to 5', (tester) async {
    await tester.pumpWidget(const ControlPanelWidget());

    final fab = find.byKey(const Key('fab'));

    for (int i = 0; i < 5; i++) {
      await tester.tap(fab);
      await tester.pump();
    }

    expect(find.text('5'), findsOneWidget);
  });
}
