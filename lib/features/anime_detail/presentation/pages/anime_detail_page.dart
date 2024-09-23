import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikrogrup/features/anime_detail/domain/entites/anime_detail.dart';
import 'package:mikrogrup/features/anime_detail/domain/uses_cases/get_anime_detail.dart';
import '../cubit/anime_detail_cubit.dart';

class AnimeDetailPage extends StatefulWidget {
  final int animeId;
  final String image;
  final String title;
  double? ratingScore;
  final List<String> genres;
  final String synopsis;
  final int episodesCount;

  AnimeDetailPage({
    required this.animeId,
    required this.image,
    required this.title,
    this.ratingScore,
    required this.genres,
    required this.episodesCount,
    required this.synopsis,
  });

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  late AnimeDetailCubit _animeDetailCubit;

  @override
  void initState() {
    super.initState();
    // AnimeDetailCubit, GetAnimeDetail kullanarak başlatılır.
    // Initializing the AnimeDetailCubit with the GetAnimeDetail use case
    _animeDetailCubit = AnimeDetailCubit(
      getAnimeDetailUseCase: context.read<GetAnimeDetail>(),
    );

    // Anime detaylarını anime ID ile getirilir.
    // Fetch the anime details using the anime ID
    _animeDetailCubit.fetchAnimeDetail(widget.animeId);
  }

  @override
  void dispose() {
    _animeDetailCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        elevation: 4,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _animeDetailCubit,
        child: BlocBuilder<AnimeDetailCubit, AnimeDetailState>(
          builder: (context, state) {
            if (state is AnimeDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnimeDetailLoaded) {
              final AnimeDetail detail = state.animeDetail;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          widget.image,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 6.0,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Puan ve bölümler
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rating: ${widget.ratingScore?.toString() ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Episodes: ${widget.episodesCount}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Türler
                          Text(
                            'Genres: ${widget.genres.join(', ')}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Özet
                          const Text(
                            'Synopsis:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.synopsis,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          // Karakterler bölümü başlığı
                          const Text(
                            'Characters:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Karakter listesi
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: detail.characters.length,
                            itemBuilder: (context, index) {
                              final character = detail.characters[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: Image.network(
                                            character.imageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(
                                            character.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Role: ${character.role} | Favorites: ${character.favorites}',
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Voice Actors:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              character.voiceActors.length,
                                          itemBuilder: (context, voiceIndex) {
                                            final voiceActor = character
                                                .voiceActors[voiceIndex];
                                            return ListTile(
                                              leading: Image.network(
                                                voiceActor.imageUrl,
                                                width: 40,
                                                height: 40,
                                              ),
                                              title: Text(voiceActor.name),
                                              subtitle: Text(
                                                  'Language: ${voiceActor.language}'),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is AnimeDetailError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
