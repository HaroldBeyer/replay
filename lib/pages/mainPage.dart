import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final String? userId;
  final String? userName;
  const MainPage({super.key, this.userId, this.userName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String? userId;
  late String? userName;
  bool loaded = false;
  @override
  void initState() {
    _getAmplifyUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Scaffold(
            body: Container(
              child: Text(userName ?? ''),
            ),
          )
        : CircularProgressIndicator(backgroundColor: Colors.amber);
  }

  Future<void> _getAmplifyUser() async {
    if (this.widget.userId == null && this.widget.userName == null) {
      final auxAuthUser = await Amplify.Auth.getCurrentUser();
      log(auxAuthUser.toString());
      userId = auxAuthUser.userId;
      userName = auxAuthUser.username;
    }
    userId = widget.userId;
    userName = widget.userName;
    setState(() {
      loaded = true;
    });
  }
}
