import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// generates random salt 
Uint8List generateSalt() {
  final Random random = Random.secure();
  final Uint8List salt = Uint8List(16);
  // loop through array and assign random number from 0-255 to salt 
  for (int i = 0; i < salt.length; i++) {
    salt[i] = random.nextInt(256);
  }
  return salt;
}

// generate recovery code
String genRecoveryCode() {
  final Random random = Random.secure();
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  String code = '';
  for (int i = 0; i < 12; i++) {
    code += chars[random.nextInt(chars.length)];
  }
  return code;
}

// derive key from password and salt using PBKDF2
String deriveKey(String password, Uint8List salt) {
  const iterations = 100000;
  final passwordByte = utf8.encode(password);
  var key = Uint8List.fromList(passwordByte + salt);

  for (int i = 0; i < iterations; i++) {
    key = sha256.convert(key).bytes as Uint8List;
  }

  return base64.encode(key);

}

// save password
Future<Map<String, String>> savePassword(String password) async {
  final storage = const FlutterSecureStorage();
  final salt = generateSalt();
  final masterPasswordHash = deriveKey(password, salt);
  final recoveryCode = genRecoveryCode();
  final recoveryCodeHash = deriveKey(recoveryCode, salt);

  await storage.write(key: 'master_password', value: masterPasswordHash);
  await storage.write(key: 'salt', value: base64.encode(salt));
  await storage.write(key: 'recovery_code', value: recoveryCode);

  return {'recovery code:' : recoveryCode, 
          'hashed password' : masterPasswordHash,
  };
}