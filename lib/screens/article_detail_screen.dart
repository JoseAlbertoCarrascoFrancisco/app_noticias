import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/article.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class ArticleDetailScreen extends StatefulWidget {
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
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleFavorite() {
    widget.onFavoriteToggle(widget.article);
    setState(() {
      isFavorite = !isFavorite;
    });

    final message =
        isFavorite ? 'Noticia guardada' : 'Noticia eliminada de guardados';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(child: Text(message))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final publishedDate =
        '${article.publishedAt.toLocal().day}/${article.publishedAt.toLocal().month}/${article.publishedAt.toLocal().year}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE0442E),
        title: const Text("Nota Completa"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (article.urlToImage != null &&
                      article.urlToImage!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(article.urlToImage!),
                    ),
                  const SizedBox(height: 16),
                  if (article.description != null &&
                      article.description!.isNotEmpty)
                    Text(
                      article.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (article.author != null && article.author!.isNotEmpty)
                        Expanded(
                          child: Text(
                            "Autor: ${article.author!}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      Text(
                        "Publicado el: $publishedDate",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SafeArea( 
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final intent = AndroidIntent(
                          action: 'action_view',
                          data: article.url,
                          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                        );
                        await intent.launch();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error al abrir el enlace: $e',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 36),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      backgroundColor: Color(0xFFE0442E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Leer nota completa",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      heroTag: 'fav-btn',
                      backgroundColor: Colors.white,
                      onPressed: _toggleFavorite,
                      tooltip: isFavorite
                          ? 'Quitar de favoritos'
                          : 'Agregar a favoritos',
                      child: Icon(
                        isFavorite ? Icons.bookmark : Icons.bookmark_border,
                        color: isFavorite ? Colors.orangeAccent : Colors.grey,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
