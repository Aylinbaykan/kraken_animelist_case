import 'package:dartz/dartz.dart';
import 'package:mikrogrup/core/errors/failures.dart';
import 'package:mikrogrup/features/anime_list/domain/repositories/anime_repository.dart';

class GetAnimeList {
  final AnimeRepository repository;

  GetAnimeList(this.repository);

  // Bu fonksiyon, repository'deki fetchAnimeList metodunu çağırarak
  // sayfa, filtre ve durum bilgilerine göre sayfalı anime listesini döndürür.

  // This function calls the fetchAnimeList method in the repository
  // to retrieve a paginated list of animes based on the page, filter, and status.

  Future<Either<Failure, Map<String, dynamic>>> call(
      int? page, String? filter, String? status) {
    return repository.fetchAnimeList(page, filter, status);
  }
}
