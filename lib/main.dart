import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'models/article.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,          
    systemNavigationBarColor: Colors.transparent, 
    systemNavigationBarIconBrightness: Brightness.dark, 
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  int currentIndex = 0;
  List<Article> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

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

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        favorites.map((article) => _articleToJson(article)).toList();
    await prefs.setString('favorites', jsonEncode(jsonList));
  }

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

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  void toggleFavorite(Article article) {
    setState(() {
      if (favorites.contains(article)) {
        favorites.remove(article);
      } else {
        favorites.add(article);
      }
    });
    _saveFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(favorites: favorites, onFavoriteToggle: toggleFavorite),
      FavoritesScreen(favorites: favorites, onFavoriteToggle: toggleFavorite),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        extendBody: true, 
        appBar: AppBar(
          backgroundColor: Color(0xFFE0442E),
          elevation: 0,
          title: Text(
            currentIndex == 0 ? "Noticias Más Recientes" : "Noticias Guardadas",
          ),
          centerTitle: true,
          actions: [
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
        body: screens[currentIndex],
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
          onTap: (index) => setState(() => currentIndex = index),
        ),
      ),
    );
  }
}
