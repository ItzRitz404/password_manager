import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/main.dart';
import 'package:password_manager/key_derivation.dart';
import 'package:flutter/services.dart';

// final TextEditingController newMasterPassword = TextEditingController();
// final TextEditingController confirmMasterPassword = TextEditingController();

// // Future<void> savePassword(String password) async {
// //   final FlutterSecureStorage storage = const FlutterSecureStorage();
// //   await storage.write(key: 'master_password', value: password);
// // }

// class MasterPasswordSetterPage extends StatelessWidget {
//   const MasterPasswordSetterPage({super.key});

//   // final TextEditingController newMasterPassword = TextEditingController();
//   // final TextEditingController confirmMasterPassword = TextEditingController();

//   // Future<void> savePassword (String password) async {
//   //   final FlutterSecureStorage storage = const FlutterSecureStorage();
//   //   await storage.write(key: 'master_password', value: password);
//   // }

// //   
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: const Color(0xFFC6E6FB),
//     appBar: AppBar(
//       backgroundColor: const Color(0xFF0047AB),
//       title: const Text(
//         'Set Master Password',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       centerTitle: true,
//     ),
//     body: Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Card(
//           elevation: 6,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Create a Master Password',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'This password will be used to encrypt and access your stored credentials.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 const SizedBox(height: 24),
//                 _buildPasswordField(
//                   controller: newMasterPassword,
//                   label: "New Password",
//                   icon: Icons.lock_outline,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildPasswordField(
//                   controller: confirmMasterPassword,
//                   label: "Confirm Password",
//                   icon: Icons.lock,
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: () async {
//                       if (newMasterPassword.text == confirmMasterPassword.text) {
//                         final password = newMasterPassword.text;
//                         final salt = generateRandomSalt();
//                         final hashedPassword = hashPassword(password, salt);
//                         final recoveryCode = generateRecoveryCode();
//                         final recoveryCodeHash = hashPassword(recoveryCode, salt);

//                         final storage = const FlutterSecureStorage();
//                         await storage.write(key: 'master_password', value: hashedPassword);
//                         await storage.write(key: 'salt', value: salt);
//                         await storage.write(key: 'recovery_code', value: recoveryCodeHash);

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Master password set successfully!')),
//                         );

//                         showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Recovery Code'),
//                             content: Text('Your recovery code is:\n\n$recoveryCode\n\nPlease store it safely.'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => MyHomePage(title: 'Password Manager'),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text('OK'),
//                               ),
//                             ],
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Passwords do not match!'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//                     icon: const Icon(Icons.check),
//                     label: const Text(
//                       'Submit',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF0047AB),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// // 🔧 Helper Method for Input Fields
// Widget _buildPasswordField({
//   required TextEditingController controller,
//   required String label,
//   required IconData icon,
// }) {
//   return TextField(
//     controller: controller,
//     obscureText: true,
//     decoration: InputDecoration(
//       labelText: label,
//       prefixIcon: Icon(icon),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       filled: true,
//       fillColor: Colors.white,
//     ),
//   );
// }}

class MasterPasswordSetterPage extends StatefulWidget {
  const MasterPasswordSetterPage({super.key});

  @override
  State<MasterPasswordSetterPage> createState() => _MasterPasswordSetterPageState();
}

class _MasterPasswordSetterPageState extends State<MasterPasswordSetterPage> {
  final TextEditingController newMasterPassword = TextEditingController();
  final TextEditingController confirmMasterPassword = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    newMasterPassword.addListener(_validate);
    confirmMasterPassword.addListener(_validate);
  }

  void _validate() {
    final pw = newMasterPassword.text;
    final confirmPw = confirmMasterPassword.text;
    final isValid = pw.length >= 8 && pw == confirmPw;

    if (isValid != isButtonEnabled) {
      setState(() {
        isButtonEnabled = isValid;
      });
    }
  }

  @override
  void dispose() {
    newMasterPassword.dispose();
    confirmMasterPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6E6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0047AB),
        title: const Text(
          'Set Master Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
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
                    'Create a Master Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'This password will be used to encrypt and access your stored credentials.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  _buildPasswordField(
                    controller: newMasterPassword,
                    label: "New Password",
                    icon: Icons.lock_outline,
                    
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    controller: confirmMasterPassword,
                    label: "Confirm Password",
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isButtonEnabled
                          ? () async {
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
                                const SnackBar(content: Text('Master password set successfully!')),
                              );

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Recovery Code'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Your recovery code is:\n\n$recoveryCode\n\nPlease store it safely.'),
                                      const SizedBox(height: 12),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: recoveryCode));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Copied to clipboard')),
                                          );
                                        },
                                        icon: const Icon(Icons.copy),
                                        label: const Text('Copy'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                  ],
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(Icons.check),
                      label: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonEnabled ? const Color(0xFF0047AB) : Colors.grey,
                        foregroundColor: Colors.white,
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
  }

  // 🔧 Helper Method for Input Fields
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
