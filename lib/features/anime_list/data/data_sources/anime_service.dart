import 'package:chopper/chopper.dart';
part 'anime_service.chopper.dart';

@ChopperApi()
abstract class AnimeService extends ChopperService {
  @Get(path: '/top/anime')
  Future<Response<Map<String, dynamic>>> getAnimes(

      // Page number parameter
      // Sayfa numarası parametresi
      @Query('page') int? page,
      // Type parameter for TV and Movie
      // TV ve Film için tür parametresi
      @Query('type') String? filter,
      // Status parameter for Upcoming
      //Yakında Gelecek için durum parametresi
      @Query('status') String? status);

  static AnimeService create() {
    final client = ChopperClient(
      baseUrl: 'https://api.jikan.moe/v4',
      services: [_$AnimeService()],
      converter: JsonConverter(),
      interceptors: [
        (Request request) async {
          return request;
        },
        (Response response) async {
          return response;
        },
      ],
    );
    return _$AnimeService(client);
  }
}
