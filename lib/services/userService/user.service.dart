import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:replay/interfaces/game.interface.dart';

class UserService {
  String url = dotenv.env['BACKEND_URL'] as String;
  late String userId;
  late String userName;
  late String accessToken;
  late String refreshToken;

  UserService(this.accessToken, this.refreshToken, this.userId, this.userName);

  Future<void> postUser(String userId, String userName) async {
    try {
      Response response = await http.put(Uri.parse('$url/users'),
          body: jsonEncode({'userId': userId, 'name': userName}),
          headers: <String, String>{
            'Authorization': accessToken,
            'Content-Type': 'application/json; charset=UTF-8'
          });
      log("Response: $response");
    } catch (e) {
      log("error: $e");
      rethrow;
    }
  }

  Future<void> postGame(String name, String genre) async {
    try {
      await http.post(Uri.parse('$url/games'),
          body: jsonEncode({'name': name, 'genre': genre}),
          headers: <String, String>{
            'Authorization': accessToken,
            'Content-Type': 'application/json; charset=UTF-8'
          });
    } catch (e) {
      log("error: $e");
      rethrow;
    }
  }

  Future<void> updateGameRating(String gameId, int rating) async {
    try {
      await http.patch(Uri.parse('$url/games'),
          body: jsonEncode({"gameId": gameId, "rating": rating}),
          headers: <String, String>{
            'Authorization': accessToken,
            'Content-Type': 'application/json; charset=UTF-8'
          });
    } catch (e) {
      log('error while trying to update game rating: $e');
      rethrow;
    }
  }

  Future<void> postGameRating(
      String userId, String gameId, int rating, String comment) async {
    Response response = await http.post(Uri.parse('$url/gameRatings'),
        body: jsonEncode({
          "userId": userId,
          "gameId": gameId,
          "rating": rating,
          "comment": comment
        }),
        headers: <String, String>{
          'Authorization': accessToken,
          'Content-Type': 'application/json; charset=UTF-8'
        });
    log("Response: $response");
  }

  Future<void> postGenre(String name) async {
    Response response = await http.post(Uri.parse('$url/genres'),
        body: {name}, headers: {'Authorization': refreshToken});
    log("Response: $response");
  }

  Future<void> postGamesList(String userId, List<String> gamesId) async {
    Response response = await http.put(Uri.parse('$url/games/list'),
        body: {userId, gamesId}, headers: {'Authorization': refreshToken});
    log("Response: $response");
  }

  Future<List<GameInterface>> getGames() async {
    try {
      Response response = await http.get(Uri.parse('$url/games'),
          headers: <String, String>{
            'Authorization': accessToken,
            'Content-Type': 'application/json; charset=UTF-8'
          });
      log("Response: $response");
      final decodedBody = jsonDecode(response.body);
      log("decoded body: $decodedBody");
      final List<GameInterface> result =
          fetchGameInterfaceFromJson(decodedBody);

      return result;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getGameLists(String userId) async {
    Response response = await http.get(
      Uri.parse('$url/games/list'),
      headers: {'Authorization': refreshToken},
    );
    log("Response: $response");
  }
}
