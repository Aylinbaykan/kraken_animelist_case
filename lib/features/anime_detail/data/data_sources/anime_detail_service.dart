import 'package:chopper/chopper.dart';

part 'anime_detail_service.chopper.dart';

@ChopperApi()
abstract class AnimeDetailService extends ChopperService {
  @Get(path: '/anime/{id}/characters')
  Future<Response<Map<String, dynamic>>> getAnimeDetail(@Path('id') int id);

  static AnimeDetailService create() {
    final client = ChopperClient(
      baseUrl: 'https://api.jikan.moe/v4',
      services: [_$AnimeDetailService()],
      converter: JsonConverter(),
    );
    return _$AnimeDetailService(client);
  }
}
