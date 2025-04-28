import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordMenu extends StatefulWidget {
  final TextEditingController application;
  final TextEditingController username;
  final TextEditingController password;
  final TextEditingController url;
  final Function(Map<String, String>) onSave;

  const PasswordMenu({
    Key? key,
    required this.application,
    required this.username,
    required this.password,
    required this.url,
    required this.onSave,
  }) : super(key: key);

  @override
  _PasswordMenuState createState() => _PasswordMenuState();
}

class _PasswordMenuState extends State<PasswordMenu> {
  bool viewPassword = false;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  void clearFields() {
    widget.application.clear();
    widget.username.clear();
    widget.password.clear();
    widget.url.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Password'),
      content: SingleChildScrollView(
        child: Column(
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
                    viewPassword ? Icons.visibility : Icons.visibility_off,
                    color: viewPassword ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => viewPassword = !viewPassword);
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
            await storage.write(
              key: widget.application.text,
              value: widget.password.text,
            );

            widget.onSave({
              'application': widget.application.text,
              'username': widget.username.text,
              'password': widget.password.text,
              'url': widget.url.text,
            });
            clearFields();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
