// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_detail_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$AnimeDetailService extends AnimeDetailService {
  _$AnimeDetailService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AnimeDetailService;

  @override
  Future<Response<Map<String, dynamic>>> getAnimeDetail(int id) {
    final $url = '/anime/${id}/characters';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
