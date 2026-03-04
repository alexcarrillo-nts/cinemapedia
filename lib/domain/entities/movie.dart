/// 🎬 ENTIDAD PELÍCULA - movie.dart
///
/// Representa una película con sus propiedades principales.
/// Esta es una ENTIDAD PURA: solo contiene datos, sin métodos de negocios.
///
/// FLUJO DE DATOS:
/// JSON (API) → MovieModel → Movie (Entidad limpia) → UI (Widgets)

class Movie {
  /// Si es contenido solo para adultos (18+)
  final bool adult;
  
  /// URL relativa de la imagen de fondo (ej: /abc123.jpg)
  final String backdropPath;
  
  /// Lista de IDs de géneros (ej: [18, 28] = Drama, Acción)
  final List<String> genreIds;
  
  /// ID único de la película en The Movie DB
  final int id;
  
  /// Idioma original (ej: "en", "es")
  final String originalLanguage;
  
  /// Título original en su idioma (ej: "The Original Title")
  final String originalTitle;
  
  /// Resumen/descripción de la película
  final String overview;
  
  /// Métrica de popularidad (0-100, a mayor número más popular)
  final double popularity;
  
  /// URL relativa del póster (ej: /abc123.jpg)
  final String posterPath;
  
  /// Fecha de lanzamiento
  final DateTime releaseDate;
  
  /// Título traducido o en idioma actual
  final String title;
  
  /// ¿Es un video?  (generalmente false para películas)
  final bool video;
  
  /// Calificación de usuarios (0-10)
  final double voteAverage;
  
  /// Cantidad total de votos
  final int voteCount;

  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount
  });
}