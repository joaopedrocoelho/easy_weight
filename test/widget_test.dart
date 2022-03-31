// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('check color', (WidgetTester tester) async {
    String dbColor = 'MaterialColor(primary value: Color(0xfff44336))';

    Color getColor(String colorFromDB) {
      RegExp getColorvalue =
          RegExp(r'(?<=MaterialColor\(primary value: Color\()[\w\d]*');
      String color = getColorvalue.stringMatch(colorFromDB).toString();

      return Color(int.parse(color));
    }

    Color color = getColor(dbColor);
    expect(color, Color(0xfff44336));
  });
}
