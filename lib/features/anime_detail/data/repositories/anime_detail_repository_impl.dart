import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:mikrogrup/features/anime_detail/domain/entites/anime_detail.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/anime_detail_repository.dart';
import '../data_sources/anime_detail_service.dart';
import '../models/anime_detail_model.dart';

class AnimeDetailRepositoryImpl implements AnimeDetailRepository {
  final AnimeDetailService service;

  AnimeDetailRepositoryImpl(this.service);
  static const MethodChannel _channel =
      MethodChannel('com.example.method_channel');

  @override
  Future<Either<Failure, AnimeDetail>> getAnimeDetail(int id) async {
    try {
      final response = await service.getAnimeDetail(id);

      if (response.isSuccessful && response.body != null) {
        final detail = AnimeDetailModel.fromJson(response.body!);
        await _notifyNative("Anime detail loaded successfully.");
        return Right(detail);
      } else {
        await _notifyNative("Failed to load anime detail.");
        return Left(ServerFailure('Failed to load anime detail'));
      }
    } catch (e) {
      await _notifyNative("An error occurred: ${e.toString()}");
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
