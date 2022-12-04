import 'package:flutter/material.dart';
import 'package:shazam/bloc/song.dart';
import 'package:shazam/favorites/favorites_operations.dart';
import 'item_fav.dart';

class favoriteList extends StatefulWidget {
  const favoriteList({super.key});

  @override
  State<favoriteList> createState() => _favoriteListState();
}

class _favoriteListState extends State<favoriteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: FutureBuilder(
          future: Future.value(FSAccess().getFavorites()),
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                print(snapshot.data[index].data());
                var currentData = snapshot.data[index].data();
                Song currentsong = Song(
                  title: currentData["title"],
                  album: currentData["album"],
                  artist: currentData["artist"],
                  image: currentData["image"],
                  apple: currentData["apple"],
                  spotify: currentData["spotify"],
                  g_link: currentData["g_link"],
                  user: currentData["user"],
                  id: snapshot.data[index].id,
                  favorite: true,
                );
                return ItemFav(song: currentsong);
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
