import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/key_derivation.dart';
import 'package:password_manager/password_generator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final storage = const FlutterSecureStorage();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool includeSymbols = true;
  bool includeNumbers = true;
  bool includeUppercase = true;
  double passwordLength = 12;

  Future<void> changeMasterPassword() async {
    final storedSalt = await storage.read(key: 'salt');
    final storedHash = await storage.read(key: 'master_password');

    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (storedSalt == null || storedHash == null) return;

    final oldHash = hashPassword(oldPassword, storedSalt);

    if (oldHash != storedHash) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Old password is incorrect')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    final newHash = hashPassword(newPassword, storedSalt);
    await storage.write(key: 'master_password', value: newHash);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Master password updated!')),
    );

    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF0047AB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Change Master Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: changeMasterPassword,
              child: const Text('Update Password'),
            ),
            const Divider(height: 40),
            const Text('Random Password Generator Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Include Symbols'),
              value: includeSymbols,
              onChanged: (val) => setState(() => includeSymbols = val),
            ),
            SwitchListTile(
              title: const Text('Include Numbers'),
              value: includeNumbers,
              onChanged: (val) => setState(() => includeNumbers = val),
            ),
            SwitchListTile(
              title: const Text('Include Uppercase Letters'),
              value: includeUppercase,
              onChanged: (val) => setState(() => includeUppercase = val),
            ),
            ListTile(
              title: const Text('Password Length'),
              subtitle: Slider(
                value: passwordLength,
                min: 6,
                max: 32,
                divisions: 26,
                label: passwordLength.round().toString(),
                onChanged: (val) => setState(() => passwordLength = val),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await storage.write(key: 'gen_symbols', value: includeSymbols.toString());
                await storage.write(key: 'gen_numbers', value: includeNumbers.toString());
                await storage.write(key: 'gen_uppercase', value: includeUppercase.toString());
                await storage.write(key: 'gen_length', value: passwordLength.round().toString()); // ← this
                Navigator.pop(context);
              },
              child: const Text('Save Generator Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
