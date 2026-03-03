
/// ================================================================================
/// ENTIDAD: ACTOR (DOMAIN LAYER)
/// ================================================================================
/// 
/// Entidad que representa a un actor/actriz en una película.
/// Similar a Movie, es un objeto puro sin lógica.
/// 
/// Campos:
/// - id: Identificador único en TMDB
/// - name: Nombre del actor
/// - profilePath: URL (relativa) de la foto del actor
/// - character: Nombre del personaje que interpreta (puede ser null)
///   Es nullable (?) porque un crew member podría no tener personaje
/// 
class Actor {

  final int id;
  final String name;
  final String profilePath;
  final String? character;

  /// Constructor que requiere datos básicos del actor.
  /// El 'character' es nullable si el rol no está definido.
  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character
  });
}