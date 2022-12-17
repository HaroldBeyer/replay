abstract class AuthSessionInterface {
  late UserPoolTokensInterface userPoolTokens;
}

abstract class UserPoolTokensInterface {
  late String accessToken;
  late String refreshToken;
}
