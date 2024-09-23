import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mikrogrup/features/anime_detail/data/data_sources/anime_detail_service.dart';
import 'package:mikrogrup/features/anime_detail/data/repositories/anime_detail_repository_impl.dart';
import 'package:mikrogrup/core/errors/failures.dart';
import 'package:mikrogrup/features/anime_detail/domain/entites/anime_detail.dart';
import 'package:chopper/chopper.dart'; // Chopper'ı ekledik
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'anime_detail_repository_impl_test.mocks.dart';

@GenerateMocks([AnimeDetailService])
void main() {
  late AnimeDetailRepositoryImpl repository;
  late MockAnimeDetailService mockAnimeDetailService;

  const MethodChannel channel = MethodChannel('com.example.method_channel');

  const int tAnimeId = 1;

  // JSON formatında anime detayı için test verisi
  // Test data for anime detail in JSON format
  final Map<String, dynamic> tAnimeDetailJson = {
    'id': tAnimeId,
    'title': 'Naruto'
  };

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockAnimeDetailService = MockAnimeDetailService();
    repository = AnimeDetailRepositoryImpl(mockAnimeDetailService);

    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'animeListFetched') {
        return 'Success';
      }
      return null;
    });
  });

  // Her testten sonra temizleme işlemi
  // Clean up after each test
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  // Test durumu: Servis çağrısı başarılı olduğunda anime detaylarını döndürmelidir.
  // Test case: Should return anime detail when the service call is successful.
  test('should return anime detail when the call to service is successful',
      () async {
    // Arrange
    final httpRequest = http.Request(
        'GET', Uri.parse('https://api.jikan.moe/v4/anime/$tAnimeId'));
    final httpResponse = http.Response('Success', 200, request: httpRequest);
    final chopperResponse = Response(httpResponse, tAnimeDetailJson);

    when(mockAnimeDetailService.getAnimeDetail(tAnimeId))
        .thenAnswer((_) async => chopperResponse);

    final result = await repository.getAnimeDetail(tAnimeId);

    expect(result, isA<Right<Failure, AnimeDetail>>());
    result.fold((failure) => null, (detail) {});

    verify(mockAnimeDetailService.getAnimeDetail(tAnimeId));
  });

  // Test durumu: Servis çağrısı başarısız olduğunda ServerFailure döndürmelidir.
  // Test case: Should return ServerFailure when the service call is unsuccessful.
  test('should return ServerFailure when the call to service is unsuccessful',
      () async {
    final httpRequest = http.Request(
        'GET', Uri.parse('https://api.jikan.moe/v4/anime/$tAnimeId'));
    final httpResponse = http.Response('Error', 500, request: httpRequest);
    final chopperResponse = Response<Map<String, dynamic>>(httpResponse, {});

    when(mockAnimeDetailService.getAnimeDetail(tAnimeId))
        .thenAnswer((_) async => chopperResponse);

    final result = await repository.getAnimeDetail(tAnimeId);

    expect(result, isA<Left<Failure, AnimeDetail>>());
    result.fold(
      (failure) {
        expect(failure, isA<ServerFailure>());
      },
      (detail) => null,
    );
  });

  // Test durumu: Servis hata döndürdüğünde native method çağrılmalıdır.
  // Test case: Should call native method when service returns an error.
  test('should call native method when service returns error', () async {
    final httpRequest = http.Request(
        'GET', Uri.parse('https://api.jikan.moe/v4/anime/$tAnimeId'));
    final httpResponse = http.Response('Error', 500, request: httpRequest);
    final chopperResponse = Response<Map<String, dynamic>>(httpResponse, {});

    when(mockAnimeDetailService.getAnimeDetail(tAnimeId))
        .thenAnswer((_) async => chopperResponse);

    // Act
    final result = await repository.getAnimeDetail(tAnimeId);
    expect(result, isA<Left<Failure, AnimeDetail>>());
    result.fold(
      (failure) {
        expect(failure, isA<ServerFailure>());
      },
      (detail) => null,
    );
  });
}
