import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:replay/functions/userDataFunctions.dart';
import 'package:replay/interfaces/game.interface.dart';
import 'package:replay/interfaces/userData.interrface.dart';
import 'package:replay/services/userService/user.service.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late String userId;
  late String userName;
  late String accessToken;
  late String refreshToken;
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
            body: ListView.builder(
              itemCount: gameInterfaceList.length,
              itemBuilder: ((context, index) =>
                  Text(gameInterfaceList[index].name)),
            ),
          )
        : CircularProgressIndicator(
            backgroundColor: Colors.amber,
          );
  }

  Future<void> getGames() async {
    UserService userService =
        UserService(accessToken, refreshToken, userId, userName);
    final resultRequest = gameInterfaceList = await userService.getGames();
  }

  Future<void> initConfig() async {
    await fetchUserData();
    await getGames();

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
