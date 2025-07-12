import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/song/song.dart';
import 'play_list_state.dart';

class PlayListCubit extends Cubit<PlayListState> {
  PlayListCubit() : super(PlayListLoading());

  Future<void> getPlayList() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Songs').get();

      final songs = snapshot.docs.map((doc) {
        final data = doc.data();
        return SongEntity(
          title: data['title'] ?? '',
          artist: data['artist'] ?? '',
          songUrl: data['songUrl'] ?? '',
          coverUrl: data['coverUrl'] ?? '',
          duration: (data['duration'] ?? 0).toDouble(),
          releaseDate: data['releaseDate'], // Can be null
          isFavorite: data['isFavorite'] ?? false,
          songId: doc.id,
          category: data['category'] ?? '',
        );
      }).toList();

      emit(PlayListLoaded(songs: songs));
    } catch (e) {
      emit(PlayListLoadFailure());
    }
  }

  Future<List<SongEntity>> getPlayListDirect() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Songs').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return SongEntity(
          title: data['title'] ?? '',
          artist: data['artist'] ?? '',
          songUrl: data['songUrl'] ?? '',
          coverUrl: data['coverUrl'] ?? '',
          duration: (data['duration'] ?? 0).toDouble(),
          releaseDate: data['releaseDate'], // Can be null
          isFavorite: data['isFavorite'] ?? false,
          songId: doc.id,
          category: data['category'] ?? '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
