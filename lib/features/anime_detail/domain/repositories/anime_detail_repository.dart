import 'package:dartz/dartz.dart';
import 'package:mikrogrup/features/anime_detail/domain/entites/anime_detail.dart';
import '../../../../core/errors/failures.dart';

// The getAnimeDetail function takes an anime ID and returns either a Failure or AnimeDetail wrapped in an Either type.

// getAnimeDetail fonksiyonu, bir anime id'si alır ve ya Failure (başarısızlık) ya da AnimeDetail (başarı) döndürür.

abstract class AnimeDetailRepository {
  Future<Either<Failure, AnimeDetail>> getAnimeDetail(int id);
}
