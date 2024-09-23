import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikrogrup/core/di/injectable.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mikrogrup/core/errors/failures.dart';
import 'package:mikrogrup/features/anime_list/domain/entities/anime.dart';
import 'package:mikrogrup/features/anime_list/domain/repositories/anime_repository.dart';
import 'package:mikrogrup/features/anime_list/domain/use_cases/get_anime_list.dart';
import 'get_anime_list_test.mocks.dart';

@GenerateMocks([AnimeRepository])
void main() {
  late GetAnimeList usecase;
  late MockAnimeRepository mockAnimeRepository;

  setUp(() async {
    mockAnimeRepository = MockAnimeRepository();

    getIt.reset();

    getIt.registerSingleton<AnimeRepository>(mockAnimeRepository);
    usecase = GetAnimeList(mockAnimeRepository);
  });

  // Test sayfa numarası
  // Test page number
  const int tPage = 1;

  // Test filtresi
  // Test filter
  const String tFilter = 'TV';

  // Test durumu
  // Test status
  const String tStatus = 'Airing';

  // Anime listesi yanıtını temsil eden test verisi
  // Test data representing an anime list response

  final Map<String, dynamic> tAnimeResponse = {
    'data': [
      Anime(
          id: 1,
          title: 'Naruto',
          imageUrl: 'url',
          ratingScore: 8.0,
          genres: [],
          synopsis: '',
          episodes: 220,
          titleEnglish: '',
          titleJapanese: '',
          titleSynonyms: [])
    ],
    'pagination': {
      'current_page': 1,
      'last_visible_page': 10,
      'has_next_page': true,
      'items': {
        'count': 25,
        'total': 100,
        'per_page': 25,
      }
    }
  };

  // Test durumu: Repository çağrısı başarılı olduğunda anime listesi döndürmelidir.
  // Test case: Should return anime list when the repository call is successful.
  test('should return anime list when the call to repository is successful',
      () async {
    when(mockAnimeRepository.fetchAnimeList(any, any, any))
        .thenAnswer((_) async => Right(tAnimeResponse));

    final result = await usecase.call(tPage, tFilter, tStatus);

    expect(result, Right(tAnimeResponse));
    verify(mockAnimeRepository.fetchAnimeList(tPage, tFilter, tStatus));
    verifyNoMoreInteractions(mockAnimeRepository);
  });

  // Test durumu: Repository çağrısı başarısız olduğunda ServerFailure döndürmelidir.
  // Test case: Should return ServerFailure when the repository call is unsuccessful.
  test(
      'should return ServerFailure when the call to repository is unsuccessful',
      () async {
    when(mockAnimeRepository.fetchAnimeList(any, any, any))
        .thenAnswer((_) async => Left(ServerFailure('Server error')));

    final result = await usecase.call(tPage, tFilter, tStatus);

    expect(result, isA<Left<Failure, Map<String, dynamic>>>());
    result.fold((failure) {
      expect(failure, isA<ServerFailure>());
    }, (data) => null);
    verify(mockAnimeRepository.fetchAnimeList(tPage, tFilter, tStatus));
    verifyNoMoreInteractions(mockAnimeRepository);
  });
}
