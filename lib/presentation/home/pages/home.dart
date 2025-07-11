import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify2/common/helpers/is_dark_mode.dart';
import 'package:spotify2/presentation/choose_mode/pages/choose_mode.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/constants/app_urls.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/song/song.dart';
import '../../profile/pages/profile.dart';
import '../../song_player/pages/song_player.dart';
import '../bloc/news_songs_cubit.dart';
import '../bloc/play_list_cubit.dart';
import '../widgets/news_songs.dart';
import '../widgets/play_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<SongEntity> allSongs = [];
  List<SongEntity> filteredSongs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    loadAllSongs();
  }

  Future<void> loadAllSongs() async {
    final newsCubit = NewsSongsCubit();
    final playCubit = PlayListCubit();
    final newsSongs = await newsCubit.getNewsSongsDirect();
    final playSongs = await playCubit.getPlayListDirect();

    final combined = [...newsSongs, ...playSongs];
    final uniqueSongs = <String, SongEntity>{};
    for (var song in combined) {
      final key = '${song.title}_${song.artist}'.toLowerCase();
      uniqueSongs[key] = song;
    }

    setState(() {
      allSongs = uniqueSongs.values.toList();
    });
  }

  void _filterSongs(String query) {
    final matches = allSongs.where((song) =>
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

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ChooseModePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 50),
            const Text(
              'Sonare',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        action: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _homeTopCard(),
            _buildSearchBar(),
            if (_searchController.text.isNotEmpty) _buildSearchResults(),
            _tabs(),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                children: [
                  const NewsSongs(),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ),
            const PlayList(),
          ],
        ),
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Image.asset(AppImages.homeArtist),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: false,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      indicatorColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      tabs: const [
        Text(
          'Trending Now',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        )
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SizedBox(
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search songs...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: _filterSongs,
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: filteredSongs.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
              errorBuilder: (context, error, stackTrace) => Image.network(
                AppURLs.defaultImage,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(song.title),
          subtitle: Text(song.artist),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SongPlayerPage(songEntity: song)),
            );
          },
        );
      },
    );
  }
}
