import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/key_derivation.dart';
import 'package:password_manager/password_menu.dart';
import 'master_password.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'encryption.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
  
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    loadKeys();
  }

  Future<void> loadKeys() async {
    // final allKeys = await storage.readAll();
    // setState(() {
    //   passwords = allKeys.keys.toList();
    // });

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

  Future<void> savePassword() async {
    final newPassword = {
      'application': widget.application.text,
      'username': widget.username.text,
      'password': widget.password.text,
      'url': widget.url.text,
    };

    // final jsonData = json.encode(newPassword);

    // // encrypt data
    // // frist gen a random key and hash it
    // final key = generateRandomSalt();

    // // encrypt the data using the key
    // final iv = encrypt.Key.fromSecureRandom(32);
    // final encryptProcess =  // 16 bytes for AES

    final encryptionKey = generateKey();
    // final iv
     // 16 bytes for AES

    final encryptedData = encryptData(
      json.encode(newPassword),
      encryptionKey,
    );


    final key = 'password_${DateTime.now().millisecondsSinceEpoch}';
    final keyForEncryption = 'key_$key';
    // await storage.write(key: key, value: encryptedData);
    await storage.write(key: key, value: encryptedData); // Store the encrypted password
    await storage.write(key: keyForEncryption, value: encryptionKey); 
    
    passwords.insert(0,key);// Store the encryption key
    await loadKeys(); 
  }

  Future<void> deletePassword(String key) async {
    await storage.delete(key: key);
    await loadKeys();
  }

  Future<Map<String, dynamic>?> getPassword(String key) async {
    // final value = await storage.read(key: key);
    // return value != key ? json.decode(value!) : null;

    final encryptedData = await storage.read(key: key);
    final encryptionKey = await storage.read(key: 'key_$key');

    if (encryptedData == null) {
      return null; // No data found for the given key
    } else {

      final decoded = json.decode(encryptedData);
      final ivBase64 = decoded['iv'];
      final encryptedDataBase64 = decoded['data']; // Decode the decrypted data

      final keyObj = encrypt.Key.fromBase64(encryptionKey!);
      final iv = encrypt.IV.fromBase64(ivBase64);
      final encrypter = encrypt.Encrypter(encrypt.AES(keyObj, mode: encrypt.AESMode.cbc));

      final decrypted = encrypter.decrypt64(encryptedDataBase64, iv: iv);

      return json.decode(decrypted);

    }
  }

  // bool viewPassword = false;

  Future<String?> addPasswordMenu(context) {
    bool viewPassword = false;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Password'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      controller: widget.application,
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
                        labelText: 'Application',
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
                    const SizedBox(height: 9.0, width: 500.0),

                    TextFormField(
                      controller: widget.username,
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
                        labelText: 'Username',
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
                        icon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 9.0, width: 500.0),

                    TextFormField(
                      controller: widget.password,
                      obscureText: !viewPassword,
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
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: Color(0xff000000),
                        ),
                        suffixIcon: IconButton(
                          // icon: Icon(
                          //   Icons.remove_red_eye,
                          //   color: viewPassword ? Colors.blue : Colors.grey,
                          // ),
                          // onPressed: () {
                          //   setState(() => viewPassword = !viewPassword);
                          // },
                          icon: Icon(
                            viewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: viewPassword ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              viewPassword = !viewPassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: false,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        icon: const Icon(Icons.security),
                      ),
                    ),
                    const SizedBox(height: 9.0, width: 500.0),

                    TextFormField(
                      controller: widget.url,
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
                        labelText: 'URL',
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
                        icon: const Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 9.0, width: 500.0),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                clearFields(); // Clear the text fields
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                await savePassword(); // Save the password

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
            onPressed: () {
              // Add your settings action here
            },
          ),

          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Password',
            onPressed: () async {
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => PasswordMenu(application: widget.application, username: widget.username, password: widget.password, url: widget.url, onSave: (newPassword) {
              //     setState(() {
              //       passwords.add(newPassword);
              //     });
              //   })),
              // );// Show the add password dialog

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
                              // Handle tap on the ListTile
                              // You can navigate to a detail page or show more information
                              // about the selected password entry here.
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(password['application'] ?? ''),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Username: ${password['username'] ?? ''}',
                                        ),
                                        Text(
                                          'Password: ${password['password'] ?? ''}',
                                        ),
                                        Text('URL: ${password['url'] ?? ''}'),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
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

                  // Column is also a layout widget. It takes a list of children and
                  // arranges them vertically. By default, it sizes itself to fit its
                  // children horizontally, and tries to be as tall as its parent.
                  //
                  // Column has various properties to control how it sizes itself and
                  // how it positions its children. Here we use mainAxisAlignment to
                  // center the children vertically; the main axis here is the vertical
                  // axis because Columns are vertical (the cross axis would be
                  // horizontal).
                  //
                  // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
                  // action in the IDE, or press "p" in the console), to see the
                  // wireframe for each widget.

                  // The Text widget displays the value of the counter variable.
                  // The counter variable is defined in the _MyHomePageState class.
                  // The Text widget is a stateless widget, meaning it does not have
                  // any mutable state. It is used to display text on the screen.

                  // This trailing comma makes auto-formatting nicer for build methods.
                },
              ),
    );
  }
}
