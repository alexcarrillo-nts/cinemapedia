/// 🔗 IMPLEMENTACIÓN DE DATASOURCE - moviedb_datasource.dart
///
/// Aquí está la IMPLEMENTACIÓN REAL de cómo obtener datos de la API.
/// Extiende MoviesDatasource (interfaz del Domain).
///
/// FLUJO:
/// 1. Recibe solicitud (ej: getNowPlaying())
/// 2. Hace petición HTTP a The Movie DB API
/// 3. Recibe JSON
/// 4. Convierte JSON → MovieDbResponse → Movie (entidad limpia)
/// 5. Retorna lista de películas
///
/// Usa Dio para hacer peticiones HTTP.
/// API Base: https://api.themoviedb.org/3

import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

/// Implementación real de MoviesDatasource
/// Obtiene datos de The Movie Database API
class MoviedbDatasource extends MoviesDatasource {
  
  /// Cliente HTTP con configuración global
  /// BaseOptions:
  /// - baseUrl: URL base de la API
  /// - api_key: Incluido en TODOS los requests
  /// - language: Respuestas en español (es-ES)
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-ES'
    }
  ));
  
  /// Método privado: Convierte JSON de API → Lista de entidades Movie
  /// 1. MovieDbResponse.fromJson() parsea el JSON
  /// 2. Filtra películas sin póster
  /// 3. MovieMapper convierte cada MovieDb → Movie limpio
  List<Movie> _jsonToMovies( Map<String,dynamic> json ) {
    final movieDBResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' )
    .map(
      (moviedb) => MovieMapper.movieDBToEntity(moviedb)
    ).toList();

    return movies;
  }

  /// Implementación: Películas en cartelera
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {
        'page': page
      }
    );
    return _jsonToMovies(response.data);
  }
  
  /// Implementación: Películas populares
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