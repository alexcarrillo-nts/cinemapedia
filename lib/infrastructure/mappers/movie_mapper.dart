import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

/// ================================================================================
/// MAPPER: CONVERSOR DE DATOS (INFRASTRUCTURE LAYER)
/// ================================================================================
/// 
/// Un mapper es una clase que CONVIERTE datos de un formato a otro.
/// En este caso: de modelos JSON (de API) a entidades de dominio.
/// 
/// ¿POR QUÉ?
/// - El API retorna datos en cierto formato
/// - La app necesita datos en otro formato
/// - El mapper hace la conversión de forma centralizada
/// 
/// VENTAJAS:
/// - Código limpio y reutilizable
/// - Fácil cambiar la lógica de conversión
/// - Las entidades no dependen del API
/// 
class MovieMapper {
  
  /// Convierte MovieMovieDB (del API, lista simplificada) a Movie (entidad)
  /// Aquí se:
  /// - Añaden URLs completas a imágenes
  /// - Convierten tipos de datos si es necesario
  /// - Manejan valores null
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      // Si hay backdropPath, forma URL completa. Si no, usa placeholder
      backdropPath: (moviedb.backdropPath != '') 
        ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }'
        : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }'
        : 'https://www.movienewz.com/img/films/poster-holder.jpg',
      releaseDate: moviedb.releaseDate != null ? moviedb.releaseDate! : DateTime.now(),
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount
    );

    /// Convierte MovieDetails (del API, con detalles completos) a Movie
    /// Diferencia: Los géneros vienen como objetos, no como IDs
    static Movie movieDetailsToEntity( MovieDetails moviedb ) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '') 
        ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }'
        : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
      // Aquí los géneros vienen como objetos, extraemos el nombre
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
