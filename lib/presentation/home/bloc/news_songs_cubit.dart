import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/song/song.dart';
import '../../../domain/usecases/song/get_news_songs.dart';
import '../../../service_locator.dart';
import 'news_songs_state.dart';

class NewsSongsCubit extends Cubit<NewsSongsState> {
  NewsSongsCubit() : super(NewsSongsLoading());

  Future<void> getNewsSongs() async {
    var returnedSongs = await sl<GetNewsSongsUseCase>().call();
    returnedSongs.fold((l) {
      emit(NewsSongsLoadFailure());
    }, (data) {
      emit(NewsSongsLoaded(songs: data));
    });
  }

  Future<List<SongEntity>> getNewsSongsDirect() async {
    final result = await sl<GetNewsSongsUseCase>().call();
    return result.fold(
      (l) => [],
      (r) => r,
    );
  }
}
