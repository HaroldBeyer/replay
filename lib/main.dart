import 'package:flutter/material.dart';
import 'package:replay/pages/loginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'REplay',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blueGrey),
          home: LoginPage(),
        );
      },
    );
  }
}
