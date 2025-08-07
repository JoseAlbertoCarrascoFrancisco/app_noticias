import 'package:flutter/material.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Article> favorites;
  final Function(Article) onFavoriteToggle;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const Center(child: Text("No tienes noticias guardadas"));
    }

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final article = favorites[index];
        return ArticleCard(
          article: article,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArticleDetailScreen(
                  article: article,
                  isFavorite: true,
                  onFavoriteToggle: onFavoriteToggle,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
