import 'package:dartz/dartz.dart';
import 'package:mikrogrup/core/errors/failures.dart';

abstract class AnimeRepository {
  // Sayfalama, filtre ve durum seçenekleriyle anime listesini çeker.

  // Fetches a list of animes with pagination, filter, and status options.

  Future<Either<Failure, Map<String, dynamic>>> fetchAnimeList(
      int? page, String? filter, String? status);
}
