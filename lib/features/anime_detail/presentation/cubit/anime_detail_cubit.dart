import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entites/anime_detail.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/uses_cases/get_anime_detail.dart';

abstract class AnimeDetailState {}

class AnimeDetailInitial extends AnimeDetailState {}

class AnimeDetailLoading extends AnimeDetailState {}

class AnimeDetailLoaded extends AnimeDetailState {
  final AnimeDetail animeDetail;

  AnimeDetailLoaded(this.animeDetail);
}

class AnimeDetailError extends AnimeDetailState {
  final String message;

  AnimeDetailError(this.message);
}

class AnimeDetailCubit extends Cubit<AnimeDetailState> {
  final GetAnimeDetail getAnimeDetailUseCase;

  AnimeDetailCubit({required this.getAnimeDetailUseCase})
      : super(AnimeDetailInitial());

  // Anime detaylarını yükleyen fonksiyon.
  // İlk olarak AnimeDetailLoading durumunu emit eder ve ardından getAnimeDetailUseCase kullanarak detayları çeker.
  // Başarılı olursa AnimeDetailLoaded, hata olursa AnimeDetailError durumunu emit eder.

  // Function to fetch anime details.
  // First, it emits the AnimeDetailLoading state and then calls the getAnimeDetailUseCase to fetch details.
  // If successful, it emits AnimeDetailLoaded, and if it fails, it emits AnimeDetailError.

  Future<void> fetchAnimeDetail(int animeId) async {
    emit(AnimeDetailLoading());

    final Either<Failure, AnimeDetail> result =
        await getAnimeDetailUseCase(animeId);

    result.fold(
      (failure) => emit(AnimeDetailError(failure.toString())),
      (animeDetail) => emit(AnimeDetailLoaded(animeDetail)),
    );
  }
}
