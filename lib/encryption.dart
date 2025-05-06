import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:password_manager/key_derivation.dart';
import 'package:ntcdcrypto/ntcdcrypto.dart';

// generate key with pbkdf2
String generateKey() {
    final key = encrypt.Key.fromSecureRandom(32);  // 256-bit key for AES-256
    return base64.encode(key.bytes);
}


// String encryptData(String data, String encryptionKey) {
//     final key = encrypt.Key.fromBase64(encryptionKey);
//     final iv = encrypt.IV.fromSecureRandom(16);
//     final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
//     return encrypter.encrypt(data, iv: iv).base64;
// }

String encryptData(String data, String encryptionKey) {
  final key = encrypt.Key.fromBase64(encryptionKey);  // Decode the encryption key
  final iv = encrypt.IV.fromSecureRandom(16);  // Generate a random IV (16 bytes for AES)
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));  // AES in CBC mode

  final encrypted = encrypter.encrypt(data, iv: iv);  // Encrypt the data with the IV
  final encryptedData = encrypted.base64;  // Convert to base64 for storage

  // Store IV alongside encrypted data to use during decryption
  return json.encode({
    'iv': base64.encode(iv.bytes),  // Store IV in base64
    'data': encryptedData,  // Store the encrypted data
  });
}

// String decryptData(String encryptedData, String encryptionKey) {
//     final key = encrypt.Key.fromBase64(encryptionKey);
//     final iv = encrypt.IV.fromSecureRandom(16);
//     final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
//     return encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedData), iv: iv);
// }
Map<String, dynamic> decryptData(String encryptedJson, String encryptionKey) {
  final decoded = json.decode(encryptedJson); // Decode the JSON wrapper
  final iv = encrypt.IV.fromBase64(decoded['iv']);
  final encryptedText = encrypt.Encrypted.fromBase64(decoded['data']);

  final key = encrypt.Key.fromBase64(encryptionKey);
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  final decryptedString = encrypter.decrypt(encryptedText, iv: iv);

  return json.decode(decryptedString); // Convert back to Map<String, dynamic>
}


// Split a key into multiple shares using Shamir's Secret Sharing
List<String> splitKey(String key, int threshold, int numOfShares) {
    final sss = SSS();
    final shares = sss.create(
        threshold,
        numOfShares,
        key,
        true
    );
    return shares;
}

// reconstruct a key from multiple shares using Shamir's Secret Sharing
String reconstructKey(List<String> shares) {
    final sss = SSS();
    final key = sss.combine(shares, true);
    return key;
}