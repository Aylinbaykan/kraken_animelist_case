import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mikrogrup/features/anime_list/data/repositories/anime_repository_impl.dart';
import 'package:mikrogrup/features/anime_list/domain/repositories/anime_repository.dart';
import 'package:mikrogrup/core/di/injectable.dart';

void main() {
  final getIt = GetIt.instance;

  setUpAll(() {
    configureDependencies();
  });

  test('AnimeRepository is registered in GetIt', () {
    final repository = getIt<AnimeRepository>();

    expect(repository, isNotNull);

    expect(repository, isA<AnimeRepositoryImpl>());
  });
}
