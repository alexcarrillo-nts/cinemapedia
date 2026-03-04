/// 🔄 TRANSFORMADOR DE DATOS - movie_mapper.dart
///
/// Convierte los datos crudos de la API (MovieMovieDB) a nuestras entidades limpias (Movie).
/// Usa el patrón MAPPER para mantener las capas desacopladas.
///
/// TRANSFORMACIONES:
/// 1. Agrega URLs completas a las imágenes
/// 2. Maneja campos vacíos con valores por defecto
/// 3. Convierte géneros de IDs a nombres
/// 4. Convierte fechas y tipos de datos
///
/// ¿POR QUÉ MAPPERS?
/// - El JSON de API tiene campos innecesarios
/// - Las imágenes vienen sin dominio
/// - Algunos datos están en formatos diferentes
/// - El Mapper "limpia" todo para la UI

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

/// Clase con métodos estáticos para convertir MovieDB -> Movie
class MovieMapper {
  
  /// Convierte MovieMovieDB (listados) -> Movie
  /// Se usa en listados de películas de la API
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      
      /// Genera URL completa de imagen o usa poster por defecto
      backdropPath: (moviedb.backdropPath != '') 
        ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }'
        : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
      
      /// Convierte IDs numéricos a Strings
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      
      /// Genera URL completa del póster
      posterPath: (moviedb.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }'
        : 'https://www.movienewz.com/img/films/poster-holder.jpg',
      
      /// Maneja fechas nulas
      releaseDate: moviedb.releaseDate != null ? moviedb.releaseDate! : DateTime.now(),
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount
    );

    /// Convierte MovieDetails (detalles) -> Movie
    /// Se usa cuando pides detalles completos de una película
    static Movie movieDetailsToEntity( MovieDetails moviedb ) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '') 
        ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }'
        : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
      
      /// En detalles, los géneros vienen como objetos con nombre
      genreIds: moviedb.genres.map((e) => e.name ).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }'
        : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount
    );

}
