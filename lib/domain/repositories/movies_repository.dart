/// 🎞️ CONTRATO DE REPOSITORIO - movies_repository.dart
///
/// Interfaz (clase abstracta) que actúa como intermediaria.
/// El Repositorio es la CAPA 3: coordina entre Domain e Infrastructure.
///
/// RESPONSABILIDAD:
/// - Define QUÉ MÉTODOS deben existir para acceder a datos
/// - NO implementa, solo declara (será implementada por infrastructure)
/// - Los Providers (UI) usarán este repositorio para pedir datos
///
/// PATRÓN REPOSITORY:
/// - Aísla la lógica de datos de la presentación
/// - Si cambias el datasource, el resto de la app sigue igual
/// - Clean Architecture: Domain → no depende de Infrastructure

import 'package:cinemapedia/domain/entities/movie.dart';

/// Clase abstracta que define cómo acceder a películas
abstract class MoviesRepository {
  
  /// Películas en cartelera ahora
  Future<List<Movie>> getNowPlaying({ int page = 1 });

  /// Películas más populares
  Future<List<Movie>> getPopular({ int page = 1 });
  
  /// Próximos estrenos
  Future<List<Movie>> getUpcoming({ int page = 1 });

  /// Películas mejor puntuadas
  Future<List<Movie>> getTopRated({ int page = 1 });

  /// Detalles completos de una película
  Future<Movie> getMovieById( String id );

  /// Búsqueda de películas por nombre
  Future<List<Movie>> searchMovies( String query );
}