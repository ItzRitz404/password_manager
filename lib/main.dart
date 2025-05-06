import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'master_password.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'encryption.dart';
import 'settings.dart';
import 'password_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 71, 171),
        ),
        useMaterial3: true,
      ),
      // home: MyHomePage(title: 'Password Manager'),
      home: MasterPasswordCheck(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final TextEditingController application = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController url = TextEditingController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> passwords = [];

  Widget _buildStyledField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffix,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(
        fontFamily: 'RobotoMono',
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        icon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF0051A3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF0051A3), width: 1.5),
        ),
        suffixIcon: suffix,
      ),
    ),
  );
}
  
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    loadKeys();
  }

  Future<void> loadKeys() async {
    final allKeys = await storage.readAll();

  // Filter only password keys (not encryption keys)
    final filteredKeys = allKeys.keys
      .where((k) => k.startsWith('password_'))
      .toList();

  // Sort by timestamp (newest first)
    filteredKeys.sort((a, b) {
      final aTime = int.tryParse(a.split('_').last) ?? 0;
      final bTime = int.tryParse(b.split('_').last) ?? 0;
      return bTime.compareTo(aTime);
    });

  setState(() {
    passwords = filteredKeys;
  });
  }

  Future<void> deletePassword(String key) async {
    await storage.delete(key: key);
    await loadKeys();
  }

  Future<void> savePassword () async {
    final newPassword = {
      'application': widget.application.text,
      'username': widget.username.text,
      'password': widget.password.text,
      'url': widget.url.text,
    };

    // gen AES key
    final encryptionKey = generateKey();
    final shares = splitKey(encryptionKey, 3, 5); // Split the key into 5 shares with a threshold of 3
    final key = 'password_${DateTime.now().millisecondsSinceEpoch}';

    // store shares
    for (int i = 0; i < shares.length; i++) {
      await storage.write(key: '${key}_share_$i', value: shares[i]);
    }

    final encryptedData = encryptData(
      json.encode(newPassword),
      encryptionKey,
    );

    await storage.write(key: key, value: encryptedData); // Store the encrypted password

    passwords.insert(0, key); // Store the encryption key
    await loadKeys(); // Reload the keys to update the UI
  }


  Future<Map<String, dynamic>?> getPassword (String key) async {
    final encryptedData = await storage.read(key: key);
    
    if (encryptedData == null) {
      return null;
    }

    final List<String> shares = [];
    for (int i = 0; i < 5; i++) {
      final share = await storage.read(key: '${key}_share_$i');
      if (share != null) {
        shares.add(share); // Ensured to be String
      }
      if (shares.length >= 3) break;
    }

    final recontructedKey = reconstructKey(shares);

    final Map<String, dynamic> decrypted = decryptData(encryptedData, recontructedKey);
    return decrypted;
    
  }

  Future<String?> addPasswordMenu(context) {
  bool viewPassword = false;
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Add Password',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStyledField(
                    icon: Icons.apps,
                    label: 'Application',
                    controller: widget.application,
                  ),
                  _buildStyledField(
                    icon: Icons.person,
                    label: 'Username',
                    controller: widget.username,
                  ),
                  _buildStyledField(
                    icon: Icons.lock,
                    label: 'Password',
                    controller: widget.password,
                    obscure: !viewPassword,
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            viewPassword ? Icons.visibility : Icons.visibility_off,
                            color: viewPassword ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              viewPassword = !viewPassword;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.green),
                          tooltip: 'Generate Password',
                          onPressed: () async {
                             final settings = await storage.readAll();

                            final int length = int.tryParse(settings['gen_length'] ?? '12') ?? 12;
                            final bool uppercase = settings['gen_uppercase'] != 'false';
                            final bool numbers = settings['gen_numbers'] != 'false';
                            final bool symbols = settings['gen_symbols'] != 'false';

                            final generated = generatePassword(
                              length: length,
                              includeUppercase: uppercase,
                              includeNumbers: numbers,
                              includeSymbols: symbols,
                            );

                            setState(() {
                              widget.password.text = generated;
                            }); // call your generator
                            setState(() {
                              widget.password.text = generated;
                              viewPassword = true;
                            });
                          },
                        ),
                      ],
                    ),
                    
                  ),
                  _buildStyledField(
                    icon: Icons.link,
                    label: 'URL',
                    controller: widget.url,
                  ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              clearFields();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Add',
              style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600),
            ),
            onPressed: () async {
              await savePassword();
              clearFields();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  void clearFields() {
    widget.application.clear();
    widget.username.clear();
    widget.password.clear();
    widget.url.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6E6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0051A3),
        title: Text(
          'Password Manager',
          style: const TextStyle(
            fontSize: 25,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w900, // AppBar text color
          ),
        ),
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close',
          onPressed: () {
            // Add your close action here
            // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            // Close the app or navigate back
            SystemNavigator.pop(); // This will close the app
          },
        ),
        // Center the title in the AppBar
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () async {
             await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              // Add your settings action here
            },
          ),

          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Password',
            onPressed: () async {
              await addPasswordMenu(context); // Show the add password dialog
            },
          ),
        ],
      ),
      // This is the main content of the app. It is a stateful widget, meaning
      body:
          passwords.isEmpty
              ? const Center(
                child: Text(
                  "database is empty",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF0051A3), // Text color
                  ),
                ),
              )
              : ListView.builder(
                
                itemCount: passwords.length,
                itemBuilder: (context, index) {
                  final key = passwords[index];
                  
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: getPassword(key),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      } else if (snapshot.hasData) {
                        final password = snapshot.data!;
                        return Card(
                          child: ListTile(
                            title: Text(password['application'] ?? ''),
                            subtitle: Text(password['username'] ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deletePassword(key),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      password['application'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.person, size: 20, color: Colors.blueAccent),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                'Username: ',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Roboto',
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                password['username'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'RobotoMono',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.lock, size: 20, color: Colors.redAccent),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                'Password: ',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Roboto',
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                password['password'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'RobotoMono',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.link, size: 20, color: Colors.green),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                'URL: ',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Roboto',
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                password['url'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'RobotoMono',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                      return const ListTile(title: Text('No data available'));
                    },
                  );

            
                },
              ),
    );
  }
}
