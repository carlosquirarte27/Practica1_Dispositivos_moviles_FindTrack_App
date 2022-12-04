import 'package:flutter/material.dart';
import '../bloc/song.dart';
import 'favorites_operations.dart';

class ItemFav extends StatefulWidget {
  final Song song;
  ItemFav({Key? key, required this.song}) : super(key: key);

  @override
  State<ItemFav> createState() => _ItemFavState();
}

class _ItemFavState extends State<ItemFav> {
  bool _isFavorite = false;
  @override
  void initState() {
    _isFavorite = widget.song.user.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var favDoc = ' ';
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                "${widget.song.image}",
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: _isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () async {
                  _isFavorite = !_isFavorite;

                  if (_isFavorite) {
                    FSAccess().deleteFavorite(favDoc);
                  } else {
                    favDoc = await FSAccess().addFavorite(widget.song);
                    widget.song.id = favDoc;
                  }
                  setState(() {});
                },
              ),
              title: Text(
                widget.song.title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                widget.song.artist,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
