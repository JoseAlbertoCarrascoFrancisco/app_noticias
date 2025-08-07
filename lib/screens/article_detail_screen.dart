import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  final bool isFavorite;
  final Function(Article) onFavoriteToggle;

  const ArticleDetailScreen({
    super.key,
    required this.article,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final publishedDate =
        '${article.publishedAt.toLocal().day}/${article.publishedAt.toLocal().month}/${article.publishedAt.toLocal().year}';

    return Scaffold(
      appBar: AppBar(title: const Text("Nota Completa")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(article.urlToImage!),
              ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (article.description != null && article.description!.isNotEmpty)
              Text(
                article.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 16),
            if (article.sourceName != null && article.sourceName!.isNotEmpty)
              Chip(label: Text("Fuente: ${article.sourceName}")),
            if (article.author != null && article.author!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Autor: ${article.author!}"),
              ),
            const SizedBox(height: 16),
            Text("Publicado el: $publishedDate",
                style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse(article.url);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No se pudo abrir el enlace')),
                  );
                }
              },
              child: const Text("Leer nota completa"),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith(
                        (states) => states.contains(MaterialState.hovered)
                        ? Colors.blue.withOpacity(0.2)
                        : null),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => onFavoriteToggle(article),
                child: Text(
                  isFavorite ? "Quitar de favoritos" : "Agregar a favoritos",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 2),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.yellow[700],
                ),
                onPressed: () => onFavoriteToggle(article),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
