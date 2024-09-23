import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mikrogrup/features/anime_list/presentation/cubit/anime_cubit.dart';
import 'package:mikrogrup/features/anime_list/presentation/pages/anime_list_page.dart';
import 'anime_list_page_widget_test.mocks.dart';

@GenerateMocks([
  AnimeCubit,
])
void main() {
  late MockAnimeCubit mockAnimeCubit;

  setUp(() {
    mockAnimeCubit = MockAnimeCubit();
  });

  // Test: Yüklenme göstergesi (CircularProgressIndicator) görünmelidir.
  // Test: CircularProgressIndicator should be displayed.
  testWidgets('AnimeListPage displays loading indicator',
      (WidgetTester tester) async {
    final mockAnimeCubit = MockAnimeCubit();

    when(mockAnimeCubit.state).thenReturn(AnimeLoading());
    when(mockAnimeCubit.stream).thenAnswer((_) => Stream.value(AnimeLoading()));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AnimeCubit>(
          create: (_) => mockAnimeCubit,
          child: AnimeListPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // Test: Hata mesajı görüntülenmelidir.
  // Test: Error message should be displayed.
  testWidgets('AnimeListPage displays error message',
      (WidgetTester tester) async {
    final mockAnimeCubit = MockAnimeCubit();

    when(mockAnimeCubit.state).thenReturn(AnimeError('Failed to load anime'));
    when(mockAnimeCubit.stream)
        .thenAnswer((_) => Stream.value(AnimeError('Failed to load anime')));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AnimeCubit>(
          create: (_) => mockAnimeCubit,
          child: AnimeListPage(),
        ),
      ),
    );

    expect(find.text('Failed to load anime'), findsOneWidget);
  });
}
