import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  final String _apiKey = 'ee99d0a4da6c4298b8603ed5d4d216a2';

  Future<List<Article>> fetchArticles() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=tesla&from=2025-07-05&sortBy=publishedAt&apiKey=$_apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['articles'] != null) {
        final articles = (data['articles'] as List)
            .map((json) => Article.fromJson(json))
            .toList();
        return articles;
      } else {
        throw Exception('No se encontraron artículos');
      }
    } else {
      throw Exception('Error al cargar noticias: ${response.statusCode}');
    }
  }
}