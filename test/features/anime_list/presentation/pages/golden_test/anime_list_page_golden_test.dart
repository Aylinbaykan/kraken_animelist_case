import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikrogrup/features/anime_list/domain/entities/anime.dart';
import 'package:mikrogrup/features/anime_list/domain/entities/pagination.dart';
import 'package:mikrogrup/features/anime_list/presentation/pages/anime_list_page.dart';
import 'package:mikrogrup/features/anime_list/presentation/cubit/anime_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'anime_list_page_golden_test.mocks.dart';

@GenerateMocks([AnimeCubit])
void main() {
  // Örnek anime listesi.
  // Sample anime list
  final animeList = [
    Anime(
      id: 1,
      title: 'Naruto',
      imageUrl: 'https://via.placeholder.com/150',
      ratingScore: 8.0,
      genres: [],
      synopsis: '',
      episodes: 220,
      titleEnglish: '',
      titleJapanese: '',
      titleSynonyms: [],
    ),
  ];

  // Örnek pagination bilgisi
  // Creating a sample pagination
  final pagination = Pagination(
    currentPage: 1,
    lastVisiblePage: 1,
    hasNextPage: false,
    itemCount: 1,
    totalItems: 1,
    itemsPerPage: 1,
  );

  // Golden test: AnimeListPage'in görsel testi
  // Golden test: Visual test for AnimeListPage
  testWidgets('AnimeListPage golden test', (WidgetTester tester) async {
    final mockAnimeCubit = MockAnimeCubit();

    when(mockAnimeCubit.state).thenReturn(AnimeLoading());
    when(mockAnimeCubit.stream)
        .thenAnswer((_) => Stream.value(AnimeLoaded(animeList, pagination)));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AnimeCubit>(
          create: (_) => mockAnimeCubit,
          child: AnimeListPage(),
        ),
      ),
    );

    await expectLater(
      find.byType(AnimeListPage),
      matchesGoldenFile('goldens/anime_list_page.png'),
    );
  });
}
