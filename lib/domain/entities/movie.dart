/// ================================================================================
/// ENTIDAD: PELÍCULA (DOMAIN LAYER)
/// ================================================================================
/// 
/// Una entidad es un objeto "puro" que solo contiene datos.
/// No sabe cómo se obtienen esos datos ni cómo se serializan.
/// 
/// Movie representa los datos de una película que la app necesita:
/// - Información visual (poster, backdrop)
/// - Valores de calidad (rating, votos)
/// - Información del contenido (título, descripción, géneros)
/// - Metadatos (idioma, fecha de lanzamiento)
/// 
/// INMUTABILIDAD: Todos los campos son 'final' (no pueden cambiar)
/// Esto previene bugs y hace el código predecible.
/// 
/// RESPONSABILIDAD: Solo almacenar datos, nada más.
/// No contiene lógica de negocio ni llamadas a API.
/// 
class Movie {
  final bool adult;
  final String backdropPath;
  final List<String> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  /// Constructor: Requiere TODOS los campos para crear una Movie.
  /// Esto garantiza que no haya películas incompletas en memoria.
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