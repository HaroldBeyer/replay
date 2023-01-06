import 'dart:developer';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:replay/functions/userDataFunctions.dart';
import 'package:replay/interfaces/userData.interrface.dart';
import 'package:replay/pages/addGamesPage.dart';
import 'package:replay/pages/gamesPage.dart';
import 'package:replay/pages/loginPage.dart';

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
            body: Text(userName),
            backgroundColor: Colors.blueAccent,
            endDrawer: Drawer(
              backgroundColor: Colors.amber,
              width: 2000,
              child: ListView(
                primary: false,
                children: [
                  ListTile(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GamesPage()))
                    },
                    leading: const Icon(Icons.games),
                    title: const Text('view games'),
                  ),
                  ListTile(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddGamesPagew()))
                    },
                    leading: const Icon(Icons.add),
                    title: const Text('add game'),
                  ),
                  ListTile(
                    onTap: () => {log('TOUCHED ALT ROUNDEDS')},
                    leading: const Icon(Icons.list_alt_rounded),
                    title: const Text('view lists'),
                  ),
                  ListTile(
                    onTap: () => {logout()},
                    leading: const Icon(Icons.logout),
                    title: const Text('logout'),
                  ),
                ],
              ),
            ),
          )
        : const CircularProgressIndicator(backgroundColor: Colors.amber);
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

  Future<void> logout() async {
    await Amplify.Auth.signOut();
    userDataFunctions.deleteUserData();
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
