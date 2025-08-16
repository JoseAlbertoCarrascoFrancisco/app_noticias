// Importa librerías necesarias
import 'package:flutter/material.dart';
import '../models/article.dart'; // Modelo Article
import '../services/api_service.dart'; // Servicio para obtener noticias
import '../widgets/article_card.dart'; // Widget para mostrar cada noticia
import 'article_detail_screen.dart'; // Pantalla de detalle del artículo

// Pantalla principal (lista de noticias)
class HomeScreen extends StatefulWidget {
  // Lista de artículos marcados como favoritos
  final List<Article> favorites;

  // Función para agregar/quitar favoritos
  final Function(Article) onFavoriteToggle;

  // Constructor
  const HomeScreen({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future para manejar la carga inicial de artículos
  late Future<List<Article>> articlesFuture;

  // Lista con todos los artículos cargados
  List<Article> allArticles = [];

  // Lista filtrada (para búsqueda)
  List<Article> filteredArticles = [];

  // Controlador para la barra de búsqueda
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Llama al servicio para cargar artículos
    articlesFuture = ApiService().fetchArticles();

    // Cuando se cargan, los guarda en las listas
    articlesFuture.then((loadedArticles) {
      setState(() {
        allArticles = loadedArticles;
        filteredArticles = loadedArticles;
      });
    });

    // Escucha los cambios en el campo de búsqueda
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // Quita el listener y libera el controlador
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Filtra artículos según lo escrito en la barra de búsqueda
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredArticles = allArticles.where((article) {
        return article.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Refresca la lista de artículos al hacer pull-to-refresh
  Future<void> _refreshArticles() async {
    final updatedArticles = await ApiService().fetchArticles();
    setState(() {
      allArticles = updatedArticles;
      filteredArticles = updatedArticles.where((article) {
        return article.title
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder se usa para manejar la carga inicial
    return FutureBuilder<List<Article>>(
      future: articlesFuture,
      builder: (context, snapshot) {
        // Mientras se cargan los artículos
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Si ocurre un error en la carga
        if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar noticias"));
        }

        // Contenido principal
        return Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar noticias...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Lista de artículos
            Expanded(
              child: filteredArticles.isEmpty
                  // Si no hay resultados
                  ? const Center(
                      child: Text('Por el momento no se encontraron noticias'))
                  // Si hay resultados, permite refrescar con "pull-to-refresh"
                  : RefreshIndicator(
                      onRefresh: _refreshArticles,
                      child: ListView.builder(
                        itemCount: filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = filteredArticles[index];
                          return ArticleCard(
                            article: article,
                            onTap: () {
                              // Al tocar una noticia, navega a su detalle
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ArticleDetailScreen(
                                    article: article,
                                    isFavorite:
                                        widget.favorites.contains(article),
                                    onFavoriteToggle: widget.onFavoriteToggle,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
