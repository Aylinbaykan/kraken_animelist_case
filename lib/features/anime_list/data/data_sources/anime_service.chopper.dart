// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$AnimeService extends AnimeService {
  _$AnimeService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AnimeService;

  @override
  Future<Response<Map<String, dynamic>>> getAnimes(
    int? page,
    String? filter,
    String? status,
  ) {
    final $url = '/top/anime';
    final $params = <String, dynamic>{
      'page': page,
      'type': filter,
      'status': status,
    };
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
