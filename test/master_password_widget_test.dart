import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/main.dart'; 
import 'package:flutter/material.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  testWidgets('Valid recovery code resets password', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.text('Forgot Password?'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), 'validRecoveryCode');
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();
  expect(find.text('Set New Password'), findsOneWidget);
  });
}