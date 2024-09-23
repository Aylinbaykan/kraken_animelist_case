import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:mikrogrup/features/anime_detail/domain/uses_cases/get_anime_detail.dart';
import 'package:provider/provider.dart';
import 'package:mikrogrup/features/anime_list/data/data_sources/anime_service.dart';
import 'package:mikrogrup/features/anime_list/data/repositories/anime_repository_impl.dart';
import 'package:mikrogrup/features/anime_list/domain/use_cases/get_anime_list.dart';
import 'package:mikrogrup/features/anime_list/presentation/cubit/anime_cubit.dart';
import 'package:mikrogrup/features/anime_list/presentation/pages/anime_list_page.dart';
import 'package:mikrogrup/features/anime_detail/data/data_sources/anime_detail_service.dart';
import 'package:mikrogrup/features/anime_detail/data/repositories/anime_detail_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  final AnimeService animeService = AnimeService.create();
  final AnimeDetailService animeDetailService = AnimeDetailService.create();

  final AnimeRepositoryImpl repository = AnimeRepositoryImpl(animeService);
  final AnimeDetailRepositoryImpl detailRepository =
      AnimeDetailRepositoryImpl(animeDetailService);

  final GetAnimeList fetchAnimeListUseCase = GetAnimeList(repository);
  final GetAnimeDetail getAnimeDetailUseCase = GetAnimeDetail(detailRepository);

  runApp(
    MyApp(
      fetchAnimeListUseCase: fetchAnimeListUseCase,
      getAnimeDetailUseCase: getAnimeDetailUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetAnimeList fetchAnimeListUseCase;
  final GetAnimeDetail getAnimeDetailUseCase;

  MyApp({
    required this.fetchAnimeListUseCase,
    required this.getAnimeDetailUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => AnimeCubit(
              crashlytics: FirebaseCrashlytics.instance,
              getAnimeListUseCase: fetchAnimeListUseCase),
        ),
        Provider<GetAnimeDetail>(
          create: (_) => getAnimeDetailUseCase,
        ),
      ],
      child: MaterialApp(
        home: AnimeListPage(),
      ),
    );
  }
}
