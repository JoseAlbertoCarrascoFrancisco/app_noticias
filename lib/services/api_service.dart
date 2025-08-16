// Importa librerías necesarias
import 'dart:convert'; // Para convertir respuestas JSON en objetos de Dart
import 'package:http/http.dart' as http; // Para realizar solicitudes HTTP
import '../models/article.dart'; // Importa el modelo Article para mapear los datos

// Clase encargada de conectarse con la API de noticias
class ApiService {
  // API Key para autenticar la solicitud (en este caso, de NewsAPI)
  final String _apiKey = '1022c5a493ad4d878c1957b4a84986cb';

  // Método que obtiene la lista de artículos desde la API
  Future<List<Article>> fetchArticles() async {
    // Fecha actual
    final DateTime now = DateTime.now();

    // Calcula la fecha de hace 7 días (para limitar la búsqueda)
    final DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Convierte la fecha a formato "YYYY-MM-DD" (que es lo que la API requiere)
    final String fromDate = sevenDaysAgo.toIso8601String().split('T').first;

    // Construye la URL con los parámetros de búsqueda
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?q=tesla&from=$fromDate&sortBy=publishedAt&apiKey=$_apiKey',
    );

    // Hace la petición GET a la API
    final response = await http.get(url);

    // Verifica si la respuesta fue exitosa (código 200)
    if (response.statusCode == 200) {
      // Convierte la respuesta en un mapa
      final data = jsonDecode(response.body);

      // Verifica si hay artículos en la respuesta
      if (data['articles'] != null) {
        // Convierte cada JSON en un objeto Article usando Article.fromJson
        return (data['articles'] as List)
            .map((json) => Article.fromJson(json))
            .toList();
      } else {
        // Si no hay artículos, lanza una excepción
        throw Exception('No se encontraron artículos');
      }
    } else {
      // Si la API devuelve error, lanza una excepción con el código de estado
      throw Exception('Error al cargar noticias: ${response.statusCode}');
    }
  }
}
