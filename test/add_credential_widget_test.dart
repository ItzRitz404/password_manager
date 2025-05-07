import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Add Credential form opens and adds credential', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MyHomePage(title: 'Password Manager'),
    ));

    // Tap the add icon button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill in form fields
    await tester.enterText(find.byType(TextFormField).at(0), 'TestApp');
    await tester.enterText(find.byType(TextFormField).at(1), 'testUser');
    await tester.enterText(find.byType(TextFormField).at(2), 'testPass');
    await tester.enterText(find.byType(TextFormField).at(3), 'https://test.com');

    // Tap Add button
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Check if credential appears in the vault
    expect(find.text('TestApp'), findsOneWidget);
  });
}