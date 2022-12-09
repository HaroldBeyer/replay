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

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    checkIfLogged(context);
    return FlutterLogin(
      onLogin: onSignIn,
      onRecoverPassword: onMock,
      title: 'Replay',
      onSignup: onSignUp,
      onConfirmSignup: onConfirmSignUp,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainPage(),
        ));
      },
    );
  }

  Future<String?> onMock(data) {
    return Future.delayed(Duration.zero).then((value) => null);
  }

  Future<String?> onSignIn(LoginData loginData) async {
    try {
      final result = await Amplify.Auth.signIn(
          username: loginData.name, password: loginData.password);
      log(result.toString());
      final user = await Amplify.Auth.getCurrentUser();
      await sp.setString('user', user.userId);
      return null;
    } catch (e) {
      log('pifed');
      rethrow;
    }
  }

  Future<String?> onConfirmSignUp(
      String confirmationCode, LoginData loginData) async {
    try {
      await Amplify.Auth.confirmSignUp(
          username: loginData.name, confirmationCode: confirmationCode);
      return null;
    } on Exception {
      rethrow;
    }
  }

  Future<String?> onSignUp(SignupData signupData) async {
    try {
      if (signupData.password == null && signupData.name == null) {
        log('no signup data has been passed on!');
        throw Exception();
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
      rethrow;
    }
  }

  Future<void> _configureAmplify() async {
    await Amplify.addPlugins([AmplifyAuthCognito()]);
    await Amplify.configure(amplifyconfig);
  }

  void checkIfLogged(BuildContext context) async {
    try {
      if (sp.getString('user') != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }

      final test = await Amplify.Auth.getCurrentUser();
      await sp.setString('user', test.userId);
    } catch (e) {
      log('no aws user found! continuing' + e.toString());
    }
  }
}
