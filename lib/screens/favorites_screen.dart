import 'package:flutter/material.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Article> favorites;
  final Function(Article) onFavoriteToggle;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.favorites.isEmpty) {
      return const Center(
          child: Text("Por el momento no hay noticias guardadas"));
    }
    return ListView.builder(
      itemCount: widget.favorites.length,
      itemBuilder: (context, index) {
        final article = widget.favorites[index];
        return ArticleCard(
          article: article,
          onTap: () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => ArticleDetailScreen(
                  article: article,
                  isFavorite: true,
                  onFavoriteToggle: widget.onFavoriteToggle,
                ),
              ),
            );

            if (result == true) {
              setState(() {});
            }
          },
        );
      },
    );
  }
}
