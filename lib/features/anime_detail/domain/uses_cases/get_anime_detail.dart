import 'package:dartz/dartz.dart';
import 'package:mikrogrup/features/anime_detail/domain/entites/anime_detail.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/anime_detail_repository.dart';

// Function to retrieve anime details.
// It calls the `getAnimeDetail` function from the repository,
// passing the `animeId` to get the details.
// On success, it returns `AnimeDetail`, and on failure, it returns `Failure`.

// Anime detaylarını getiren fonksiyon.
// repository üzerinden gelen `getAnimeDetail` fonksiyonu,
// `animeId` parametresini alarak detayları getirir.
// İşlem başarılı olursa `AnimeDetail`, başarısız olursa `Failure` döner.

class GetAnimeDetail {
  final AnimeDetailRepository repository;

  GetAnimeDetail(this.repository);

  Future<Either<Failure, AnimeDetail>> call(int animeId) {
    return repository.getAnimeDetail(animeId);
  }
}
