import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'master_password.dart';

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
          seedColor: const Color.fromARGB(255, 0, 71, 171)),
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
  List<Map<String, String>> passwords = [];

  Future<String?> addPasswordMenu(context) => showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Password'),
        content: SingleChildScrollView(
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
                color: Color(0xff000000)),
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
                    color: Color(0xff000000)),
                    filled: true,
                    fillColor: const Color(0xFFFFFFFF),
                    isDense: false,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, 
                      horizontal: 12.0,
                    ),
                    icon: const Icon(Icons.apps_sharp),
                ),),
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
                color: Color(0xff000000)),
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
                    color: Color(0xff000000)),
                    filled: true,
                    fillColor: const Color(0xFFFFFFFF),
                    isDense: false,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, 
                      horizontal: 12.0,
                    ),
                    icon: const Icon(Icons.person),
                ),),
                const SizedBox(height: 9.0, width: 500.0),

                TextFormField(
              controller: widget.password,
              obscureText: false,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: Color(0xff000000)),
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
                    color: Color(0xff000000)),
                    filled: true,
                    fillColor: const Color(0xFFFFFFFF),
                    isDense: false,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, 
                      horizontal: 12.0,
                    ),
                    icon: const Icon(Icons.security),
                ),),
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
                color: Color(0xff000000)),
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
                    color: Color(0xff000000)),
                    filled: true,
                    fillColor: const Color(0xFFFFFFFF),
                    isDense: false,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, 
                      horizontal: 12.0,
                    ),
                    icon: const Icon(Icons.link),
                ),),
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
            onPressed: () {
              // Add your add action here
              setState(() {
                passwords.add({
                  'application': widget.application.text,
                  'username': widget.username.text,
                  'password': widget.password.text,
                  'url': widget.url.text,
                });
              });
              clearFields();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  
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
        title: Text('Password Manager',
          style: const TextStyle(
            fontSize: 25,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w900 // AppBar text color
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
            onPressed: () async{
              await addPasswordMenu(context);
              setState(() {
                
              }); // Show the add password dialog
            }
          ),
        ],
      ),
      // This is the main content of the app. It is a stateful widget, meaning
      body: 
        passwords.isEmpty ? const Center(
          child: Text("database is empty",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF0051A3), // Text color
            ),
          ),
        )
        : ListView.builder(
          itemCount: passwords.length,
          itemBuilder: (context, index) {
            return Card( 
              child: ListTile(
              title: Text(passwords[index]['application'] ?? ''),
              subtitle: Text(passwords[index]['username'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    passwords.removeAt(index);
                  });
                },
              ),
            ));
          },
        ),

    
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
    );
  }
}
