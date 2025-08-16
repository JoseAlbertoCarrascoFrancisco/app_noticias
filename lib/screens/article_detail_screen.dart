// Importa Flutter y dependencias necesarias
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para controlar el modo de la UI
import '../models/article.dart'; // Modelo Article
import 'package:android_intent_plus/android_intent.dart'; // Para abrir enlaces en Android
import 'package:android_intent_plus/flag.dart'; // Flags para intents

// Pantalla de detalle de un artículo
class ArticleDetailScreen extends StatefulWidget {
  final Article article; // El artículo que se va a mostrar
  final bool isFavorite; // Indica si ya está en favoritos
  final Function(Article) onFavoriteToggle; // Función para agregar/quitar favoritos

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
  // Estado interno para manejar si el artículo está en favoritos
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    // Inicializa el estado del favorito con el valor recibido
    isFavorite = widget.isFavorite;

    // Cambia la UI del sistema a "pantalla completa" inmersiva
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restaura la UI normal cuando se sale de la pantalla
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // Función para agregar/quitar favoritos
  void _toggleFavorite() {
    widget.onFavoriteToggle(widget.article); // Llama la función enviada desde Home
    setState(() {
      isFavorite = !isFavorite; // Cambia el estado
    });

    // Muestra un mensaje flotante
    final message =
        isFavorite ? 'Noticia guardada' : 'Noticia eliminada de guardados';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(child: Text(message))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    // Formatea la fecha de publicación (dd/mm/yyyy)
    final publishedDate =
        '${article.publishedAt.toLocal().day}/${article.publishedAt.toLocal().month}/${article.publishedAt.toLocal().year}';

    return Scaffold(
      // Barra superior
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0442E),
        title: const Text("Nota Completa"),
        centerTitle: true,
      ),

      // Cuerpo principal
      body: Column(
        children: [
          // Contenido desplazable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Imagen principal si existe
                  if (article.urlToImage != null &&
                      article.urlToImage!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(article.urlToImage!),
                    ),
                  const SizedBox(height: 16),

                  // Descripción si existe
                  if (article.description != null &&
                      article.description!.isNotEmpty)
                    Text(
                      article.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 16),

                  // Autor y fecha
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

          // Botones (dentro de SafeArea para evitar el notch)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Botón para abrir la nota completa en navegador
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Intenta abrir la URL en Android con un Intent
                        final intent = AndroidIntent(
                          action: 'action_view',
                          data: article.url,
                          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                        );
                        await intent.launch();
                      } catch (e) {
                        // Si hay error, muestra un mensaje
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
                      minimumSize: const Size(double.infinity, 36), // Botón ancho
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      backgroundColor: const Color(0xFFE0442E), 
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

                  // Botón flotante para favoritos
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
                        isFavorite
                            ? Icons.bookmark
                            : Icons.bookmark_border, // Icono según estado
                        color:
                            isFavorite ? Colors.orangeAccent : Colors.grey,
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
