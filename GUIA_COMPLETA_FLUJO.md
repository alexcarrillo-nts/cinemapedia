# GUÍA COMPLETA: Flujo de la app Cinemapedia

Resumen rápido
- Propósito: Documentar el flujo completo (inicio → navegación → obtención de datos → presentación) y la responsabilidad de cada módulo.

Estructura general
- `lib/main.dart`: Entrada; inicializa `dotenv`, `ProviderScope` y configura `MaterialApp.router` con `appRouter`.
- `lib/config/router/app_router.dart`: Rutas con `GoRouter` (home, movie/:id, person/:id, etc.).
- `lib/config/theme/app_theme.dart`: Tema global de la app.

Capas y responsabilidades
- Domain (lib/domain): Entidades (`Movie`, `Actor`), contratos (`MoviesRepository`, `ActorsRepository`).
- Infrastructure (lib/infrastructure): Implementaciones concretas:
  - `datasources`: Llamadas HTTP (Dio) a TMDB.
  - `mappers`: Convierte JSON → Entity.
  - `repositories`: Implementan los contratos del dominio usando datasources + mappers.
- Presentation (lib/presentation): UI, providers (Riverpod), screens y widgets.

Flujo de llamada (ejemplo: listar películas populares)
1. UI: `HomeView` / `HomeScreen` muestra un `ConsumerWidget` o `StateNotifierProvider` que escucha `popularMoviesProvider`.
2. Provider: `popularMoviesProvider` crea un `MoviesNotifier` con el callback `movieRepository.getPopular`.
3. Notifier: `MoviesNotifier.loadNextPage()` llama al callback con `page`.
4. Repository: `MovieRepositoryImpl.getPopular(page)` llama al `MovieDbDataSource`.
5. Datasource: realiza petición HTTP con Dio a TMDB y retorna JSON.
6. Mapper: `MovieMapper` convierte el JSON en `List<Movie>`.
7. Repository retorna los `Movie` al notifier.
8. Notifier actualiza `state` (lista acumulada); Riverpod notifica a la UI.

Navegación (GoRouter)
- Rutas principales: `/` o `/home/:page` -> `HomeScreen`, `/movie/:id` -> `MovieScreen`.
- Uso: al tocar una tarjeta se llama `context.push('/movie/${movie.id}')` (o similar) y el detalle carga providers específicos (`movieInfoProvider`, `actorsByMovieProvider`).

Paginación y caching breve
- `MoviesNotifier` mantiene `currentPage` e `isLoading` para evitar peticiones simultáneas.
- El estado es `List<Movie>` y se acumula con `state = [...state, ...movies]`.

Errores y debugging comunes
- Errores de compilación típicos: caracteres erróneos, paréntesis sobrantes en `app_router.dart`, `typedef` mal formados en providers.
- Errores en tiempo de ejecución: claves de API (dotenv), respuestas de TMDB inesperadas (mapear campos nulos).

Dónde empezar a leer el código
- Inicio: `lib/main.dart`
- Rutas: `lib/config/router/app_router.dart`
- Repositorios: `lib/domain/repositories` y `lib/infrastructure/repositories`
- Providers: `lib/presentation/providers`

Notas finales
- Mantener la separación de capas facilita pruebas y cambios (p.ej. cambiar HTTP client o API).
- Si quieres, puedo añadir un diagrama de flujo o referencias línea a línea en otra guía.
