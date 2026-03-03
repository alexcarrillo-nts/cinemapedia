import 'package:cinemapedia/domain/entities/actor.dart';

/// ================================================================================
/// REPOSITORIO ABSTRACTO: ACTORES (DOMAIN LAYER)
/// ================================================================================
/// 
/// Contrato que define las operaciones disponibles para actores.
/// 
/// Una implementación debe proporcionar un método que obtenga
/// los actores de una película específica.
/// 
/// Ver implementación en: lib/infrastructure/repositories/actor_repository_impl.dart
/// 
abstract class ActorsRepository {

  /// Obtiene la lista de actores que participan en una película.
  /// Parámetro movieId: El ID único de la película en TMDB
  Future<List<Actor>> getActorsByMovie( String movieId );

}