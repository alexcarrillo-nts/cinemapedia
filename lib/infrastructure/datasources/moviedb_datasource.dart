import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

/// ================================================================================
/// DATASOURCE: PELÍCULAS (INFRASTRUCTURE LAYER)
/// ================================================================================
/// 
/// Un datasource es el "encargado de traer los datos" de una fuente específica.
/// En este caso: The Movie Database (TMDB) API.
/// 
/// Responsabilidades:
/// 1. Hacer llamadas HTTP a TMDB
/// 2. Deserializar JSON a objetos Dart
/// 3. Filtrar datos innecesarios
/// 4. Mapear a entidades de dominio
/// 
/// VENTAJA: Si mañana queres cambiar de API (a otra fuente de datos),
/// solo cambias este archivo. El resto de la app NO se entera.
/// 
class MoviedbDatasource extends MoviesDatasource {

  /// Configuración de DIO (cliente HTTP)
  /// - baseUrl: URL base de todas las llamadas
  /// - queryParameters: Parámetros que se añaden SIEMPRE a cada request
  ///   (API key y idioma)
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',  // API de The Movie Database
    queryParameters: {
      'api_key': Environment.theMovieDbKey,   // Señal de seguridad (del .env)
      'language': 'es-ES'                     // Idioma de las respuestas
    }
  ));

  /// Método privado que convierte respuesta JSON a List<Movie>
  /// Este proceso:
  /// 1. Deserializa JSON
  /// 2. Filtra películas sin póster
  /// 3. Mapea cada una a entidad Movie
  List<Movie> _jsonToMovies( Map<String,dynamic> json ) {

    final movieDBResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' )
    .map(
      (moviedb) => MovieMapper.movieDBToEntity(moviedb)
    ).toList();

    return movies;

  }


  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {
        'page': page
      }
    );
    
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
     
    final response = await dio.get('/movie/popular', 
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);    
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
     
    final response = await dio.get('/movie/top_rated', 
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);    
  }

   @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
     
    final response = await dio.get('/movie/upcoming', 
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);    
  }


  @override
  Future<Movie> getMovieById( String id ) async {

    final response = await dio.get('/movie/$id');
    if ( response.statusCode != 200 ) throw Exception('Movie with id: $id not found');
    
    final movieDetails = MovieDetails.fromJson( response.data );
    final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);
    return movie;
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async{

    if ( query.isEmpty ) return [];

    final response = await dio.get('/search/movie', 
      queryParameters: {
        'query': query
      }
    );

    return _jsonToMovies(response.data);    
  }


}