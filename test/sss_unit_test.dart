import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/encryption.dart';

void main () {
  test('SSS splits and reconstructs key', () {
    final key = generateKey();
    final shares = splitKey(key, 3, 5);
    final reconstructed = reconstructKey(shares.sublist(0, 3));
    expect(reconstructed, equals(key));
  });
}