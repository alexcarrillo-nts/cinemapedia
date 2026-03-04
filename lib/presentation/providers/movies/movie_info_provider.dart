/// 🎥 PROVIDER DE INFO PELÍCULA - movie_info_provider.dart
///
/// Gesiona los detalles COMPLETOS de una película por ID.
/// A diferencia de moviesProviders (lista), este es para UN película.
///
/// ESTRUCTURA DE DATOS:
/// State = { movieId -> Movie }
/// Ejemplo: { '505642': Movie(...), '505643': Movie(...) }
///
/// RAZÓN DEL MAPA:
/// - Un usuario puede ver varias películas en la misma sesión
/// - En lugar de descartar datos, los guardamos en caché
/// - Si pides la misma película 2x, no hace 2 requests
/// - Sistema de caché automático = mejor UX

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

/// Provider: Información detallada de películas en caché
/// State = Mapa de {movieId -> detalles completos}
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  /// Obtiene el repositorio para hacer requests
  final movieRepository = ref.watch( movieRepositoryProvider );
  return MovieMapNotifier(getMovie: movieRepository.getMovieById );
});

/// Ejemplo de estructura del state:
/// {
///   '505642': Movie(title: 'Película 1', ...), // En caché
///   '505643': Movie(title: 'Película 2', ...), // En caché
///   '501231': Movie(title: 'Película 3', ...), // En caché
/// }

/// Tipo: Función para obtener una película por ID desde API
typedef GetMovieCallback = Future<Movie>Function(String movieId);

/// StateNotifier: Gestiona caché de películas
/// 
/// RESPONSABILIDAD:
/// - Mantener mapa de películas ya cargadas
/// - Si se pide una película que no está en caché, cargarla
/// - Si ya está, devolverla de inmediato (sin request)
class MovieMapNotifier extends StateNotifier<Map<String,Movie>> {
  
  /// Función para obtener película de API
  final GetMovieCallback getMovie;

  MovieMapNotifier({
    required this.getMovie,
  }): super({});  /// Estado inicial: mapa vacío

  /// Carga una película por su ID
  /// Si ya existe en caché, no hace nada
  /// Si no existe, pide al API y la agrega al mapa
  Future<void> loadMovie( String movieId ) async {
    /// Si la película ya está en caché, salir temprano
    if ( state[movieId] != null ) return;
    
    /// Obtener película de API
    final movie = await getMovie( movieId );
    
    /// Agregar al mapa: {...state, nuevoId: nuevaPelicula}
    /// Notifica a widgets que confían en este provider
    state = { ...state, movieId: movie };
  }
}