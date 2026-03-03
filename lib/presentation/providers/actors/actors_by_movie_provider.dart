import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ================================================================================
/// PROVIDER: CACHÉ DE ACTORES POR PELÍCULA
/// ================================================================================
/// 
/// Este StateNotifierProvider mantiene un caché de listas de actores
/// indexadas por película para optimizar peticiones HTTP.
/// 
/// RESPONSABILIDAD:
/// - Almacenar actores de cada película (Map<movieId, List<Actor>>)
/// - Evitar cargar actores de la misma película dos veces
/// - Servir datos rápidamente sin nuevo HTTP
/// 
/// ESTRUCTURA DEL ESTADO:
/// ```
/// {
///   '505642': <Actor>[Actor(name: 'Zoe Saldana'), ...],
///   '505643': <Actor>[Actor(name: 'Timothee Chalamet'), ...],
///   '505645': <Actor>[Actor(name: 'Cillian Murphy'), ...],
///   '501231': <Actor>[Actor(name: 'Margot Robbie'), ...],
/// }
/// ```
/// 
/// FLUJO:
/// 1. MovieScreen es visible (ej: película 505642)
/// 2. Llama loadActors('505642')
/// 3. Si ya existe en caché, devuelve sin HTTP (rápido)
/// 4. Si no existe, llama actorsRepository.getActorsByMovie()
/// 5. Recibe List<Actor> del API
/// 6. Guarda en el Map bajo la clave '505642'
/// 7. Widget ActorsHorizontalListview actualiza con actores
/// 
final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final actorsRepository = ref.watch( actorsRepositoryProvider );
  
  return ActorsByMovieNotifier( getActors: actorsRepository.getActorsByMovie );
});


/*
  {
    '505642': <Actor>[],
    '505643': <Actor>[],
    '505645': <Actor>[],
    '501231': <Actor>[],
  }
*/

typedef GetActorsCallback = Future<List<Actor>>Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String,List<Actor>>> {

  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors,
  }): super({});


  Future<void> loadActors( String movieId ) async {
    if ( state[movieId] != null ) return;

    final List<Actor> actors = await getActors( movieId );
    state = { ...state, movieId: actors };
  }

}