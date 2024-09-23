import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikrogrup/core/errors/failures.dart';
import 'package:mikrogrup/features/anime_detail/domain/entites/anime_detail.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mikrogrup/features/anime_detail/domain/uses_cases/get_anime_detail.dart';
import 'package:mikrogrup/features/anime_detail/presentation/cubit/anime_detail_cubit.dart';
import 'package:mikrogrup/features/anime_detail/presentation/pages/anime_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'anime_detail_page_widget_test.mocks.dart';

// Mock sınıfını oluştur
@GenerateMocks([GetAnimeDetail])
void main() {
  late MockGetAnimeDetail mockGetAnimeDetail;

  setUp(() {
    mockGetAnimeDetail = MockGetAnimeDetail();

    GetIt.I.registerFactory<GetAnimeDetail>(() => mockGetAnimeDetail);
  });

  tearDown(() {
    GetIt.I.reset();
  });

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

  // Test durumu: AnimeDetailPage başlangıçta yükleme göstergesi göstermelidir.
  // Test case: The AnimeDetailPage should initially show a loading indicator.
  testWidgets('AnimeDetailPage displays loading state initially',
      (WidgetTester tester) async {
    when(mockGetAnimeDetail.call(any))
        .thenAnswer((_) async => Right(tAnimeDetail));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<GetAnimeDetail>(
            create: (_) => mockGetAnimeDetail,
          ),
        ],
        child: MaterialApp(
          home: BlocProvider<AnimeDetailCubit>(
            create: (context) => AnimeDetailCubit(
              getAnimeDetailUseCase: context.read<GetAnimeDetail>(),
            ),
            child: AnimeDetailPage(
              animeId: 1,
              image: 'https://via.placeholder.com/150',
              title: 'Naruto',
              genres: ['Action', 'Adventure'],
              synopsis: 'Naruto Uzumaki is a young ninja...',
              episodesCount: 220,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // Test durumu: Hata olduğunda AnimeDetailPage bir hata mesajı göstermelidir.
  // Test case: The AnimeDetailPage should show an error message when there is a failure
  testWidgets('AnimeDetailPage displays error message when there is an error',
      (WidgetTester tester) async {
    when(mockGetAnimeDetail.call(any))
        .thenAnswer((_) async => Left(ServerFailure('Failed to load')));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<GetAnimeDetail>(
            create: (_) => mockGetAnimeDetail,
          ),
        ],
        child: MaterialApp(
          home: BlocProvider<AnimeDetailCubit>(
            create: (context) => AnimeDetailCubit(
              getAnimeDetailUseCase: context.read<GetAnimeDetail>(),
            ),
            child: AnimeDetailPage(
              animeId: 1,
              image: 'https://via.placeholder.com/150',
              title: 'Naruto',
              genres: ['Action', 'Adventure'],
              synopsis: 'Naruto Uzumaki is a young ninja...',
              episodesCount: 220,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Failed to load'), findsOneWidget);
  });
}
