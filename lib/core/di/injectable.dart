import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mikrogrup/features/anime_list/data/data_sources/anime_service.dart';
import 'package:mikrogrup/features/anime_list/data/repositories/anime_repository_impl.dart';
import 'package:mikrogrup/features/anime_list/domain/repositories/anime_repository.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  getIt.registerLazySingleton<AnimeService>(() => AnimeService.create());

  getIt.registerLazySingleton<AnimeRepository>(
    () => AnimeRepositoryImpl(getIt<AnimeService>()),
  );
}
