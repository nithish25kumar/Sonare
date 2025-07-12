import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sonera/core/configs/theme/app_colors.dart';
import 'package:Sonera/domain/entities/song/song.dart';
import 'package:Sonera/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:Sonera/presentation/song_player/bloc/song_player_state.dart';
import 'package:Sonera/presentation/song_player/pages/song_player.dart';
import 'package:Sonera/service_locator.dart';
import 'package:just_audio/just_audio.dart';

class MiniPlayer extends StatefulWidget {
  final List<SongEntity> allSongs;

  const MiniPlayer({super.key, required this.allSongs});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final cubit = sl<SongPlayerCubit>();

  @override
  void initState() {
    super.initState();
    cubit.audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        final current = cubit.currentSong;
        final index =
            widget.allSongs.indexWhere((s) => s.songUrl == current?.songUrl);
        if (index != -1 && index < widget.allSongs.length - 1) {
          final next = widget.allSongs[index + 1];
          cubit.loadSong(next.songUrl, next);
        }
      }
    });
  }

  void playNext() {
    final current = cubit.currentSong;
    final index =
        widget.allSongs.indexWhere((s) => s.songUrl == current?.songUrl);
    if (index != -1 && index < widget.allSongs.length - 1) {
      final next = widget.allSongs[index + 1];
      cubit.loadSong(next.songUrl, next);
    }
  }

  void playPrevious() {
    final current = cubit.currentSong;
    final index =
        widget.allSongs.indexWhere((s) => s.songUrl == current?.songUrl);
    if (index > 0) {
      final prev = widget.allSongs[index - 1];
      cubit.loadSong(prev.songUrl, prev);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      bloc: cubit,
      builder: (context, state) {
        final song = cubit.currentSong;
        final position = cubit.songPosition;
        final duration = cubit.songDuration;

        if (song == null || state is SongPlayerInitial) return const SizedBox();

        return GestureDetector(
          onTap: () {
            final index =
                widget.allSongs.indexWhere((s) => s.songUrl == song.songUrl);
            if (index != -1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SongPlayerPage(
                    allSongs: widget.allSongs,
                    currentIndex: index,
                  ),
                ),
              );
            }
          },
          child: SafeArea(
            top: false,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 64,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      song.coverUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(song.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(song.artist,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: playPrevious,
                    icon: const Icon(Icons.skip_previous,
                        size: 22, color: Colors.white),
                  ),
                  Text(
                    '${_format(position)} / ${_format(duration)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  IconButton(
                    onPressed: playNext,
                    icon: const Icon(Icons.skip_next,
                        size: 22, color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(
                      cubit.audioPlayer.playing
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: cubit.playOrPauseSong,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _format(Duration duration) {
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }
}
