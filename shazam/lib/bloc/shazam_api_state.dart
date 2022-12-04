part of 'shazam_api_bloc.dart';

abstract class ShazamApiState extends Equatable {
  const ShazamApiState();

  @override
  List<Object?> get props => [];
}

class ShazamApiInitialState extends ShazamApiState {}

class ShazamListeningState extends ShazamApiState {}

class ShazamFoundState extends ShazamApiState {
  final Song song;

  ShazamFoundState({required this.song});

  @override
  List<Object?> get props => [song];
}

class ShazamNotFoundState extends ShazamApiState {}
