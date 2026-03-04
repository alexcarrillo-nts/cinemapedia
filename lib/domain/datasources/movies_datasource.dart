/// 📡 CONTRATO DE DATASOURCE - movies_datasource.dart
///
/// Interfaz (clase abstracta) que define qué métodos DEBE TENER
/// cualquier fuente de datos de películas.
///
/// Esta es la CAPA 2 (Domain):
/// - Define QUÉ datos queremos
/// - NO DICE CÓMO obtenerlos (eso es responsabilidad de Infrastructure)
///
/// MÉTODOS:
/// - getNowPlaying() → Películas en cartelera AHORA
/// - getPopular() → Las más populares
/// - getUpcoming() → Próximos estrenos
/// - getTopRated() → Mejor puntuadas
/// - getMovieById() → Detalles de una película
/// - searchMovies() → Buscar películas por nombre

import 'package:cinemapedia/domain/entities/movie.dart';

/// Clase abstracta que define la interfaz de acceso a películas
/// Debe ser implementada por MoviedbDatasource en infrastructure/
abstract class MoviesDatasource {
  
  /// Obtiene películas actualmente en cines
  /// page: número de página para paginación (API retorna 20 por página)
  Future<List<Movie>> getNowPlaying({ int page = 1 });

  /// Obtiene películas más populares
  Future<List<Movie>> getPopular({ int page = 1 });

  /// Obtiene próximos estrenos
  Future<List<Movie>> getUpcoming({ int page = 1 });

  /// Obtiene películas mejor puntuadas
  Future<List<Movie>> getTopRated({ int page = 1 });
  
  /// Obtiene detalles completos de una película por su ID
  Future<Movie> getMovieById( String id );

  /// Busca películas por palabra clave
  Future<List<Movie>> searchMovies( String query );
}