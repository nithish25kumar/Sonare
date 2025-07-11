import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import 'song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();

  Duration songPosition = Duration.zero;
  Duration songDuration = Duration.zero;
  String? currentUrl;
  bool isListening = false;

  SongPlayerCubit() : super(SongPlayerInitial());

  Future<void> loadSong(String url) async {
    if (currentUrl == url && audioPlayer.playing) {
      emit(SongPlayerLoaded());
      return;
    }

    emit(SongPlayerLoading());

    try {
      currentUrl = url;
      await audioPlayer.setUrl(url);
      songDuration = audioPlayer.duration ?? Duration.zero;

      if (!isListening) {
        isListening = true;
        audioPlayer.positionStream.listen((position) {
          songPosition = position;
          emit(SongPlayerLoaded());
        });
      }

      audioPlayer.play();
      emit(SongPlayerLoaded());
    } catch (e) {
      emit(SongPlayerError(e.toString()));
    }
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    emit(SongPlayerLoaded());
  }

  void seekTo(Duration position) {
    audioPlayer.seek(position);
    songPosition = position;
    emit(SongPlayerLoaded());
  }

  void updateSlider(Duration position) {
    songPosition = position;
    emit(SongPlayerLoaded());
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
