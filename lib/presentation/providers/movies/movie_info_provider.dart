import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

/// ================================================================================
/// PROVIDER: CACHÉ DE PELÍCULAS DETALLADAS (POR ID)
/// ================================================================================
/// 
/// Este StateNotifierProvider mantiene un caché de películas individuales
/// indexadas por su ID para evitar peticiones repetidas al mismo detalle.
/// 
/// RESPONSABILIDAD:
/// - Almacenar películas individuales cargadas (Map<movieId, Movie>)
/// - Evitar cargar dos veces la misma película
/// - Reutilizar datos de API en pantalla de detalles
/// 
/// ESTRUCTURA DEL ESTADO:
/// ```
/// {
///   '505642': Movie(title: 'Avatar', ...),
///   '505643': Movie(title: 'Dune', ...),
///   '505645': Movie(title: 'Oppenheimer', ...),
///   '501231': Movie(title: 'Barbie', ...),
/// }
/// ```
/// 
/// FLUJO:
/// 1. MovieScreen pide detalle de película (ej: ID 505642)
/// 2. Llama loadMovie('505642')
/// 3. Si ya existe en caché, devuelve sin hacer HTTP
/// 4. Si no existe, llama movieRepository.getMovieById()
/// 5. Guarda en el Map para futuros accesos
/// 
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch( movieRepositoryProvider );
  return MovieMapNotifier(getMovie: movieRepository.getMovieById );
});


/*
  {
    '505642': Movie(),
    '505643': Movie(),
    '505645': Movie(),
    '501231': Movie(),
  }
*/

typedef GetMovieCallback = Future<Movie>Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String,Movie>> {

  final GetMovieCallback getMovie;

  MovieMapNotifier({
    required this.getMovie,
  }): super({});


  Future<void> loadMovie( String movieId ) async {
    if ( state[movieId] != null ) return;
    final movie = await getMovie( movieId );
    state = { ...state, movieId: movie };
  }

}