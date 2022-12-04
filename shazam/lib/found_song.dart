import 'package:flutter/material.dart';
import 'bloc/song.dart';
import 'favorites/item_fav.dart';
import 'package:url_launcher/url_launcher.dart';

class foundSong extends StatefulWidget {
  final Song song;
  const foundSong({super.key, required this.song});

  @override
  State<foundSong> createState() => _foundSongState();
}

void _launchURL(_url) async {
  if (!await launch(_url)) throw 'No se pudo acceder a: $_url';
}

class _foundSongState extends State<foundSong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Found song: "),
      ),
      body: Container(
        child: Column(
          children: [
            ItemFav(song: widget.song),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    _launchURL(widget.song.spotify);
                  },
                  icon: Icon(Icons.music_note),
                  color: Colors.white,
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    _launchURL(widget.song.spotify);
                  },
                  icon: Icon(Icons.podcasts_rounded),
                  color: Colors.white,
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    _launchURL(widget.song.apple);
                  },
                  icon: Icon(Icons.apple),
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
