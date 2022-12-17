class UserDataInterface {
  late String userName;
  late String userId;
  late String accessToken;
  late String refreshToken;

  UserDataInterface(
      this.accessToken, this.refreshToken, this.userName, this.userId);
}
