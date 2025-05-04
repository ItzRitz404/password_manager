import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:password_manager/main.dart';

// create random salt value
String generateRandomSalt([int len = 16]) {
  final Random random = Random.secure();
  final salt = List<int>.generate(len, (_) => random.nextInt(256));
  return base64Url.encode(salt);
}

// hash the password with the salt using PBKDF2
String hashPassword (String password, String salt) {
  final store = utf8.encode(password);
  final hashed = utf8.encode(salt);
  final key = KeyDerivator('SHA-256/HMAC/PBKDF2')
      ..init(Pbkdf2Parameters(hashed, 1000, 32));
  final derivedKey = key.process(store);
  return base64Url.encode(derivedKey);
 
}

// gen a recovery code
String generateRecoveryCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random.secure();
  return List.generate(16, (index) => chars[random.nextInt(chars.length)]).join();
}

// verify the password
Future<bool> verifyPassword(String masterPasswordInput) async {
  final storage = const FlutterSecureStorage();
  
  final storedHash = await storage.read(key: 'master_password');
  final storedSalt = await storage.read(key: 'salt');

  if (storedHash == null || storedSalt == null) {
    return false; // No password set
  } else {
    final newHash = hashPassword(masterPasswordInput, storedSalt);
    return newHash == storedHash; // Compare hashes
  }
}