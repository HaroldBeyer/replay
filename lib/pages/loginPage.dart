import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:replay/amplifyconfiguration.dart';
import 'package:replay/pages/mainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences sp;

  bool hasLoaded = false;

  late String userId;
  late String userName;

  @override
  void initState() {
    super.initState();
    checkIfLogged(context);
  }

  @override
  Widget build(BuildContext context) {
    return hasLoaded
        ? FlutterLogin(
            onLogin: onSignIn,
            onRecoverPassword: onMock,
            title: 'Replay',
            onSignup: onSignUp,
            onConfirmSignup: onConfirmSignUp,
            onSubmitAnimationCompleted: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MainPage(
                  userId: userId,
                  userName: userName,
                ),
              ));
            },
            navigateBackAfterRecovery: true,
            loginAfterSignUp: true,
          )
        : CircularProgressIndicator(backgroundColor: Colors.amber);
  }

  Future<String?> onMock(data) {
    return Future.delayed(Duration.zero).then((value) => null);
  }

  Future<String?> onSignIn(LoginData loginData) async {
    try {
      final result = await Amplify.Auth.signIn(
          username: loginData.name, password: loginData.password);
      log('successfull login');
      log(result.toString());
      final user = await Amplify.Auth.getCurrentUser();
      await sp.setString('user', user.userId);
      userId = user.userId;
      userName = user.username;
      return null;
    } catch (e) {
      log('pifed');
      return 'error when trying to login';
    }
  }

  Future<String?> onConfirmSignUp(
      String confirmationCode, LoginData loginData) async {
    try {
      await Amplify.Auth.confirmSignUp(
          username: loginData.name, confirmationCode: confirmationCode);
      return null;
    } catch (e) {
      log('error: ' + e.toString());
      return e as String;
    }
  }

  Future<String?> onSignUp(SignupData signupData) async {
    try {
      if (signupData.password == null && signupData.name == null) {
        log('no signup data has been passed on!');
        return 'no sign up data has been passed';
      }
      final CognitoSignUpOptions options = CognitoSignUpOptions(
          userAttributes: {
            CognitoUserAttributeKey.email: signupData.name as String
          });
      final result = await Amplify.Auth.signUp(
          username: signupData.name as String,
          password: signupData.password as String,
          options: options);
      log('result: ' + result.toString());
      return null;
    } on Exception {
      log('pifed');
      return 'pifed';
    }
  }

  Future<void> _configureAmplify() async {
    await Amplify.addPlugins([AmplifyAuthCognito()]);
    await Amplify.configure(amplifyconfig);
  }

  void checkIfLogged(BuildContext context) async {
    await _configureAmplify();
    sp = await SharedPreferences.getInstance();
    try {
      String? spUserId = sp.getString('userId');
      String? spUserName = sp.getString('userName');
      if (spUserId != null && spUserName != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainPage(
                      userId: spUserId,
                      userName: spUserId,
                    )));
      }
      final user = await Amplify.Auth.getCurrentUser();
      userId = user.userId;
      userName = user.username;
      await sp.setString('userId', userId);
      await sp.setString('userName', userName);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                    userId: userId,
                    userName: userName,
                  )));
    } catch (e) {
      log('no aws user found! continuing' + e.toString());
      setState(() {
        hasLoaded = true;
      });
    }
  }
}
