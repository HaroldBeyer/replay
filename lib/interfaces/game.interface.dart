class GameInterface {
  int rating;
  String name;
  String id;
  String genre;
  DateTime? createdAt;
  DateTime? updatedAt;

  GameInterface(
      {required this.genre,
      required this.id,
      required this.name,
      required this.rating,
      this.createdAt,
      this.updatedAt});
}

List<GameInterface> fetchGameInterfaceFromJson(Map<String, dynamic> json) {
  final gamesArray = json['games'];

  List<GameInterface> gameList = [];

  for (var game in gamesArray) {
    final GameInterface gameInterface = GameInterface(
        genre: game['genre'],
        id: game['id'],
        name: game['name'],
        rating: game['rating']);

    gameList.add(gameInterface);
  }

  return gameList;
}
