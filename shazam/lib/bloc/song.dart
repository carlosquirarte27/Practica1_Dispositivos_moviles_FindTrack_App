class Song {
  String title;
  String album;
  String artist;
  String image;
  String apple;
  String spotify;
  String g_link;
  String user;
  String id;
  bool favorite;

  Song(
      {required this.title,
      required this.album,
      required this.artist,
      required this.image,
      required this.apple,
      required this.spotify,
      required this.g_link,
      required this.user,
      required this.id,
      required this.favorite});

  static Song fromMap(Map<String, dynamic> songData) {
    String title = songData["title"];
    String album = songData["album"];
    String artist = songData["artist"];
    String image = songData["image"];
    String apple = songData["apple"];
    String spotify = songData["spotify"];
    String g_link = songData["g_link"];
    String user = songData["user"];
    String id = songData["id"];
    bool favorite = songData["favorite"];
    Song toCreate = Song(
      title: title,
      album: album,
      artist: artist,
      image: image,
      apple: apple,
      spotify: spotify,
      g_link: g_link,
      user: user,
      id: id,
      favorite: favorite,
    );
    return toCreate;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'album': album,
      'artist': artist,
      'image': image,
      'apple': apple,
      'spotify': spotify,
      'g_link': g_link,
      'user': user,
      'id': id,
      'favorite': favorite.toString(),
    };
  }
}
