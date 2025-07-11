import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../common/widgets/favorite_button/favorite_button.dart';
import '../../../core/configs/constants/app_urls.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/song/song.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  const SongPlayerPage({required this.songEntity, super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SongPlayerCubit>();
    cubit.loadSong(songEntity.songUrl);

    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Now playing',
          style: TextStyle(fontSize: 18),
        ),
        action: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ),
      body: SingleChildScrollView(
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
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          songEntity.coverUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(AppURLs.defaultImage, fit: BoxFit.cover);
          },
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
              Text(
                songEntity.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 5),
              Text(
                songEntity.artist,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ],
          ),
        ),
        FavoriteButton(songEntity: songEntity),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        final cubit = context.read<SongPlayerCubit>();
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
                  Text(formatDuration(position)),
                  Text(formatDuration(duration)),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => cubit.playOrPauseSong(),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(
                    cubit.audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
