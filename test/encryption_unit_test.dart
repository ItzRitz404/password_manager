import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/encryption.dart';

void main () {
test('AES encryption-decryption works correctly', () {
  final key = generateKey();
  final original = json.encode({'app': 'TestApp', 'username': 'test', 'password': '123'});
  final encrypted = encryptData(original, key);
  final decrypted = decryptData(encrypted, key);
  expect(decrypted['app'], equals('TestApp'));
});
}