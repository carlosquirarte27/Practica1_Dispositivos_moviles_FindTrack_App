import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import '../favorites/favorites_operations.dart';
import 'song.dart';
part 'shazam_api_event.dart';
part 'shazam_api_state.dart';

final record = Record();

class ShazamApiBloc extends Bloc<ShazamApiEvent, ShazamApiState> {
  ShazamApiBloc() : super(ShazamApiInitialState()) {
    on<ShazamApiEvent>(hear);
  }

  FutureOr<void> hear(event, emit) async {
    bool permision = await record.hasPermission();
    if (!permision) {
      emit(ShazamNotFoundState());
    } else {
      emit(ShazamListeningState());
      Directory temp = await getTemporaryDirectory();
      String? finalPath = '${temp.path}+Try.mp3';
      await record.start(path: finalPath);
      await Future.delayed(const Duration(seconds: 5), () {});
      finalPath = await record.stop();
      Uri url =
          Uri.parse('https://api.audd.io/?return=spotify,lyrics,apple_music');
      try {
        var request = MultipartRequest('POST', url);
        request.fields["api_token"] = "f3dfe2113c0721205d38bccc03e61153";
        request.headers['Content-Type'] = 'multipart/form-data';
        MultipartFile file = await MultipartFile.fromPath(
          'file',
          finalPath!,
        );
        request.files.add(file);
        StreamedResponse val;
        var res = await Response.fromStream(await request.send());

        if (res.statusCode != 200) {
          throw new HttpException(res.reasonPhrase!);
        }

        dynamic resultado = jsonDecode(res.body);
        if (resultado['result'] == null) {
          emit(ShazamNotFoundState());
        } else {
          var artist = '';
          var title = '';
          var album = '';
          var image = '';
          var apple = '';
          var spotify = '';
          var g_link = '';
          if (resultado['result']?['artist'] != null) {
            artist = resultado['result']?['artist'];
          }
          if (resultado['result']?['title'] != null) {
            title = resultado['result']?['title'];
          }
          if (resultado['result']?['album'] != null) {
            album = resultado['result']?['album'];
          }
          if (resultado['result']?['spotify']?['album']?['images'][0]['url'] !=
              null) {
            image =
                resultado['result']?['spotify']?['album']?['images'][0]['url'];
          }

          if (resultado['result']?['apple_music']?['url'] != null) {
            apple = resultado['result']?['apple_music']?['url'];
          }
          if (resultado['result']?['spotify']?['external_urls']['spotify'] !=
              null) {
            spotify =
                resultado['result']?['spotify']?['external_urls']['spotify'];
          }
          if (resultado['result']?['song_link'] != null) {
            g_link = resultado['result']?['song_link'];
          }

          Song foundsong = Song(
            title: title,
            album: album,
            artist: artist,
            image: image,
            apple: apple,
            spotify: spotify,
            g_link: g_link,
            user: auth.currentUser!.uid.toString(),
            id: '',
            favorite: false,
          );

          Song fullSongObject = await FSAccess().getSongObject(foundsong);

          emit(ShazamFoundState(song: fullSongObject));
        }
      } catch (e) {
        print('Error: ' + e.toString());
      }
    }
    //emit(ShazamApiInitialState());
  }
}
