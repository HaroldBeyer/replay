import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AuthUser? authUser;

  @override
  void initState() {
    _getAmplifyUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(authUser?.username ?? ''),
      ),
    );
  }

  Future<void> _getAmplifyUser() async {
    final auxAuthUser = await Amplify.Auth.getCurrentUser();
    log(auxAuthUser.toString());
    authUser = auxAuthUser;
    // setState(() {
    //   authUser = auxAuthUser;
    // });
  }
}
