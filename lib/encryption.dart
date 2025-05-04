import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:password_manager/key_derivation.dart';
import 'package:ntcdcrypto/ntcdcrypto.dart';

// generate key with pbkdf2
String generateKey(String password) {
    final salt = generateRandomSalt();
    return hashPassword(password, salt);
}

String encryptData(String data, String encryptionKey, String encryptionIv) {
    final key = encrypt.Key.fromBase64(encryptionKey);
    final iv = encrypt.IV.fromBase64(encryptionIv);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    return encrypter.encrypt(data, iv: iv).base64;
}

String decryptData(String encryptedData, String encryptionKey, String encryptionIv) {
    final key = encrypt.Key.fromBase64(encryptionKey);
    final iv = encrypt.IV.fromBase64(encryptionIv);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedData), iv: iv);
}

// // SSS
// Map<int, String> generateShares(String key) {
//     final shares = sss256.splitSecret(
//         secret: key,
//         shares: 5, // Total number of shares to generate
//         treshold: 3, // Minimum number of shares needed to reconstruct the key
//     );
//     return {for (int i = 0; i < shares.length; i++) i + 1: shares[i]};
// }

// // combines shares to reconstruct the key
// String combineShares(Map<int, String> shares) {
//     final shareList = shares.entries.Map((e) =>
//         Share(e.key, base64.decode(e.value))
//         ).toList();
//     return utf8.decode(sss256.combineShares(shareList));
    
// }

// List<String> splitKey(Uint8List key, int threshold, int shares, String pass) {
//     final slip = Slip39.from(
//         [key],
//         masterSecret: key,
//         threshold: threshold,
//         passphrase: pass,
//         iterationExponent: 5
//     );
    
// }

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