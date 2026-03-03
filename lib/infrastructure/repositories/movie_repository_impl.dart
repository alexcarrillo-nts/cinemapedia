import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

/// ================================================================================
/// IMPLEMENTACIÓN: REPOSITORIO DE PELÍCULAS (INFRASTRUCTURE LAYER)
/// ================================================================================
/// 
/// Esta clase implementa el contrato (interfaz) MoviesRepository.
/// 
/// Se llama "adapter" porque adapta la interfaz del datasource
/// a la interfaz esperada por el rest de la aplicación.
/// 
/// PATRÓN: Inyección de dependencias
/// El datasource se pasa en el constructor, no se crea internamente.
/// Esto permite:
/// - Cambiar de datasource sin modificar este código
/// - Testear fácilmente con datasources ficticios (mocks)
/// 
/// RESPONSABILIDAD: Delegar al datasource
/// Este repositorio NO contiene lógica de negocio compleja.
/// Solo traduce llamadas de un lado al otro.
/// 
class MovieRepositoryImpl extends MoviesRepository {

  final MoviesDatasource datasource;
  
  /// Constructor: Requiere un datasource que sepa obtener películas
  MovieRepositoryImpl(this.datasource);

  
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    // Delega directamente al datasource
    // El datasource sabe HOW obtener los datos (llamada HTTP)
    // Este repositorio solo TRADUCE la llamada
    return datasource.getNowPlaying(page: page);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return datasource.getUpcoming(page: page);
  }
  
  @override
  Future<Movie> getMovieById(String id) {
    return datasource.getMovieById(id);
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) {
    return datasource.searchMovies(query);
  }


}