import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ================================================================================
/// PROVIDERS DE PELÍCULAS - ESTADO (PRESENTATION LAYER)
/// ================================================================================
/// 
/// Estos providers manejan el estado (datos cambiantes) de las listas de películas.
/// Cada uno maneja una categoría diferente:
/// - nowPlayingMoviesProvider: Películas EN CINES AHORA
/// - popularMoviesProvider: Películas POPULARES
/// - topRatedMoviesProvider: Películas MEJOR VALORADAS
/// - upcomingMoviesProvider: PRÓXIMAS películas
/// 
/// Riverpod detecta cambios automáticamente y redibu ja los widgets.
/// 
/// ESTRUCTURA:
/// StateNotifierProvider<MoviesNotifier, List<Movie>>
/// - MoviesNotifier: La clase que maneja el estado
/// - List<Movie>: El tipo del estado
/// 

/// PELÍCULAS EN CINES AHORA
/// Estado: Lista de películas en cines
/// Obtiene datos mediante: movieRepository.getNowPlaying(page: 1, 2, 3, ...)
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

/// PELÍCULAS POPULARES
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getPopular;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

/// PRÓXIMAS PELÍCULAS
final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getUpcoming;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

/// PELÍCULAS MEJOR VALORADAS
final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getTopRated;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

/// Tipo de función: Toma un número de página y retorna Future<List<Movie>>
/// Se usa como callback para abstraer qué método se está llamando
typedef MovieCallback = Future<List<Movie>> Function({ int page });

/// ================================================================================
/// NOTIFIER: LÓGICA DE ESTADO
/// ================================================================================
/// 
/// MoviesNotifier extiende StateNotifier<List<Movie>>
/// Esto significa:
/// - El estado es una List<Movie>
/// - El constructor super([]) inicializa con lista vacía
/// - El método loadNextPage() modifica este estado
/// 
class MoviesNotifier extends StateNotifier<List<Movie>> {
  
  /// Página actual (para paginación en el API)
  /// Comienza en 0, se incrementa a 1, 2, 3...
  int currentPage = 0;
  
  /// Bandera para evitar cargas simultáneas
  /// Si ya estamos cargando, no cargues de nuevo
  bool isLoading = false;
  
  /// Callback que sabe CÓMO obtener películas
  /// Puede ser getNowPlaying, getPopular, etc.
  MovieCallback fetchMoreMovies;

  /// Constructor que requiere el callback
  /// super([]) establece el estado inicial como lista vacía
  MoviesNotifier({
    required this.fetchMoreMovies,
  }): super([]);

  /// Método público para cargar la siguiente página de películas
  /// Este flujo:
  /// 1. Evita cargas simultáneas (isLoading)
  /// 2. Incrementa el número de página
  /// 3. Llama al callback (getNowPlaying, getPopular, etc.)
  /// 4. Añade nuevas películas al estado (spread operator)
  /// 5. Riverpod detecta cambio y redibujas los widgets
  Future<void> loadNextPage() async{
    if ( isLoading ) return;  // Evita cargas simultaneas
    isLoading = true;

    currentPage++;  // Página 0 -> 1
    final List<Movie> movies = await fetchMoreMovies( page: currentPage );
    state = [...state, ...movies];  // Añade nuevas películas
    
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }


}

