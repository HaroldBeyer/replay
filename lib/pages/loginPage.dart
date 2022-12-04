import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:replay/pages/mainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences sp;

  @override
  Widget build(BuildContext context) {
    checkIfLogged(context);
    return FlutterLogin(
      onLogin: onMock,
      onRecoverPassword: onMock,
      title: 'Replay',
      onSignup: onMock,
    );
  }

  Future<String?> onMock(data) {
    return Future.delayed(Duration.zero).then((value) => null);
  }

  void checkIfLogged(BuildContext context) async {
    if (this.sp == null) this.sp = await SharedPreferences.getInstance();
    if (this.sp.getString('user') != null)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainPage()));
  }
}
