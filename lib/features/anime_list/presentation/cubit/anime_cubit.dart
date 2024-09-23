import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../../domain/use_cases/get_anime_list.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/pagination.dart';

abstract class AnimeState {}

class AnimeInitial extends AnimeState {}

class AnimeLoading extends AnimeState {}

class AnimeLoaded extends AnimeState {
  final List<Anime> animeList;
  final Pagination pagination;

  AnimeLoaded(this.animeList, this.pagination);
}

class AnimeError extends AnimeState {
  final String message;

  AnimeError(this.message);
}

// AnimeCubit sınıfı, anime durumunu yönetir ve veri çekmeyi ele alır.

// The AnimeCubit class manages the anime state and handles data fetching.

class AnimeCubit extends Cubit<AnimeState> {
  final GetAnimeList getAnimeListUseCase;
  final FirebaseCrashlytics crashlytics;

  // Sayfalama için mevcut sayfayı takip eder.
  // Keeps track of the current page for pagination.
  int currentPage = 1;

  // Daha fazla sayfa olup olmadığını belirtir.
  // Indicates if there are more pages to load.
  bool hasNextPage = true;

  // Çekmek için kullanılan mevcut filtreyi takip eder.
  // Tracks the current filter used for fetching.
  String currentFilter = 'All';

  AnimeCubit({
    required this.getAnimeListUseCase,
    required this.crashlytics,
  }) : super(AnimeInitial());

  // Filtre ve duruma göre anime listesini yüklemek için fonksiyon
  // Function to load the anime list based on the filter and status

  Future<void> loadAnimeList({String filter = 'All', String? status}) async {
    if (!hasNextPage || state is AnimeLoading) return;

    if (filter != currentFilter) {
      currentPage = 1;
      hasNextPage = true;
      emit(AnimeInitial());
    }

    currentFilter = filter;
    final currentState = state;
    List<Anime> animeList = [];

    if (currentState is AnimeLoaded && filter == currentFilter) {
      animeList = currentState.animeList;
    }

    emit(AnimeLoading());

    // Use case kullanarak anime listesini çeker
    // Fetches the anime list using the use case

    final result = await getAnimeListUseCase(currentPage, filter, status);
    result.fold(
      (failure) {
        crashlytics.recordError(failure, null,
            reason: 'Failed to load anime list');
        emit(AnimeError("Failed to load anime: ${failure.toString()}"));
      },
      (data) {
        final List<Anime> newAnimeList = data["animeList"];
        final Pagination pagination = data["pagination"];
        final updatedAnimeList = [...animeList, ...newAnimeList];

        emit(AnimeLoaded(updatedAnimeList, pagination));
        currentPage++;
        hasNextPage = pagination.hasNextPage;
      },
    );
  }
}
