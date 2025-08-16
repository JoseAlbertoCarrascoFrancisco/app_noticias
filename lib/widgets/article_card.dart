// Importa el framework de Flutter para crear interfaces gráficas
import 'package:flutter/material.dart';

// Importa el modelo Article para mostrar sus datos
import '../models/article.dart';

// Widget reutilizable que muestra un artículo dentro de una tarjeta
class ArticleCard extends StatelessWidget {
  // Recibe un objeto Article (con la info de la noticia)
  final Article article;

  // Callback que se ejecuta al dar clic en la tarjeta
  final VoidCallback onTap;

  // Constructor de la clase (requiere un artículo y la función onTap)
  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Margen alrededor de la tarjeta
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      // Sombra de la tarjeta
      elevation: 2,

      // Bordes redondeados de la tarjeta
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      // Contenido principal: un ListTile
      child: ListTile(
        // Espaciado interno
        contentPadding: const EdgeInsets.all(8),

        // Imagen que se muestra al inicio de la tarjeta
        leading: article.urlToImage != null && article.urlToImage!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                child: Image.network(
                  article.urlToImage!, // Carga la imagen desde la URL
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover, // Ajusta la imagen al espacio
                  // Si ocurre un error al cargar la imagen, muestra un ícono
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 40),
                ),
              )
            // Si no hay imagen, muestra un ícono por defecto
            : const Icon(Icons.image_not_supported, size: 40),

        // Título del artículo
        title: Text(
          article.title,
          maxLines: 2, // Máximo de dos líneas
          overflow: TextOverflow.ellipsis, // Si es muy largo, agrega "..."
        ),

        // Acción al tocar la tarjeta
        onTap: onTap,
      ),
    );
  }
}
