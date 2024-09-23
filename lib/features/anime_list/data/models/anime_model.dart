import '../../domain/entities/anime.dart';

class AnimeModel {
  final int id;
  final String title;
  final String imageUrl;
  final double? ratingScore;
  final List<String> genres;
  final String synopsis;
  final int episodes;
  final String? trailerUrl;
  final String titleEnglish;
  final String titleJapanese;
  final List<String> titleSynonyms;

  AnimeModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.ratingScore,
    required this.genres,
    required this.synopsis,
    required this.episodes,
    this.trailerUrl,
    required this.titleEnglish,
    required this.titleJapanese,
    required this.titleSynonyms,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      id: json['mal_id'],
      title: json['title'] ?? 'Unknown Title',
      imageUrl: json['images']['jpg']['image_url'] ??
          'https://via.placeholder.com/150',
      ratingScore: json['score'] != null ? json['score'].toDouble() : null,
      genres: (json['genres'] as List<dynamic>)
          .map((genre) => genre['name'] as String)
          .toList(),
      synopsis: json['synopsis'] ?? 'No synopsis available.',
      episodes: json['episodes'] ?? 0,
      trailerUrl: json['trailer'] != null ? json['trailer']['url'] : null,
      titleEnglish: json['title_english'] ?? '',
      titleJapanese: json['title_japanese'] ?? '',
      titleSynonyms: (json['title_synonyms'] as List<dynamic>)
          .map((synonym) => synonym.toString())
          .toList(),
    );
  }

  Anime toEntity() {
    return Anime(
      id: id,
      title: title,
      imageUrl: imageUrl,
      ratingScore: ratingScore!,
      genres: genres,
      synopsis: synopsis,
      episodes: episodes,
      titleEnglish: titleEnglish,
      titleJapanese: titleJapanese,
      titleSynonyms: titleSynonyms,
    );
  }
}
