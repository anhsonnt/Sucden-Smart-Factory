import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sucden_smart_factory/widgets/login.dart';
// import 'package:sucden_smart_factory/widgets/login_test.dart';
import 'package:sucden_smart_factory/widgets/scanner_form.dart';
// import 'package:sucden_smart_factory/widgets/dropdown_menu.dart';

void main() {
  // HttpClient client = new HttpClient();
  // client.badCertificateCallback =((X509Certificate cert, String  host, int port) => true);
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyAppDesign();
  }
}

class MyAppDesign extends StatelessWidget {
  const MyAppDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login':(context)=> Login(),
        '/scannerForm':(context)=> ScannerForm(),
        // '/dropMenu':(context)=> DropMenu(),
      },
    );
  }
}
