import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mikrogrup/core/errors/failures.dart';
import 'package:mikrogrup/features/anime_detail/domain/entites/anime_detail.dart';
import 'package:mikrogrup/features/anime_detail/domain/repositories/anime_detail_repository.dart';
import 'package:mikrogrup/features/anime_detail/domain/uses_cases/get_anime_detail.dart';
import 'get_anime_detail_test.mocks.dart';

@GenerateMocks([AnimeDetailRepository])
void main() {
  late GetAnimeDetail useCase;
  late MockAnimeDetailRepository mockAnimeDetailRepository;

  setUp(() {
    mockAnimeDetailRepository = MockAnimeDetailRepository();
    useCase = GetAnimeDetail(mockAnimeDetailRepository);
  });

  // Test için örnek anime detay nesnesi
  // Example anime detail object for testing

  final tAnimeDetail = AnimeDetail(
    characters: [
      Character(
        imageUrl: '',
        name: 'Naruto Uzumaki',
        role: 'Main Character',
        favorites: 1,
        voiceActors: [],
      ),
    ],
  );

  // Test durumu: Repository'den anime detaylarını başarıyla almalıdır.
  // Test case: Should get anime detail from the repository successfully.
  test('should get anime detail from the repository', () async {
    when(mockAnimeDetailRepository.getAnimeDetail(any))
        .thenAnswer((_) async => Right(tAnimeDetail));

    final result = await mockAnimeDetailRepository.getAnimeDetail(1);

    expect(result, isA<Right<Failure, AnimeDetail>>());
    result.fold(
      (failure) => null,
      (detail) {
        expect(detail.characters.first.name, 'Naruto Uzumaki');
      },
    );
  });

  // Test durumu: Repository başarısız olduğunda hata döndürmelidir.
  // Test case: Should return a failure when the repository fails.
  test('should return failure when the repository fails', () async {
    when(mockAnimeDetailRepository.getAnimeDetail(any)).thenAnswer(
        (_) async => Left(ServerFailure('Failed to load anime detail')));

    final result = await mockAnimeDetailRepository.getAnimeDetail(1);

    expect(result, isA<Left<Failure, AnimeDetail>>());
    result.fold(
      (failure) {
        expect(failure, isA<ServerFailure>());
        expect(
            (failure as ServerFailure).message, 'Failed to load anime detail');
      },
      (detail) => null,
    );
  });
}
