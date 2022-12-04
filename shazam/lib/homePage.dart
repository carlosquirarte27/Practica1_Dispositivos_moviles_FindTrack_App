import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'auth/bloc/auth_bloc.dart';
import 'favorites/favorites.dart';

import 'found_song.dart';
import 'bloc/shazam_api_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String actualText = 'Tap to shazam';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF042442),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                actualText,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 40),
              BlocConsumer<ShazamApiBloc, ShazamApiState>(
                listener: (context, state) {
                  if (state is ShazamListeningState) {
                    actualText = 'Listening...';
                  } else if (state is ShazamFoundState) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => foundSong(song: state.song),
                    ));
                  } else if (state is ShazamNotFoundState) {
                    actualText = 'Not found, try again!';
                  } else {
                    actualText = 'Tap to Shazam';
                  }
                  setState(() {});
                },
                builder: (context, state) {
                  if (state is ShazamListeningState) {
                    return AvatarGlow(
                      endRadius: 200,
                      animate: true,
                      child: GestureDetector(
                        onTap: () => print('Tapped'),
                        child: Material(
                          shape: const CircleBorder(),
                          elevation: 8,
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            height: 200,
                            width: 200,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF089af8)),
                            child: Image.asset(
                              'assets/spotify.png',
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        context.read<ShazamApiBloc>().add(ListeningEvent());
                        setState(() {});
                      },
                      child: Material(
                        shape: const CircleBorder(),
                        elevation: 8,
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          height: 200,
                          width: 200,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFF089af8)),
                          child: Image.asset('assets/spotify.png', height: 10),
                        ),
                      ),
                    );
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const favoriteList(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 182, 193, 255)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        const CircleBorder(),
                      ),
                      fixedSize:
                          MaterialStateProperty.all(const Size.fromRadius(10)),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 182, 193, 255)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        const CircleBorder(),
                      ),
                      fixedSize:
                          MaterialStateProperty.all(const Size.fromRadius(10)),
                    ),
                    child: const Icon(
                      Icons.login,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
