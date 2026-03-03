import 'package:cinemapedia/domain/entities/movie.dart';

/// ================================================================================
/// REPOSITORIO ABSTRACTO: PELÍCULAS (DOMAIN LAYER)
/// ================================================================================
/// 
/// Un repositorio es un "contrato" que define QUÉ operaciones se pueden hacer,
/// pero NO CÓMO hacerlas.
/// 
/// Este patrón (Dependency Inversion) permite que:
/// - La capa de presentación NO dependa de detalles técnicos
/// - Se puedan cambiar fuentes de datos sin afectar la UI
/// - Sea fácil testear con datos ficticios (mocks)
/// 
/// Responsabilidades que una clase que implemente este repositorio debe cumplir:
/// 1. Obtener películas en cines ahora (getNowPlaying)
/// 2. Obtener películas populares (getPopular)
/// 3. Obtener películas próximas (getUpcoming)
/// 4. Obtener películas mejor valoradas (getTopRated)
/// 5. Obtener detalles de una película específica (getMovieById)
/// 6. Buscar películas por nombre (searchMovies)
/// 
/// Ver implementación en: lib/infrastructure/repositories/movie_repository_impl.dart
/// 
abstract class MoviesRepository {

  /// Obtiene películas que están en cines en este momento.
  /// Parámetro 'page': para paginación (por defecto 1)
  Future<List<Movie>> getNowPlaying({ int page = 1 });

  /// Obtiene películas más populares ordenadas por popularidad
  Future<List<Movie>> getPopular({ int page = 1 });
  
  /// Obtiene próximas películas que se van a estrenar
  Future<List<Movie>> getUpcoming({ int page = 1 });

  /// Obtiene películas con mejor rating histórico
  Future<List<Movie>> getTopRated({ int page = 1 });

  /// Obtiene detalles completos de una película específica (por ID)
  /// Retorna UNA película, no una lista
  Future<Movie> getMovieById( String id );

  /// Busca películas por nombre/query. Útil para la barra de búsqueda
  Future<List<Movie>> searchMovies( String query );
}