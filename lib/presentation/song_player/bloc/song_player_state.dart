abstract class SongPlayerState {}

class SongPlayerInitial extends SongPlayerState {}

class SongPlayerLoading extends SongPlayerState {}

class SongPlayerLoaded extends SongPlayerState {}

class SongPlayerError extends SongPlayerState {
  final String message;
  SongPlayerError(this.message);
}
