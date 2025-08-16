// Importa Flutter y widgets necesarios
import 'package:flutter/material.dart';
import '../models/article.dart'; // Modelo Article
import '../widgets/article_card.dart'; // Widget para mostrar cada noticia
import 'article_detail_screen.dart'; // Pantalla de detalle de la noticia

// Pantalla que muestra las noticias guardadas como favoritas
class FavoritesScreen extends StatefulWidget {
  final List<Article> favorites; // Lista de artículos favoritos
  final Function(Article) onFavoriteToggle; // Función para agregar/quitar favoritos

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
    // Si no hay favoritos, muestra un mensaje
    if (widget.favorites.isEmpty) {
      return const Center(
          child: Text("Por el momento no hay noticias guardadas"));
    }

    // Si hay favoritos, los muestra en una lista
    return ListView.builder(
      itemCount: widget.favorites.length, // Número de artículos
      itemBuilder: (context, index) {
        final article = widget.favorites[index];

        return ArticleCard(
          article: article,
          onTap: () async {
            // Navega al detalle del artículo y espera un resultado
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

            // Si hubo un cambio en favoritos, actualiza la pantalla
            if (result == true) {
              setState(() {});
            }
          },
        );
      },
    );
  }
}
