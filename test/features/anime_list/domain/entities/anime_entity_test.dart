import 'package:flutter_test/flutter_test.dart';
import 'package:mikrogrup/features/anime_list/domain/entities/anime.dart';

void main() {
  group('Anime Entity', () {
    final jsonData = {
      'mal_id': 1,
      'title': 'Naruto',
      'images': {
        'jpg': {'image_url': 'https://example.com/image.jpg'}
      },
      'score': 8.0,
      'genres': [
        {'name': 'Action'},
        {'name': 'Adventure'}
      ],
      'synopsis': 'A young ninja...',
      'episodes': 220,
      'title_english': 'Naruto',
      'title_japanese': 'ナルト',
      'title_synonyms': ['Ninja Uzumaki']
    };

    // Test: Anime entity, JSON verisinden doğru şekilde oluşturulmalıdır.
    // Test: Anime entity should be correctly created from JSON data.
    test('Anime entity should be correctly created from JSON data', () {
      final anime = Anime(
        id: jsonData['mal_id'] as int,
        title: jsonData['title'] as String,
        imageUrl: ((jsonData['images'] as Map<String, dynamic>)['jpg']
                as Map<String, dynamic>)['image_url'] as String? ??
            'https://via.placeholder.com/150',

        ratingScore: (jsonData['score'] as num?)?.toDouble() ??
            0.0, // Null olursa 0.0 atanıyor
        genres: (jsonData['genres'] as List)
            .map((genre) => genre['name'] as String)
            .toList(),
        synopsis: jsonData['synopsis'] as String,
        episodes: jsonData['episodes'] as int,
        titleEnglish: jsonData['title_english'] as String,
        titleJapanese: jsonData['title_japanese'] as String,
        titleSynonyms: (jsonData['title_synonyms'] as List<dynamic>)
            .map((synonym) => synonym.toString())
            .toList(),
      );

      // Anime nesnesinin doğru oluşturulduğunu kontrol eden doğrulamalar.
      // Assertions to check that the Anime object was created correctly.
      expect(anime.id, 1);
      expect(anime.title, 'Naruto');
      expect(anime.imageUrl, 'https://example.com/image.jpg');
      expect(anime.ratingScore, 8.0);
      expect(anime.genres, ['Action', 'Adventure']);
      expect(anime.synopsis, 'A young ninja...');
      expect(anime.episodes, 220);
      expect(anime.titleEnglish, 'Naruto');
      expect(anime.titleJapanese, 'ナルト');
      expect(anime.titleSynonyms, ['Ninja Uzumaki']);
    });
  });
}
