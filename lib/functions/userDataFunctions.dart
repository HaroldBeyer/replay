import 'package:replay/interfaces/userData.interrface.dart'
    show UserDataInterface;
import 'package:shared_preferences/shared_preferences.dart';

class UserDataFunctions {
  SharedPreferences? sp;

  Future<SharedPreferences> fetchSharedPreferences() async {
    if (sp != null) {
      return sp as SharedPreferences;
    }

    sp = await SharedPreferences.getInstance();

    return sp as SharedPreferences;
  }

  Future<bool> hasUserData() async {
    SharedPreferences shp = await fetchSharedPreferences();

    String? spUserId = shp.getString('userId');
    String? spUserName = shp.getString('userName');
    String? spRefreshToken = shp.getString('refreshToken');
    String? spAccessToken = shp.getString('accessToken');

    if (spUserId != null &&
        spUserName != null &&
        spRefreshToken != null &&
        spAccessToken != null) {
      return true;
    }

    return false;
  }

  Future<UserDataInterface> fetchUserData() async {
    SharedPreferences shp = await fetchSharedPreferences();

    String? spUserId = shp.getString('userId');
    String? spUserName = shp.getString('userName');
    String? spRefreshToken = shp.getString('refreshToken');
    String? spAccessToken = shp.getString('accessToken');

    if (spUserId != null &&
        spUserName != null &&
        spRefreshToken != null &&
        spAccessToken != null) {
      return UserDataInterface(
          spAccessToken, spRefreshToken, spUserName, spUserId);
    }

    throw Error();
  }

  Future<void> saveUserData(UserDataInterface data) async {
    SharedPreferences shp = await fetchSharedPreferences();
    await shp.setString('userId', data.userId);
    await shp.setString('userName', data.userName);
    await shp.setString('accessToken', data.accessToken);
    await shp.setString('refreshToken', data.refreshToken);
  }
}
