import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/password_generator.dart';

void main (){
  test('Password generator includes specified character types', () {
  final password = generatePassword(length: 16, includeSymbols: true, includeNumbers: true, includeUppercase: true);
  expect(password.length, equals(16));
  expect(password.contains(RegExp(r'[A-Z]')), isTrue);
  expect(password.contains(RegExp(r'[0-9]')), isTrue);
  expect(password.contains(RegExp(r'[!@#\\$%^&*(),.?":{}|<>]')), isTrue);
});
}