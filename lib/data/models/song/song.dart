import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/song/song.dart';

class SongModel {
  String? title;
  String? artist;
  num? duration;
  Timestamp? releaseDate;
  bool? isFavorite;
  String? songId;
  String? coverUrl;
  String? songUrl;
  String? category;

  SongModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.isFavorite,
    required this.songId,
    required this.coverUrl,
    required this.songUrl,
    required this.category,
  });

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    releaseDate = data['releaseDate'];
    isFavorite = data['isFavorite'] ?? false;
    songId = data['songId'];
    coverUrl = data['coverUrl'];
    songUrl = data['songUrl'];
    category = data['category'];
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      title: title!,
      artist: artist!,
      duration: duration!,
      releaseDate: releaseDate!,
      isFavorite: isFavorite!,
      songId: songId!,
      coverUrl: coverUrl!,
      songUrl: songUrl!,
      category: category ?? '',
    );
  }
}
