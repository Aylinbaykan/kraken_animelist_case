class Anime {
  final int id;
  final String title;
  final String imageUrl;
  final double ratingScore;
  final List<String> genres;
  final String synopsis;
  final int episodes;
  final String titleEnglish;
  final String titleJapanese;
  final List<String> titleSynonyms;

  Anime({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.ratingScore = 0.0,
    required this.genres,
    required this.synopsis,
    required this.episodes,
    required this.titleEnglish,
    required this.titleJapanese,
    required this.titleSynonyms,
  });

  // JSON'dan Anime entity oluşturulabilir
  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      imageUrl: json['images']['jpg']['image_url'],
      ratingScore: (json['score'] as num?)?.toDouble() ?? 0.0,
      genres: (json['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList(),
      synopsis: json['synopsis'] ?? 'No synopsis available.',
      episodes: json['episodes'] ?? 0,
      titleEnglish: json['title_english'] ?? '',
      titleJapanese: json['title_japanese'] ?? '',
      titleSynonyms: (json['title_synonyms'] as List<dynamic>)
          .map((synonym) => synonym.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': id,
      'title': title,
      'images': {
        'jpg': {'image_url': imageUrl}
      },
      'score': ratingScore,
      'genres': genres.map((genre) => {'name': genre}).toList(),
      'synopsis': synopsis,
      'episodes': episodes,
      'title_english': titleEnglish,
      'title_japanese': titleJapanese,
      'title_synonyms': titleSynonyms,
    };
  }
}
