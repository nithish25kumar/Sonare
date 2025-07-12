// ✅ Full SongPlayerPage with Global Cubit Support

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../common/widgets/favorite_button/favorite_button.dart';
import '../../../core/configs/constants/app_urls.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/song/song.dart';
import '../../../service_locator.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';

class SongPlayerPage extends StatefulWidget {
  final List<SongEntity> allSongs;
  final int currentIndex;

  const SongPlayerPage({
    super.key,
    required this.allSongs,
    required this.currentIndex,
  });

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  late int currentIndex;
  late SongEntity currentSong;
  final cubit = sl<SongPlayerCubit>();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    currentSong = widget.allSongs[currentIndex];
    cubit.loadSong(currentSong.songUrl, currentSong);
    _listenForSongEnd();
  }

  void _listenForSongEnd() {
    cubit.audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playNext();
      }
    });
  }

  void playNext() {
    if (currentIndex < widget.allSongs.length - 1) {
      setState(() {
        currentIndex++;
        currentSong = widget.allSongs[currentIndex];
      });
      cubit.loadSong(currentSong.songUrl, currentSong);
    }
  }

  void playPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        currentSong = widget.allSongs[currentIndex];
      });
      cubit.loadSong(currentSong.songUrl, currentSong);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text('Now playing', style: TextStyle(fontSize: 18)),
        action: IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            final song = currentSong;
            final shareText =
                '🎶 Listen to "${song.title}" by ${song.artist}!\n${song.songUrl}';
            Share.share(shareText);
          },
        ),
      ),
      body: BlocProvider.value(
        value: cubit,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              _songCover(context),
              const SizedBox(height: 20),
              _songDetail(),
              const SizedBox(height: 30),
              _songPlayer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          currentSong.coverUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Image.network(AppURLs.defaultImage, fit: BoxFit.cover),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(currentSong.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 5),
              Text(currentSong.artist,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 14)),
            ],
          ),
        ),
        FavoriteButton(songEntity: currentSong),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        final position = cubit.songPosition;
        final duration = cubit.songDuration;

        if (state is SongPlayerLoading) {
          return const CircularProgressIndicator();
        }

        if (state is SongPlayerLoaded) {
          return Column(
            children: [
              Slider(
                value: position.inSeconds
                    .toDouble()
                    .clamp(0.0, duration.inSeconds.toDouble()),
                min: 0.0,
                max: duration.inSeconds.toDouble(),
                onChanged: (value) {
                  cubit.updateSlider(Duration(seconds: value.toInt()));
                },
                onChangeEnd: (value) {
                  cubit.seekTo(Duration(seconds: value.toInt()));
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(position)),
                  Text(_formatDuration(duration)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded, size: 40),
                    onPressed: playPrevious,
                  ),
                  GestureDetector(
                    onTap: cubit.playOrPauseSong,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Icon(
                        cubit.audioPlayer.playing
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded, size: 40),
                    onPressed: playNext,
                  ),
                ],
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
