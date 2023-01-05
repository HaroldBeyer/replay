import 'dart:developer';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:replay/amplifyconfiguration.dart';
import 'package:replay/functions/userDataFunctions.dart';
import 'package:replay/interfaces/authSession.interface.dart';
import 'package:replay/interfaces/userData.interrface.dart';
import 'package:replay/pages/mainPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:replay/services/user.service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hasLoaded = false;

  late String userId;
  late String userName;
  late String accessToken;
  late String refreshToken;
  UserDataFunctions userDataFunctions = UserDataFunctions();
  bool hasSignUp = false;

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
                builder: (context) => MainPage(),
              ));
            },
            navigateBackAfterRecovery: true,
            loginAfterSignUp: false,
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
      final authSession = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      userId = user.userId;
      userName = user.username;
      refreshToken = (authSession as CognitoAuthSession)
          .userPoolTokens
          ?.refreshToken as String;
      accessToken = (authSession as CognitoAuthSession)
          .userPoolTokens
          ?.accessToken as String;
      await userDataFunctions.saveUserData(
          UserDataInterface(accessToken, refreshToken, userName, userId));
      if (hasSignUp) {
        await saveUserIntoDb();
      }
      return null;
    } catch (e) {
      log('pifed');
      await Amplify.Auth.signOut();
      return 'error when trying to login';
    }
  }

  Future<String?> onConfirmSignUp(
      String confirmationCode, LoginData loginData) async {
    try {
      final user = await Amplify.Auth.confirmSignUp(
          username: loginData.name, confirmationCode: confirmationCode);
      hasSignUp = true;
      // final authSession = await Amplify.Auth.fetchAuthSession(
      //         options: CognitoSessionOptions(getAWSCredentials: true))
      //     as AuthSessionInterface;
      // accessToken = authSession.userPoolTokens.accessToken;
      // refreshToken = authSession.userPoolTokens.refreshToken;
      // // userId = userLogged.userId;
      // // userName = userLogged.username;
      // await userDataFunctions.saveUserData(
      //     UserDataInterface(accessToken, refreshToken, userName, userId));
      // await saveUserIntoDb();
      return null;
    } catch (e) {
      log('error: ' + e.toString());
      rethrow;
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

  Future<void> saveUserIntoDb() async {
    final userService =
        new UserService(accessToken, refreshToken, userId, userName);
    final userSavedResult = await userService.postUser(userId, userName);
  }

  Future<void> _configureAmplify() async {
    if (!Amplify.isConfigured) {
      await Amplify.addPlugins([AmplifyAuthCognito()]);
      await Amplify.configure(amplifyconfig);
    }
  }

  void checkIfLogged(BuildContext context) async {
    await _configureAmplify();
    await dotenv.load();
    try {
      if (await userDataFunctions.hasUserData()) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
      final user = await Amplify.Auth.getCurrentUser();
      log("user: " + user.toString());
      log("hashcode: " + user.hashCode.toString());
      final authSession = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      userId = user.userId;
      userName = user.username;
      refreshToken = (authSession as CognitoAuthSession)
          .userPoolTokens
          ?.refreshToken as String;
      accessToken = (authSession as CognitoAuthSession)
          .userPoolTokens
          ?.accessToken as String;
      await userDataFunctions.saveUserData(
          UserDataInterface(accessToken, refreshToken, userName, userId));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    } catch (e) {
      log('no aws user found! continuing' + e.toString());
      setState(() {
        hasLoaded = true;
      });
    }
  }
}
