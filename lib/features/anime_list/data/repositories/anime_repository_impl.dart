import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mikrogrup/core/errors/failures.dart';
import 'package:mikrogrup/features/anime_list/data/data_sources/anime_service.dart';
import 'package:mikrogrup/features/anime_list/domain/entities/anime.dart';
import 'package:mikrogrup/features/anime_list/domain/entities/pagination.dart';
import 'package:mikrogrup/features/anime_list/domain/repositories/anime_repository.dart';
import '../models/anime_model.dart';

class AnimeRepositoryImpl implements AnimeRepository {
  final MethodChannel _channel =
      const MethodChannel('com.example.method_channel');
  final AnimeService animeService;

  AnimeRepositoryImpl(this.animeService);

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchAnimeList(
      int? page, String? filter, String? status) async {
    try {
      // Girdi parametrelerine göre tür ve durum filtreler ayarlanır. 'All' veya 'Upcoming' seçilmişse,
      // typeFilter null olur, ve 'Upcoming' seçilmişse, statusFilter 'upcoming' olarak ayarlanır.

      // Set type and status filters based on the input parameters. If 'All' or 'Upcoming' is selected,
      // typeFilter is null, and if 'Upcoming' is selected, statusFilter is set to 'upcoming'.

      final String? typeFilter =
          (filter == 'All' || filter == 'Upcoming') ? null : filter;
      final String? statusFilter = (filter == 'Upcoming') ? 'upcoming' : null;

      final response =
          await animeService.getAnimes(page, typeFilter, statusFilter);

      if (response == null || response.body == null || !response.isSuccessful) {
        await _notifyNative(
            "Failed to load anime list: Null or unsuccessful response from API.");
        return Left(
            ServerFailure('Failed with status: ${response.statusCode}'));
      }

      final pagination = response.body!['pagination'];
      if (pagination == null) {
        throw Exception("Pagination data is missing in response");
      }

      // Anime listesi verisi parse edilir ve Anime entity'lerine maplenir.

      // Parse the anime list data and map it to a list of Anime entities

      final List<dynamic> animeData = response.body!['data'] ?? [];
      final List<Anime> animeList = animeData
          .map((animeJson) => AnimeModel.fromJson(animeJson).toEntity())
          .toList();

      return Right({
        'animeList': animeList,
        'pagination': Pagination(
          currentPage: pagination['current_page'] ?? 1,
          lastVisiblePage: pagination['last_visible_page'] ?? 1,
          hasNextPage: pagination['has_next_page'] ?? false,
          itemCount: pagination['items']['count'] ?? 0,
          totalItems: pagination['items']['total'] ?? 0,
          itemsPerPage: pagination['items']['per_page'] ?? 25,
        ),
      });
    } catch (e) {
      await _notifyNative("An error occurred: ${e.toString()}");
      FirebaseCrashlytics.instance
          .recordError(e, null, reason: 'Error during fetching anime list');
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _notifyNative(String message) async {
    try {
      await _channel.invokeMethod('animeListFetched', message);
    } on PlatformException catch (e) {
      print("Failed to send message to native: '${e.message}'.");
    }
  }
}
