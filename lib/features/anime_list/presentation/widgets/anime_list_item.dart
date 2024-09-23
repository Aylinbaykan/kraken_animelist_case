import 'package:flutter/material.dart';
import '../../domain/entities/anime.dart';

class AnimeListItem extends StatelessWidget {
  // Görüntülenecek detayları içeren anime nesnesi
  // The anime object containing the details to display
  final Anime anime;

  // Öğeye tıklandığında tetiklenen geri çağırma fonksiyonu
  // Callback function triggered when the item is tapped
  final Function(int) onTap;

  AnimeListItem({required this.anime, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(anime.id),
      title: Text(anime.title),
      subtitle: Text('Rating: ${anime.ratingScore}'),
      leading: Image.network(
        anime.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }
}
