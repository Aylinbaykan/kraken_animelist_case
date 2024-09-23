import 'package:mikrogrup/features/anime_detail/domain/entites/anime_detail.dart';

class VoiceActorModel extends VoiceActor {
  VoiceActorModel({
    required String name,
    required String language,
    required String imageUrl,
  }) : super(name: name, language: language, imageUrl: imageUrl);

  factory VoiceActorModel.fromJson(Map<String, dynamic> json) {
    return VoiceActorModel(
      name: json['person']['name'] ?? 'Unknown Name',
      language: json['language'] ?? 'Unknown Language',
      imageUrl: json['person']['images']['jpg']['image_url'] ?? '',
    );
  }
}

class CharacterModel extends Character {
  CharacterModel({
    required String name,
    required String imageUrl,
    required String role,
    required int favorites,
    required List<VoiceActorModel> voiceActors,
  }) : super(
            name: name,
            imageUrl: imageUrl,
            role: role,
            favorites: favorites,
            voiceActors: voiceActors);

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      name: json['character']['name'] ?? 'Unknown Name',
      imageUrl: json['character']['images']['jpg']['image_url'] ??
          '', // null kontrolü
      role: json['role'] ?? 'Unknown Role',
      favorites: json['favorites'] ?? 0,
      voiceActors: (json['voice_actors'] as List?)
              ?.map((actorJson) => VoiceActorModel.fromJson(actorJson))
              .toList() ??
          [],
    );
  }
}

class AnimeDetailModel extends AnimeDetail {
  AnimeDetailModel({required List<CharacterModel> characters})
      : super(characters: characters);

  factory AnimeDetailModel.fromJson(Map<String, dynamic> json) {
    return AnimeDetailModel(
      characters: (json['data'] as List?)
              ?.map((charJson) => CharacterModel.fromJson(charJson))
              .toList() ??
          [],
    );
  }
}
