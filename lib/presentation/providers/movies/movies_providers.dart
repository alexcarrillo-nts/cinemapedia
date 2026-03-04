/// 🎬 PROVIDERS DE PELÍCULAS - movies_providers.dart
///
/// Providers = Gestores de estado usando Riverpod.
/// Aquí es donde Riverpod transforma una función de película
/// en un observable que notifica a los widgets de cambios.
///
/// PROVIDERS DISPONIBLES:
/// - nowPlayingMoviesProvider → Películas en cartelera
/// - popularMoviesProvider → Películas populares
/// - upcomingMoviesProvider → Próximos estrenos
/// - topRatedMoviesProvider → Mejor puntuadas
///
/// CÓMO FUNCIONA:
/// 1. Widget llama: ref.watch(nowPlayingMoviesProvider)
/// 2. Provider obtiene datos del repositorio
/// 3. Crea un MoviesNotifier (StateNotifier)
/// 4. Widget se reconstruye cuando state cambia
/// 5. loadNextPage() añade más películas (paginación)

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider: Películas en cartelera ahora
/// StateNotifierProvider = Permite cambiar el estado con asynchronous operations
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  /// ref.watch() obtiene el repositorio
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying;
  /// Retorna un MoviesNotifier con la función getNowPlaying
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

/// Provider: Películas populares
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getPopular;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

/// Provider: Próximos estrenos
final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getUpcoming;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

/// Provider: Películas mejor puntuadas
final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getTopRated;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

/// Tipo: Función que trae películas de una categoría
/// Future<List<Movie>> y recibe un página opcional
typedef MovieCallback = Future<List<Movie>> Function({ int page });

/// StateNotifier: Gestiona el estado (lista de películas) y paginación
/// 
/// RESPONSABILIDAD:
/// - Mantener lista de películas en memoria (state)
/// - Cargar siguiente página cuando se pide
/// - Evitar cargas simultáneas (isLoading)
class MoviesNotifier extends StateNotifier<List<Movie>> {
  
  /// Página actual (comienza en 0, sube con loadNextPage)
  int currentPage = 0;
  
  /// Previene que se carguen múltiples páginas al mismo tiempo
  bool isLoading = false;
  
  /// Función para traer películas (getNowPlaying, getPopular, etc)
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies,
  }): super([]);  /// Estado inicial: lista vacía

  /// Carga la siguiente página y añade películas al estado
  Future<void> loadNextPage() async{
    /// Si ya está cargando, no hagas nada más
    if ( isLoading ) return;
    isLoading = true;

    /// Incrementa página y trae películas
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies( page: currentPage );
    
    /// [...state, ...movies] = viejo estado + nuevas películas
    /// Notifica a todos los widgets que escuchan este provider
    state = [...state, ...movies];
    
    /// Pequeña pausa para evitar spam de requests
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}

