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
            fontSize: 25,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w900, // AppBar text color
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: masterPasswordController,
              obscureText: false,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: Color(0xff000000),
              ),
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF0051A3),
                    width: 1,
                  ), // Border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF0051A3),
                    width: 1,
                  ), // Border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF0051A3),
                    width: 1,
                  ), // Border color
                ),
                labelText: 'Master Password',
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: Color(0xff000000),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                isDense: false,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                icon: const Icon(Icons.apps_sharp),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

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
