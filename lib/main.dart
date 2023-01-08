import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

/// Changed manifest.xml and .kt
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  ValueNotifier<bool> authenticated = ValueNotifier(false);

  Future<void> _authenticateMe() async {
// this method opens a dialog for fingerprint authentication.
//    we do not need to create a dialog nut it popsup from device natively.
    try {
      authenticated.value = await _localAuthentication.authenticate(
        localizedReason: "Authentication by Zaidraza", // message for dialog
        // useErrorDialogs: true, // show error in dialog
        // stickyAuth: true, // native process
      );
      if (authenticated.value != true) exit(0);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) return;
  }

  @override
  void initState() {
    _authenticateMe();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ValueListenableBuilder<bool>(
            valueListenable: authenticated,
            builder: (context, isAuthenticated, _) {
              return isAuthenticated
                  ? const MyHomePage(title: 'Flutter Demo Home Page')
                  : Container(
                      color: Colors.white,
                    );
            }));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Authenticated',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
