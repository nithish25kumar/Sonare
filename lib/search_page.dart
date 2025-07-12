import 'package:Sonera/presentation/song_player/pages/song_player.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/song/song.dart';

class SearchPage extends StatefulWidget {
  final List<SongEntity> allSongs;

  const SearchPage({super.key, required this.allSongs});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SongEntity> filteredSongs = [];

  @override
  void initState() {
    super.initState();
    filteredSongs = widget.allSongs;
  }

  void _filterSongs(String query) {
    final matches = widget.allSongs.where((song) =>
        song.title.toLowerCase().contains(query.toLowerCase()) ||
        song.artist.toLowerCase().contains(query.toLowerCase()));

    final uniqueFiltered = <String, SongEntity>{};
    for (var song in matches) {
      final key = '${song.title}_${song.artist}'.toLowerCase();
      uniqueFiltered[key] = song;
    }

    setState(() {
      filteredSongs = uniqueFiltered.values.toList();
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search songs...',
            prefixIcon: const Icon(Icons.search, size: 20),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 1.2),
            ),
          ),
          onChanged: _filterSongs,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song.coverUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.music_note),
                    ),
                  ),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SongPlayerPage(
                          allSongs: filteredSongs,
                          currentIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
