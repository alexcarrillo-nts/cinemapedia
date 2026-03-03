# GUÍA: Flujo con referencias al código

Propósito
- Ofrecer un recorrido rápido con enlaces a los archivos clave para navegar por el código.

Archivos clave
- Inicio de la app: [lib/main.dart](lib/main.dart)
- Rutas (GoRouter): [lib/config/router/app_router.dart](lib/config/router/app_router.dart)
- Tema: [lib/config/theme/app_theme.dart](lib/config/theme/app_theme.dart)

Capas
- Entidades y contratos: [lib/domain](lib/domain)
- Datasources (HTTP): [lib/infrastructure/datasources](lib/infrastructure/datasources)
- Mappers: [lib/infrastructure/mappers](lib/infrastructure/mappers)
- Repositories: [lib/infrastructure/repositories](lib/infrastructure/repositories)
- Providers (estado): [lib/presentation/providers](lib/presentation/providers)
- Vistas y pantallas: [lib/presentation/screens](lib/presentation/screens) y [lib/presentation/views](lib/presentation/views)

Puntos de interés (lectura recomendada)
- Estado y paginación: `MoviesNotifier` en [lib/presentation/providers/movies/movies_providers.dart](lib/presentation/providers/movies/movies_providers.dart)
- Peticiones a TMDB y mapeo: `MovieDbDataSource` y `MovieMapper` en `lib/infrastructure`.
- Detalle de una película: `MovieScreen` y `movie_info_provider`.

Sugerencia de recorrido (orden de lectura)
1. `lib/main.dart`
2. `lib/config/router/app_router.dart`
3. `lib/presentation/screens/home_screen.dart`
4. `lib/presentation/providers/movies/movies_providers.dart`
5. `lib/infrastructure/datasources/moviedb_datasource.dart`
6. `lib/infrastructure/mappers/movie_mapper.dart`
7. `lib/infrastructure/repositories/movie_repository_impl.dart`

Si quieres, puedo añadir enlaces directos a líneas concretas del archivo (p. ej. el constructor de `MoviesNotifier`) — dime si los quieres.
