import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/main.dart';
import 'master_password_setter.dart';
// import 'key_derivation.dart';
import 'package:password_manager/key_derivation.dart';

class MasterPasswordPage extends StatefulWidget {
  final Function(String) passwordEntered;

  const MasterPasswordPage({super.key, required this.passwordEntered});

  @override
  _MasterPasswordPageState createState() => _MasterPasswordPageState();
}

class _MasterPasswordPageState extends State<MasterPasswordPage> {
  final TextEditingController masterPasswordController =
      TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  bool isPasswordCorrect = true;

  @override
  void initState() {
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFC6E6FB),
    appBar: AppBar(
      backgroundColor: const Color(0xFF0051A3),
      title: const Text(
        'Enter Master Password',
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    ),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please enter your master password to access your credentials.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: masterPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Master Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final masterPassword = masterPasswordController.text;
                      final isValid = await verifyPassword(masterPassword);

                      if (isValid) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(title: 'Password Manager'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Incorrect password!'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.login),
                    label: const Text(
                      'Unlock',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0047AB),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}}

class MasterPasswordCheck extends StatefulWidget {
  const MasterPasswordCheck({super.key});

  @override
  _MasterPasswordCheckState createState() => _MasterPasswordCheckState();
}

class _MasterPasswordCheckState extends State<MasterPasswordCheck> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkMasterPassword();
  }

  Future<void> checkMasterPassword() async {
    final masterPassword = await storage.read(key: 'master_password');

    if (masterPassword == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MasterPasswordSetterPage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  MasterPasswordPage(passwordEntered: passwordEntered),
        ),
      );
    }
  }

  void passwordEntered(String password) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: 'Password Manager'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Show a loading indicator while checking the password
      ),
    );
  }
}
