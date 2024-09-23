import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mikrogrup/core/errors/failures.dart';
import 'package:mikrogrup/features/anime_list/domain/entities/anime.dart';
import 'package:mikrogrup/features/anime_list/domain/entities/pagination.dart';
import 'package:mikrogrup/features/anime_list/domain/use_cases/get_anime_list.dart';
import 'package:mikrogrup/features/anime_list/presentation/cubit/anime_cubit.dart';
import 'anime_cubit_test.mocks.dart';

@GenerateMocks([GetAnimeList, FirebaseCrashlytics])
void main() {
  late AnimeCubit animeCubit;
  late MockGetAnimeList mockGetAnimeList;
  late MockFirebaseCrashlytics mockCrashlytics;

  setUp(() {
    mockGetAnimeList = MockGetAnimeList();
    mockCrashlytics = MockFirebaseCrashlytics();
    animeCubit = AnimeCubit(
      getAnimeListUseCase: mockGetAnimeList,
      crashlytics: mockCrashlytics,
    );
  });

  tearDown(() {
    animeCubit.close();
  });

  // Test: Başlangıç durumu AnimeInitial olmalıdır.
  // Test: The initial state should be AnimeInitial.
  test('initial state should be AnimeInitial', () {
    expect(animeCubit.state, isA<AnimeInitial>());
  });

  // Test: Veri başarıyla yüklendiğinde [AnimeLoading, AnimeLoaded] durumları emit edilmelidir.
  // Test: Should emit [AnimeLoading, AnimeLoaded] when data is loaded successfully.
  blocTest<AnimeCubit, AnimeState>(
    'should emit [AnimeLoading, AnimeLoaded] when data is loaded successfully',
    build: () {
      when(mockGetAnimeList(any, any, any)).thenAnswer((_) async => Right({
            'animeList': [
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
                titleSynonyms: [],
              ),
            ],
            'pagination': Pagination(
              currentPage: 1,
              lastVisiblePage: 1,
              hasNextPage: false,
              itemCount: 1,
              totalItems: 1,
              itemsPerPage: 1,
            ),
          }));
      return animeCubit;
    },
    act: (cubit) => cubit.loadAnimeList(),
    expect: () => [
      isA<AnimeLoading>(),
      isA<AnimeLoaded>(),
    ],
  );

  // Test: Veri yükleme başarısız olduğunda [AnimeLoading, AnimeError] durumları emit edilmelidir.
  // Test: Should emit [AnimeLoading, AnimeError] when data loading fails.
  blocTest<AnimeCubit, AnimeState>(
    'should emit [AnimeLoading, AnimeError] when data loading fails',
    build: () {
      when(mockGetAnimeList(any, any, any))
          .thenAnswer((_) async => Left(ServerFailure('Server error')));
      return animeCubit;
    },
    act: (cubit) => cubit.loadAnimeList(),
    expect: () => [
      isA<AnimeLoading>(),
      isA<AnimeError>(),
    ],
  );

  // Test: Başarısızlık durumunda Crashlytics'e hata kaydedilmelidir.
  // Test: Should record error to Crashlytics on failure.
  test('should record error to Crashlytics on failure', () async {
    when(mockGetAnimeList(any, any, any))
        .thenAnswer((_) async => Left(ServerFailure('Server error')));
    await animeCubit.loadAnimeList();

    verify(mockCrashlytics.recordError(any, null,
        reason: 'Failed to load anime list'));
  });
}
