import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../bloc/song.dart';

final fstore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class FSAccess {
  FutureOr<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getFavorites() async {
    // query para obtener la lista de favoritos
    var queryUser = fstore
        .collection("songs")
        .where('user', isEqualTo: auth.currentUser!.uid.toString());

    // query para sacar la data del documento
    var docsRef = await queryUser.get();

    return docsRef.docs.toList();
  }

  FutureOr<Song> getSongObject(Song song) async {
    // query para buscar si la cancion existe
    var tryGetAlreadyFavorite = fstore
        .collection("songs")
        .where('user', isEqualTo: auth.currentUser!.uid.toString())
        .where('title', isEqualTo: song.title)
        .where('album', isEqualTo: song.album)
        .where('artist', isEqualTo: song.artist)
        .where('image', isEqualTo: song.image)
        .where('apple', isEqualTo: song.apple)
        .where('spotify', isEqualTo: song.spotify)
        .where('g_link', isEqualTo: song.g_link);

    var alreadyFavFound = await tryGetAlreadyFavorite.get();
    //var foundSongData = alreadyFavFound.docs[0].data();

    /*if (alreadyFavFound.docs.isNotEmpty) {
      Song foundsong = Song.fromMap(foundSongData);
      foundsong.favorite = true;
      return foundsong;
    }*/
    return song;
  }

  FutureOr<String> addFavorite(Song song) async {
    // query para buscar si la cancion existe
    var tryGetAlreadyFavorite = await getSongObject(song);

    if (tryGetAlreadyFavorite.id.isNotEmpty) return tryGetAlreadyFavorite.id;

    Song newSong = Song(
      title: song.title,
      album: song.album,
      artist: song.artist,
      image: song.image,
      apple: song.apple,
      spotify: song.spotify,
      g_link: song.g_link,
      user: song.user,
      id: song.id,
      favorite: song.favorite,
    );
    var newSongRef = await fstore.collection('songs').add(newSong.toMap());
    return newSongRef.id;
  }

  FutureOr<void> deleteFavorite(String songId) async {
    // query para eliminar la cancion especificada
    await fstore.collection("songs").doc(songId).delete();
  }
}
