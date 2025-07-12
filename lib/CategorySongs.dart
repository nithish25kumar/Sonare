import 'package:Sonera/presentation/song_player/pages/song_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/configs/constants/app_urls.dart';
import '../../../domain/entities/song/song.dart';

class CategorySongs extends StatelessWidget {
  final String category;

  const CategorySongs({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Songs')
          .where('category', isEqualTo: category)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No songs found.'));
        }

        final songs = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return SongEntity(
            title: data['title'] ?? '',
            artist: data['artist'] ?? '',
            songUrl: data['songUrl'] ?? '',
            coverUrl: data['coverUrl'] ?? AppURLs.defaultImage,
            duration: (data['duration'] ?? 0).toDouble(),
            releaseDate: data['releaseDate'],
            isFavorite: data['isFavorite'] ?? false,
            songId: doc.id,
            category: '',
          );
        }).toList();

        return _songs(context, songs);
      },
    );
  }

  Widget _songs(BuildContext context, List<SongEntity> songs) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        height: 200,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: songs.length,
          separatorBuilder: (context, index) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final song = songs[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SongPlayerPage(
                      allSongs: songs,
                      currentIndex: index,
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          song.coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              AppURLs.defaultImage,
                              fit: BoxFit.cover,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      song.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      song.artist,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
