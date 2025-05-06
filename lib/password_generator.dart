import 'dart:math';

String generatePassword({
  int length = 12,
  bool includeUppercase = true,
  bool includeLowercase = true,
  bool includeNumbers = true,
  bool includeSymbols = true,
}) {
  const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
  const String numbers = '0123456789';
  const String symbols = '!@#\$%^&*()_-+=<>?';

  String chars = '';
  if (includeUppercase) chars += uppercase;
  if (includeLowercase) chars += lowercase;
  if (includeNumbers) chars += numbers;
  if (includeSymbols) chars += symbols;

  if (chars.isEmpty) {
    throw Exception('At least one character type must be selected.');
  }

  final rand = Random.secure();
  return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
}