import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:mikrogrup/core/errors/failures.dart';
import 'package:mikrogrup/features/anime_detail/domain/entites/anime_detail.dart';
import 'package:mikrogrup/features/anime_detail/domain/uses_cases/get_anime_detail.dart';
import 'package:mikrogrup/features/anime_detail/presentation/cubit/anime_detail_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'anime_detail_cubit_test.mocks.dart';

@GenerateMocks([GetAnimeDetail])
void main() {
  late AnimeDetailCubit cubit;
  late MockGetAnimeDetail mockGetAnimeDetail;

  // Başarılı bir yanıtı simüle etmek için test anime detay verisi
  // Test anime detail data to simulate a successful response
  final tAnimeDetail = AnimeDetail(
    characters: [
      Character(
        imageUrl: '',
        name: 'Naruto Uzumaki',
        role: 'Main Character',
        favorites: 1,
        voiceActors: [],
      ),
    ],
  );

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockGetAnimeDetail = MockGetAnimeDetail();
    cubit = AnimeDetailCubit(getAnimeDetailUseCase: mockGetAnimeDetail);
  });

  tearDown(() {
    cubit.close();
  });

  // Test durumu: Başlangıç durumu AnimeDetailInitial olmalıdır.
  // Test case: Initial state should be AnimeDetailInitial.

  test('initial state should be AnimeDetailInitial', () {
    expect(cubit.state, isA<AnimeDetailInitial>());
  });

  // blocTest: Anime detaylarının başarılı bir şekilde yüklendiğini test eder.
  // blocTest: Tests the successful loading of anime details.
  blocTest<AnimeDetailCubit, AnimeDetailState>(
    'should emit [AnimeDetailLoading, AnimeDetailLoaded] when data is loaded successfully',
    build: () {
      when(mockGetAnimeDetail.call(any))
          .thenAnswer((_) async => Right(tAnimeDetail));
      return cubit;
    },
    act: (cubit) => cubit.fetchAnimeDetail(1),
    expect: () => [
      isA<AnimeDetailLoading>(),
      isA<AnimeDetailLoaded>(),
    ],
  );

  // blocTest: Anime detaylarını getirirken hata oluştuğunda test eder.
  // blocTest: Tests the failure case when fetching anime details.
  blocTest<AnimeDetailCubit, AnimeDetailState>(
    'should emit [AnimeDetailLoading, AnimeDetailError] when fetching data fails',
    build: () {
      when(mockGetAnimeDetail.call(any)).thenAnswer(
          (_) async => Left(ServerFailure('Failed to load anime detail')));
      return cubit;
    },
    act: (cubit) => cubit.fetchAnimeDetail(1),
    expect: () => [
      isA<AnimeDetailLoading>(),
      isA<AnimeDetailError>(),
    ],
  );
}
