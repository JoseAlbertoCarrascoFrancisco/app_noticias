import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'models/article.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  int currentIndex = 0;
  List<Article> favorites = [];

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  void toggleFavorite(Article article) {
    setState(() {
      favorites.contains(article)
          ? favorites.remove(article)
          : favorites.add(article);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        favorites: favorites,
        onFavoriteToggle: toggleFavorite,
      ),
      FavoritesScreen(
        favorites: favorites,
        onFavoriteToggle: toggleFavorite,
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Noticias Más Recientes"),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'theme') toggleTheme();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'theme',
                  child: Text(isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
                ),
              ],
            )
          ],
        ),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.article), label: "Noticias Principales"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Noticias Favoritas"),
          ],
          onTap: (index) => setState(() => currentIndex = index),
        ),
      ),
    );
  }
}
