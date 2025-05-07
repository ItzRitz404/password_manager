import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/key_derivation.dart';

void main() {
  // password hash test
  test('PBKDF2 hashing produces same hash for same salt', () {
  final password = 'test123';
  final salt = generateRandomSalt();
  final hash1 = hashPassword(password, salt);
  final hash2 = hashPassword(password, salt);
  expect(hash1, equals(hash2));
});

}
