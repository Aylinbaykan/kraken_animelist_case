import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikrogrup/features/anime_detail/domain/uses_cases/get_anime_detail.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:mikrogrup/features/anime_detail/domain/entites/anime_detail.dart';
import 'package:mikrogrup/features/anime_detail/presentation/pages/anime_detail_page.dart';
import 'package:mikrogrup/features/anime_detail/presentation/cubit/anime_detail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'anime_detail_page_golden_test.mocks.dart';

@GenerateMocks([GetAnimeDetail])
void main() {
  late MockGetAnimeDetail mockGetAnimeDetail;

  // Test için örnek anime detay verisi
  // Example anime detail data for testing
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
    mockGetAnimeDetail = MockGetAnimeDetail();
  });

  // AnimeDetailPage için Golden test
  // Golden test for AnimeDetailPage
  testWidgets('AnimeDetailPage golden test', (WidgetTester tester) async {
    // Arrange: Mock veriyi ayarlıyoruz
    when(mockGetAnimeDetail.call(any))
        .thenAnswer((_) async => Right(tAnimeDetail));

    // Widget'ı oluşturuyoruz
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
              image:
                  'https://via.placeholder.com/150', // NetworkImage yerine sahte URL
              title: 'Naruto',
              genres: ['Action', 'Adventure'],
              synopsis: 'Naruto Uzumaki is a young ninja...',
              episodesCount: 220,
            ),
          ),
        ),
      ),
    );

    // Golden test için widget ekran görüntüsünü alıyoruz
    await expectLater(
      find.byType(AnimeDetailPage),
      matchesGoldenFile('goldens/anime_detail_page.png'),
    );
  });
}
