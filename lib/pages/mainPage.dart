import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:replay/functions/userDataFunctions.dart';
import 'package:replay/interfaces/userData.interrface.dart';

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
            appBar: AppBar(),
            body: Container(
              child: Text(userName),
            ),
            backgroundColor: Colors.blueAccent,
            endDrawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    onTap: () => {log('TOUCHED GAMES')},
                    leading: Icon(Icons.games),
                    title: Text('view games'),
                  ),
                  ListTile(
                    onTap: () => {log('TOUCHED ADD')},
                    leading: Icon(Icons.add),
                    title: Text('add game'),
                  ),
                  ListTile(
                    onTap: () => {log('TOUCHED ALT ROUNDEDS')},
                    leading: Icon(Icons.list_alt_rounded),
                    title: Text('view lists'),
                  )
                ],
                primary: false,
              ),
              backgroundColor: Colors.amber,
              width: 2000,
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
