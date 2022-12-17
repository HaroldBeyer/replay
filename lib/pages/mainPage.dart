import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:replay/functions/userDataFunctions.dart';
import 'package:replay/interfaces/userData.interrface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String userId;
  late String userName;
  late String accessToken;
  late String refreshToken;
  UserDataFunctions userDataFunctions = UserDataFunctions();
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
            backgroundColor: Colors.blueAccent,
            drawer: Drawer(
              child: ListView(),
            ),
          )
        : CircularProgressIndicator(backgroundColor: Colors.amber);
  }

  Future<void> _getAmplifyUser() async {
    UserDataInterface userDataInterface =
        await userDataFunctions.fetchUserData();
    userId = userDataInterface.userId;
    userName = userDataInterface.userName;
    refreshToken = userDataInterface.refreshToken;
    accessToken = userDataInterface.accessToken;

    setState(() {
      loaded = true;
    });
  }
}
