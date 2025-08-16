// Modelo que representa un artículo de noticias
class Article {
  // Autor del artículo (puede ser nulo si no viene en la API)
  final String? author; //? nulo

  // Título del artículo (obligatorio)
  final String title;

  // Descripción breve del artículo (opcional)
  final String? description;

  // URL del artículo (obligatorio)
  final String url;

  // URL de la imagen asociada al artículo (opcional)
  final String? urlToImage;

  // Fecha de publicación del artículo (obligatoria)
  final DateTime publishedAt;

  // Contenido del artículo (opcional)
  final String? content;

  // Nombre de la fuente (opcional)
  final String? sourceName;

  // Constructor de la clase Article
  Article({
    required this.title,       // El título es obligatorio
    required this.url,         // La URL es obligatoria
    required this.publishedAt, // La fecha de publicación es obligatoria
    this.author,               // El autor es opcional
    this.description,          // La descripción es opcional
    this.urlToImage,           // La imagen es opcional
    this.content,              // El contenido es opcional
    this.sourceName,           // El nombre de la fuente es opcional
  });

  // Método de fábrica que crea un objeto Article desde un JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      author: json['author'], // Extrae el autor si existe
      title: json['title'] ?? '', // Si no viene el título, usa cadena vacía
      description: json['description'], // Extrae la descripción
      url: json['url'] ?? '', // La URL es obligatoria, por eso aseguramos que no sea null
      urlToImage: json['urlToImage'], // Extrae la imagen si existe
      publishedAt: DateTime.parse(json['publishedAt']), // Convierte la fecha a DateTime
      content: json['content'], // Extrae el contenido si existe
      sourceName: json['source'] != null ? json['source']['name'] : null, 
      // Verifica si existe 'source', y dentro de él, el campo 'name'
    );
  }

  // Sobrescribe el operador de igualdad (==) para comparar artículos por su URL
  @override
  bool operator ==(Object other) =>
      identical(this, other) || // Si son el mismo objeto en memoria
      other is Article && other.url == url; // O si tienen la misma URL

  // Genera un hash único basado en la URL
  @override
  int get hashCode => url.hashCode;
}
