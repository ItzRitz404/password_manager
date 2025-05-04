import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/main.dart';
import 'package:password_manager/key_derivation.dart';

final TextEditingController newMasterPassword = TextEditingController();
final TextEditingController confirmMasterPassword = TextEditingController();

// Future<void> savePassword(String password) async {
//   final FlutterSecureStorage storage = const FlutterSecureStorage();
//   await storage.write(key: 'master_password', value: password);
// }

class MasterPasswordSetterPage extends StatelessWidget {
  const MasterPasswordSetterPage({super.key});

  // final TextEditingController newMasterPassword = TextEditingController();
  // final TextEditingController confirmMasterPassword = TextEditingController();

  // Future<void> savePassword (String password) async {
  //   final FlutterSecureStorage storage = const FlutterSecureStorage();
  //   await storage.write(key: 'master_password', value: password);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6E6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0047AB),
        title: const Text(
          'Set Master Password',
          style: TextStyle(
            color: Color(0xFFFF7F50),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enter a new master password'),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              controller: newMasterPassword,
              obscureText: false,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Color(0xff000000),
              ),
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 255, 255, 255),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Color(0xff9e9e9e),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Color(0xff9e9e9e),
                    width: 1,
                  ),
                ),
                labelText: "Enter New Password",
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Color(0xff9e9e9e),
                ),
                prefixIcon: const Icon(Icons.security),
                filled: true,
                fillColor: Colors.white,
                isDense: false,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                icon: const Icon(Icons.security),
              ),
            ),
          ),
          const Text('Confirm your master password'),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              controller: confirmMasterPassword,
              obscureText: false,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Color(0xff000000),
              ),
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 255, 255, 255),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Color(0xff9e9e9e),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Color(0xff9e9e9e),
                    width: 1,
                  ),
                ),
                labelText: "Enter New Password",
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Color(0xff9e9e9e),
                ),
                prefixIcon: const Icon(Icons.security),
                filled: true,
                fillColor: Colors.white,
                isDense: false,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                icon: const Icon(Icons.security),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              // if (newMasterPassword.text == confirmMasterPassword.text) {
              //   await savePassword(newMasterPassword.text);
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(
              //       content: Text('Master password set successfully!'),
              //     ),
              //   );
              //   Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => MyHomePage(title: 'Password Manager'),
              //     ),
              //   );
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text('Passwords do not match!')),
              //   );
              // }

              if (newMasterPassword.text == confirmMasterPassword.text) {
                final password = newMasterPassword.text;
                final salt = generateRandomSalt();
                final hashedPassword = hashPassword(password, salt);

                final recoveryCode = generateRecoveryCode();
                final recoveryCodeHash = hashPassword(recoveryCode, salt);

                final storage = const FlutterSecureStorage();
                await storage.write(key: 'master_password', value: hashedPassword);
                await storage.write(key: 'salt', value: salt);
                await storage.write(key: 'recovery_code', value: recoveryCodeHash);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Master password set successfully!'),
                  ),
                );

                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    title: const Text('Recovery Code'),
                    content: Text('Your recovery code is: $recoveryCode.\n'
                        'Please keep it safe.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(title: 'Password Manager'),
                            ),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ]
                  ),
                  );
              }
              
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
