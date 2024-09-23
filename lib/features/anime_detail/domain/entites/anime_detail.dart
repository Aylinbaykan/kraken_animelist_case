class VoiceActor {
  final String name;
  final String language;
  final String imageUrl;

  VoiceActor({
    required this.name,
    required this.language,
    required this.imageUrl,
  });

  // JSON verisinden VoiceActor oluşturuluyor
  factory VoiceActor.fromJson(Map<String, dynamic> json) {
    return VoiceActor(
      name: json['person']['name'] ?? 'Unknown',
      language: json['language'] ?? 'Unknown',
      imageUrl: json['person']['images']['jpg']['image_url'] ??
          'https://via.placeholder.com/150', // Default görsel URL
    );
  }
}

class Character {
  final String name;
  final String imageUrl;
  final String role;
  final int favorites;
  final List<VoiceActor> voiceActors;

  Character({
    required this.name,
    required this.imageUrl,
    required this.role,
    required this.favorites,
    required this.voiceActors,
  });

  // JSON verisinden Character oluşturuluyor
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['character']['name'] ?? 'Unknown',
      imageUrl: json['character']['images']['jpg']['image_url'] ??
          'https://via.placeholder.com/150', // Default görsel URL
      role: json['role'] ?? 'Unknown',
      favorites: json['favorites'] ?? 0,
      voiceActors: (json['voice_actors'] as List)
          .map((actorJson) => VoiceActor.fromJson(actorJson))
          .toList(),
    );
  }
}

class AnimeDetail {
  final List<Character> characters;

  AnimeDetail({required this.characters});

  factory AnimeDetail.fromJson(Map<String, dynamic> json) {
    return AnimeDetail(
      characters: (json['data'] as List)
          .map((charJson) => Character.fromJson(charJson))
          .toList(),
    );
  }
}
