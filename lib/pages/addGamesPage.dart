import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:replay/functions/userDataFunctions.dart';
import 'package:replay/interfaces/game.interface.dart';
import 'package:replay/interfaces/userData.interrface.dart';
import 'package:replay/services/userService/user.service.dart';

import 'mainPage.dart';

class AddGamesPagew extends StatefulWidget {
  const AddGamesPagew({super.key});

  @override
  State<AddGamesPagew> createState() => _AddGamesPagewState();
}

class _AddGamesPagewState extends State<AddGamesPagew> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> sigUpController = {
    'gameName': TextEditingController(),
  };
  late String userId;
  late String userName;
  late String accessToken;
  late String refreshToken;
  late String gameName;
  UserDataFunctions userDataFunctions = UserDataFunctions();
  bool loaded = false;
  late List<GameInterface> gameInterfaceList;

  @override
  void initState() {
    initConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Scaffold(
            appBar: AppBar(),
            backgroundColor: Colors.blueAccent,
            body: Form(
                child: Column(
              children: [
                TextFormField(
                  controller: sigUpController['gameName'],
                  decoration: const InputDecoration(
                    hintText: 'Enter game name',
                  ),
                  key: _formKey,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('add game'),
                              actions: [
                                TextButton(
                                  child: const Text("yes"),
                                  onPressed: () async {
                                    await insertGames();
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainPage()));
                                  },
                                ),
                                TextButton(
                                    onPressed: () =>
                                        {Navigator.pop(context, 'cancel')},
                                    child: const Text("no"))
                              ],
                              content:
                                  const Text('do you confirm adding the game?'),
                            )),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            )),
          )
        : const CircularProgressIndicator(
            backgroundColor: Colors.amber,
          );
  }

  Future<void> insertGames() async {
    UserService userService =
        UserService(accessToken, refreshToken, userId, userName);
    final data = sigUpController.data();
    await userService.postGame(data['gameName'], 'generic');
  }

  Future<void> initConfig() async {
    await fetchUserData();

    setState(() {
      loaded = true;
    });
  }

  Future<void> fetchUserData() async {
    UserDataInterface userDataInterface =
        await userDataFunctions.fetchUserData();
    userId = userDataInterface.userId;
    userName = userDataInterface.userName;
    refreshToken = userDataInterface.refreshToken;
    accessToken = userDataInterface.accessToken;
  }
}

extension Data on Map<String, TextEditingController> {
  Map<String, dynamic> data() {
    final res = <String, dynamic>{};
    for (MapEntry e in entries) {
      res.putIfAbsent(e.key, () => e.value?.text);
    }
    return res;
  }
}
