import 'package:flutter/material.dart';
import 'package:mikrogrup/features/anime_detail/presentation/pages/anime_detail_page.dart';
import 'package:mikrogrup/features/anime_list/presentation/cubit/anime_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikrogrup/features/anime_list/presentation/widgets/anime_list_item.dart';

class AnimeListPage extends StatefulWidget {
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  // Şu anda seçilen filtre
  // Currently selected filter
  String selectedFilter = 'All';

  // Scroll pozisyonunu izlemek için kullanılır.
  // To track scrolling position.
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  double _currentScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final animeCubit = context.read<AnimeCubit>();

    // İlk anime listesini yükler.
    // Loads the initial anime list.
    animeCubit.loadAnimeList();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      _currentScrollPosition = _scrollController.position.pixels;

      final animeCubit = context.read<AnimeCubit>();
      animeCubit.loadAnimeList().then((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_currentScrollPosition);
        });
        setState(() {
          isLoadingMore = false;
        });
      });
    }
  }

  Widget _buildEndDrawer() {
    return Drawer(
      backgroundColor: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Filters",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildFilterOption(Icons.list, 'All', 'All Animations'),
          _buildFilterOption(Icons.tv, 'TV', 'TV Shows'),
          _buildFilterOption(Icons.movie, 'Movie', 'Movies'),
          _buildFilterOption(Icons.upcoming, 'Upcoming', 'Upcoming'),
        ],
      ),
    );
  }

  Widget _buildFilterOption(IconData icon, String filter, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
        context.read<AnimeCubit>().loadAnimeList(filter: selectedFilter);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900.withOpacity(0.9),
        elevation: 4,
        title: const Text(
          'Anime List',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.filter_list, size: 30),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: _buildEndDrawer(),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AnimeCubit, AnimeState>(
              builder: (context, state) {
                if (state is AnimeLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.black87,
                  ));
                } else if (state is AnimeLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.animeList.length,
                    itemBuilder: (context, index) {
                      final anime = state.animeList[index];

                      return AnimeListItem(
                        anime: anime,
                        onTap: (animeId) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimeDetailPage(
                                animeId: animeId,
                                image: anime.imageUrl,
                                title: anime.title,
                                ratingScore: anime.ratingScore,
                                genres: anime.genres,
                                synopsis: anime.synopsis,
                                episodesCount: anime.episodes,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is AnimeError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
