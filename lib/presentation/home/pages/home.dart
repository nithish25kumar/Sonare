import 'package:Sonera/creatorpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Sonera/common/helpers/is_dark_mode.dart';
import 'package:Sonera/core/configs/assets/app_images.dart';
import 'package:Sonera/core/configs/assets/app_vectors.dart';
import 'package:Sonera/core/configs/theme/app_colors.dart';
import 'package:Sonera/domain/entities/song/song.dart';
import 'package:Sonera/presentation/profile/pages/profile.dart';
import 'package:Sonera/presentation/home/widgets/play_list.dart';
import 'package:Sonera/presentation/home/bloc/news_songs_cubit.dart';
import 'package:Sonera/presentation/home/bloc/play_list_cubit.dart';
import 'package:Sonera/common/widgets/appbar/app_bar.dart';

import '../../../CategorySongs.dart';
import '../../../miniplayer.dart';
import '../../../search_page.dart';

//home page stateful widget uses to perform functions
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //initialized tabcontroller,TextEditingController with variables
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<SongEntity> allSongs = [];
  List<SongEntity> filteredSongs = [];

  @override
  void initState() {
    //Initial tabcontroller by giving length 4
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.person),
          onSelected: (value) {
            if (value == 'profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            } else if (value == 'creator') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Creatorpage()),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Text('Profile Info'),
            ),
            const PopupMenuItem(
              value: 'creator',
              child: Text('Creator Info'),
            ),
          ],
        ),
        title: const Text(
          'Sonare',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        action: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchPage(allSongs: allSongs)),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                _homeTopCard(),
                _tabs(),
                SizedBox(
                  height: 260,
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      CategorySongs(category: 'Trending Now'),
                      CategorySongs(category: 'Top Charts'),
                      CategorySongs(category: 'New Releases'),
                      CategorySongs(category: 'Editor\'s Picks'),
                    ],
                  ),
                ),
                const PlayList(),
              ],
            ),
          ),

          // Fixed Mini Player
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayer(allSongs: allSongs),
          ),
        ],
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
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        Text(
          'Top Charts',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        Text(
          'New Releases',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        Text(
          'Editor\'s Picks',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ],
    );
  }
}
