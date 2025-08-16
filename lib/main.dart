// Importa librerías necesarias
import 'dart:convert'; // Para codificar/decodificar JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para controlar la UI del sistema
import 'package:shared_preferences/shared_preferences.dart'; // Para guardar favoritos localmente
import 'screens/home_screen.dart'; // Pantalla principal
import 'screens/favorites_screen.dart'; // Pantalla de favoritos
import 'models/article.dart'; // Modelo Article

// Punto de entrada de la app
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa bindings de Flutter

  // Configura modo de pantalla y navegación
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Configura colores de status bar y navigation bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,          
    systemNavigationBarColor: Colors.transparent, 
    systemNavigationBarIconBrightness: Brightness.dark, 
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp()); // Ejecuta la app
}

// Widget principal de la app
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false; // Tema claro/oscuro
  int currentIndex = 0; // Índice de la pantalla seleccionada
  List<Article> favorites = []; // Lista de noticias favoritas

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Carga favoritos guardados al iniciar
  }

  // Carga los artículos favoritos desde SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favsString = prefs.getString('favorites');
    if (favsString != null) {
      final List<dynamic> jsonList = jsonDecode(favsString);
      setState(() {
        favorites = jsonList.map((json) => Article.fromJson(json)).toList();
      });
    }
  }

  // Guarda los artículos favoritos en SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        favorites.map((article) => _articleToJson(article)).toList();
    await prefs.setString('favorites', jsonEncode(jsonList));
  }

  // Convierte un artículo a JSON para guardarlo
  Map<String, dynamic> _articleToJson(Article article) {
    return {
      'author': article.author,
      'title': article.title,
      'description': article.description,
      'url': article.url,
      'urlToImage': article.urlToImage,
      'publishedAt': article.publishedAt.toIso8601String(),
      'content': article.content,
      'source': {'name': article.sourceName},
    };
  }

  // Cambia el tema de la app
  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  // Agrega o elimina un artículo de favoritos
  void toggleFavorite(Article article) {
    setState(() {
      if (favorites.contains(article)) {
        favorites.remove(article);
      } else {
        favorites.add(article);
      }
    });
    _saveFavorites(); // Guarda cambios
  }

  @override
  Widget build(BuildContext context) {
    // Lista de pantallas disponibles
    final screens = [
      HomeScreen(favorites: favorites, onFavoriteToggle: toggleFavorite),
      FavoritesScreen(favorites: favorites, onFavoriteToggle: toggleFavorite),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        extendBody: true, // Permite que el body se extienda bajo la barra de navegación
        appBar: AppBar(
          backgroundColor: const Color(0xFFE0442E), // Rojo principal
          elevation: 0,
          title: Text(
            currentIndex == 0 ? "Noticias Más Recientes" : "Noticias Guardadas",
          ),
          centerTitle: true,
          actions: [
            // Menú de opciones (cambiar tema)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'theme') toggleTheme();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'theme',
                  child: Text(
                    isDarkMode
                        ? 'Activar Modo Claro'
                        : 'Activar Modo Oscuro',
                  ),
                ),
              ],
            ),
          ],
        ),
        body: screens[currentIndex], // Muestra la pantalla actual
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: "Noticias Principales",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: "Noticias Guardadas",
            ),
          ],
          // Cambia la pantalla al seleccionar un item
          onTap: (index) => setState(() => currentIndex = index),
        ),
      ),
    );
  }
}
