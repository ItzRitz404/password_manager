import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/key_derivation.dart';
import 'package:password_manager/main.dart';

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key});

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final storage = const FlutterSecureStorage();

  final TextEditingController recoveryCodeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? error;
  String? newGeneratedRecovery;

  Future<void> handleRecovery() async {
    final recoveryCodeInput = recoveryCodeController.text.trim();
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      setState(() => error = "Passwords do not match.");
      return;
    }

    final storedSalt = await storage.read(key: 'salt');
    final storedRecoveryHash = await storage.read(key: 'recovery_code');

    if (storedSalt == null || storedRecoveryHash == null) {
      setState(() => error = "Recovery data is missing.");
      return;
    }

    final inputHash = hashPassword(recoveryCodeInput, storedSalt);

    if (inputHash != storedRecoveryHash) {
      setState(() => error = "Invalid recovery code.");
      return;
    }

    // Update password and generate a new recovery code
    final newMasterHash = hashPassword(newPassword, storedSalt);
    final newRecoveryCode = generateRecoveryCode();
    final newRecoveryHash = hashPassword(newRecoveryCode, storedSalt);

    await storage.write(key: 'master_password', value: newMasterHash);
    await storage.write(key: 'recovery_code', value: newRecoveryHash);

    setState(() {
      newGeneratedRecovery = newRecoveryCode;
      error = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Master password updated")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Recovery'),
        backgroundColor: const Color(0xFF0047AB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter your recovery code and set a new master password.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: recoveryCodeController,
              decoration: const InputDecoration(
                labelText: "Recovery Code",
                prefixIcon: Icon(Icons.vpn_key),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Master Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: handleRecovery,
              child: const Text("Reset Master Password"),
            ),
            if (newGeneratedRecovery != null) ...[
              const SizedBox(height: 24),
              const Text(
                "🎉 New Recovery Code:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SelectableText(
                newGeneratedRecovery!,
                style: const TextStyle(fontSize: 16, fontFamily: 'RobotoMono'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: newGeneratedRecovery!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recovery code copied to clipboard')),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text("Copy Code"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyHomePage(title: "Password Manager"),
                    ),
                  );
                },
                child: const Text("Continue to App"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
