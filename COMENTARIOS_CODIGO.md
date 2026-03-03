# COMENTARIOS DEL CÓDIGO - REFERENCIA RÁPIDA

Este archivo contiene los comentarios explicativos para los archivos que aún no tienen comentarios integrados.

---

## PROVIDERS (Estado Management)

### lib/presentation/providers/movies/initial_loading_provider.dart

```dart
/// PROVIDER: Estado de carga inicial
/// 
/// Computa si todavia estamos cargando datos.
/// Retorna true si CUALQUIERA de las 4 listas principales esta vacia.
/// Retorna false cuando TODAS las listas tienen datos.
/// 
/// USO en HomeView:
/// - Si es true: muestra FullScreenLoader (spinner)
/// - Si es false: muestra contenido de peliculas
```

### lib/presentation/providers/movies/movie_info_provider.dart

```dart
/// PROVIDER: Informacion de pelicula individual
/// 
/// Estado: Map<String, Movie>
/// - Clave: ID de pelicula (ej: '505642')
/// - Valor: Objeto Movie completo con detalles
/// 
/// CARACTERISTICA PRINCIPAL: Cache automatico
/// Si ya cargaste una pelicula, no la vuelve a cargar.
/// 
/// METODO loadMovie(movieId):
/// 1. Verifica si el ID ya esta en el Map
/// 2. Si NO esta: obtiene del repositorio
/// 3. Anade al Map usando spread operator
/// 4. Riverpod notifica cambios
```

### lib/presentation/providers/movies/movies_slideshow_provider.dart

```dart
/// PROVIDER: Peliculas para el carrusel
/// 
/// Toma las primeras N peliculas de nowPlayingMoviesProvider
/// y las prepara especificamente para el MoviesSlideshow widget.
/// 
/// Es un ejemplo de "computed provider" - derivado de otro provider.
```

### lib/presentation/providers/actors/actors_by_movie_provider.dart

```dart
/// PROVIDER: Actores por pelicula
/// 
/// Estado: Map<String, List<Actor>>
/// - Clave: ID de pelicula
/// - Valor: Lista de actores de esa pelicula
/// 
/// Mismo patron que movieInfoProvider pero para actores.
/// Cache automatico: una vez cargados, no se vuelven a cargar.
```

---

## SCREENS (Pantallas Principales)

### lib/presentation/screens/movies/home_screen.dart

```dart
/// PANTALLA: Home Screen
/// 
/// Es el contenedor principal de la app.
/// 
/// ESTRUCTURA:
/// - Scaffold con body + bottomNavigationBar
/// - IndexedStack en el body para cambiar entre vistas
/// - CustomBottomNavigation en la barra inferior
/// 
/// VISTAS (viewRoutes):
/// - Indice 0: HomeView (home principal)
/// - Indice 1: SizedBox vacio (placeholder para categorias)
/// - Indice 2: FavoritesView (peliculas favoritas)
/// 
/// El pageIndex viene de la ruta /home/:page
```

### lib/presentation/screens/movies/movie_screen.dart

```dart
/// PANTALLA: Movie Screen (Detalles de Pelicula)
/// 
/// Se muestra cuando el usuario toca una pelicula.
/// 
/// PARAMETROS:
/// - movieId: ID de la pelicula (viene de la ruta)
/// 
/// EN INITSTATE:
/// 1. Carga movieInfoProvider para obtener detalles
/// 2. Carga actorsByMovieProvider para obtener elenco
/// 
/// EN BUILD:
/// - Si movie es null: muestra CircularProgressIndicator
/// - Si cargo: muestra CustomScrollView con detalles
///   - Imagen grande (backdrop)
///   - Titulo, descripcion, generos
///   - Rating y votos
///   - Lista de actores
```

---

## VISTAS (Views - Partes de Screens)

### lib/presentation/views/movies/home_view.dart

```dart
/// VISTA: Home View
/// 
/// TIPO: ConsumerStatefulWidget (accede a Riverpod)
/// PADRES: HomeScreen (via IndexedStack)
/// 
/// RESPONSABILIDADES:
/// 1. Cargar datos iniciales (en initState)
/// 2. Observar estado de carga (initialLoadingProvider)
/// 3. Renderizar carrusel + listas de peliculas
/// 
/// FLUJO:
/// initState():
/// - ref.read(...notifier).loadNextPage() x 4
/// - Carga pagina 1 de cada categoria
/// 
/// build():
/// - Observa initialLoadingProvider
///   - Si true: retorna FullScreenLoader
///   - Si false: renderiza CustomScrollView
/// - CustomScrollView contiene:
///   - SliverAppBar (barra flotante)
///   - SliverList con:
///     - MoviesSlideshow (carrusel)
///     - MovieHorizontalListview x 4 (listas)
/// 
/// IMPORTANTE:
/// - .read() en initState() → obtiene valor UNA VEZ
/// - .watch() en build() → observable, redibujas si cambia
```

### lib/presentation/views/movies/favorites_view.dart

```dart
/// VISTA: Favorites View
/// 
/// TIPO: Consumer widget (accede a providers Riverpod)
/// PADRES: HomeScreen (via IndexedStack)
/// 
/// Muestra peliculas que el usuario marque como favoritas.
/// (Implementacion basica en esta app)
```

---

## WIDGETS (Componentes Reutilizables)

### lib/presentation/widgets/movies/movies_slideshow.dart

```dart
/// WIDGET: Movies Slideshow
/// 
/// Carrusel giratorio de peliculas.
/// 
/// CARACTERISTICAS:
/// - PageView para comportamiento de carrusel
/// - Muestra imagenes grandes (backdrop)
/// - Se puede deslizar manualmente
/// - Gira automaticamente cada X segundos
/// - Muestra indicadores de pagina (dots)
/// 
/// ENTRADA: List<Movie>
```

### lib/presentation/widgets/movies/movie_horizontal_listview.dart

```dart
/// WIDGET: Movie Horizontal Listview
/// 
/// Lista horizontal deslizable de peliculas.
/// 
/// CARACTERISTICAS:
/// - ListView.builder con scrollDirection: Axis.horizontal
/// - ScrollController detecta cuando scrolleaste al final
/// - Llama onNextPage() cuando llegas al final
/// - Paginacion automatica (carga mas cuando scrolleas)
/// 
/// ENTRADA:
/// - movies: List<Movie> a mostrar
/// - title: Titulo de la lista
/// - onNextPage: Callback para cargar siguiente pagina
```

### lib/presentation/widgets/shared/custom_appbar.dart

```dart
/// WIDGET: Custom AppBar
/// 
/// Barra superior personalizada.
/// 
/// CONTENIDO:
/// - Logo de la aplicacion
/// - Campo de busqueda (SearchMovieDelegate)
/// - Boton de menu (opcional)
```

### lib/presentation/widgets/shared/custom_bottom_navigation.dart

```dart
/// WIDGET: Custom Bottom Navigation
/// 
/// Barra inferior con 3 tabs.
/// 
/// TABS:
/// - Home (indice 0)
/// - Categorias (indice 1)
/// - Favoritos (indice 2)
/// 
/// AL TOCAR:
/// - Navega mediante GoRouter a /home/{novoIndice}
/// - HomeScreen recibe el parametro y cambia de vista
```

### lib/presentation/widgets/shared/full_screen_loader.dart

```dart
/// WIDGET: Full Screen Loader
/// 
/// Pantalla completa con spinner de carga.
/// 
/// USO:
/// - HomeView lo muestra mientras initialLoadingProvider es true
/// - MovieScreen lo muestra mientras carga detalles
```

### lib/presentation/delegates/search_movie_delegate.dart

```dart
/// DELEGADO: Search Movie Delegate
/// 
/// Implementa la busqueda de peliculas.
/// 
/// CARACTERISTICAS:
/// - Busqueda en tiempo real (mientras escribes)
/// - Suggerencias (peliculas encontradas)
/// - Historial de busquedas (opcional)
/// - Resultados en ListView
```

---

## MODELOS JSON (Deserializacion)

### lib/infrastructure/models/moviedb/

```dart
/// ARCHIVOS:
/// - moviedb_response.dart: Respuesta JSON de lista de peliculas
/// - movie_moviedb.dart: Estructura de una pelicula (lista)
/// - movie_details.dart: Estructura con detalles completos
/// - credits_response.dart: Respuesta JSON de actores/crew
/// - cast.dart: Estructura de un actor
/// - genre.dart: Estructura de un genero
/// 
/// PROPOSITO:
/// Estos modelos representan EXACTAMENTE la estructura JSON
/// que retorna TMDB API.
/// 
/// El paquete json_serializable puede generar:
/// - fromJson() constructor
/// - toJson() metodo
/// 
/// FLUJO:
/// JSON (String) → json.decode() → Map → fromJson() → Modelo
```

---

## DATASOURCES (Fuentes de Datos)

### lib/infrastructure/datasources/moviedb_datasource.dart

```dart
/// DATASOURCE: The Movie DB Datasource
/// 
/// RESPONSABILIDADES:
/// 1. Configurar Dio con baseUrl + parametros globales
/// 2. Hacer llamadas HTTP a TMDB API
/// 3. Deserializar JSON a MovieDbResponse
/// 4. Filtrar peliculas sin poster
/// 5. Mapear a entidades Movie
/// 
/// CONFIGURACION DIO:
/// - baseUrl: https://api.themoviedb.org/3
/// - queryParameters globales: api_key, language
/// 
/// ENDPOINTS:
/// - /movie/now_playing
/// - /movie/popular
/// - /movie/top_rated
/// - /movie/upcoming
/// - /movie/{id}
/// - /search/movie?query=...
/// 
/// METODO PRIVADO _jsonToMovies():
/// - Deserializa JSON
/// - Filtra peliculas sin poster
/// - Mapea cada una a Movie
/// - Retorna List<Movie>
```

### lib/infrastructure/datasources/actor_moviedb_datasource.dart

```dart
/// DATASOURCE: Actor The Movie DB Datasource
/// 
/// RESPONSABILIDADES:
/// 1. Hacer llamadas HTTP a /movie/{id}/credits
/// 2. Deserializar JSON a CreditsResponse
/// 3. Mapear cada Cast a entidad Actor
/// 
/// ENDPOINT:
/// - /movie/{movieId}/credits
/// 
/// RESULTADO:
/// - List<Actor> (solo los que tienen personaje)
```

---

## MAPPERS (Conversores de Datos)

### lib/infrastructure/mappers/movie_mapper.dart

```dart
/// MAPPER: Movie Mapper
/// 
/// RESPONSABILIDAD:
/// Convertir modelos JSON (MovieMovieDB, MovieDetails)
/// a entidades de dominio (Movie)
/// 
/// TRANSFORMACIONES:
/// 1. Construir URLs completas para imagenes
///    - backdropPath: '' + 'https://image.tmdb.org/t/p/w500' + path
///    - posterPath: '' + 'https://image.tmdb.org/t/p/w500' + path
/// 2. Usar placeholders si faltan imagenes
/// 3. Convertir genreIds a nombres (en details)
/// 4. Manejar dates nullables
/// 
/// METODOS:
/// - movieDBToEntity(): JSON simplificado → Movie
/// - movieDetailsToEntity(): JSON detallado → Movie
```

### lib/infrastructure/mappers/actor_mapper.dart

```dart
/// MAPPER: Actor Mapper
/// 
/// RESPONSABILIDAD:
/// Convertir modelos JSON (Cast) a entidades Actor
/// 
/// TRANSFORMACIONES:
/// - Construir URL completa para imagen de perfil
/// - Manejar characters nullable
```

---

## REPOSITORIES (Implementaciones)

### lib/infrastructure/repositories/movie_repository_impl.dart

```dart
/// REPOSITORIO: Movie Repository Implementation
/// 
/// PATRON: Adapter / Delegador
/// 
/// IMPLEMENTA:
/// - MoviesRepository (interfaz del domain)
/// 
/// RECIBE (inyeccion):
/// - MoviesDatasource (donde obtener datos)
/// 
/// RESPONSABILIDAD:
/// - Solo delegar llamadas al datasource
/// - Sin logica de negocio compleja
/// 
/// VENTAJA:
/// - Si cambias de API, cambias solo el datasource
/// - El resto de la app no se entera
/// - Tests: puedes inyectar un mock datasource
```

### lib/infrastructure/repositories/actor_repository_impl.dart

```dart
/// REPOSITORIO: Actor Repository Implementation
/// 
/// Mismo patron que MovieRepositoryImpl
/// pero para actores.
```

---

## CONFIGURACION

### lib/config/constants/environment.dart

```dart
/// VARIABLES DE ENTORNO
/// 
/// Lee valores desde archivo .env
/// usando el paquete flutter_dotenv
/// 
/// RAZONES:
/// 1. No expones API keys en codigo fuente
/// 2. Diferentes valores para dev/prod
/// 3. Variables secretas no se suben a Git
/// 
/// USO:
/// Environment.theMovieDbKey // retorna valor del .env
```

### lib/config/router/app_router.dart

```dart
/// ROUTER: GoRouter
/// 
/// Sistema de navegacion basado en rutas (como web)
/// 
/// VENTAJAS sobre Navigator tradicional:
/// - URLs predictibles
/// - Deep linking (enlaces directos a pantallas)
/// - Navegacion mas clara
/// - Compatible con web
/// 
/// RUTAS:
/// - /home/:page → HomeScreen
/// - /home/:page/movie/:id → MovieScreen
/// - / → redirige a /home/0
```

### lib/config/theme/app_theme.dart

```dart
/// TEMA: App Theme Configuration
/// 
/// RESPONSABILIDAD:
/// Configurar como se ve toda la aplicacion
/// 
/// USANDO:
/// - Material Design 3 (colorSchemeSeed crea paleta automaticamente)
/// - Color base: Azul #2862F5
/// 
/// Configuran automaticamente:
/// - Primary color
/// - Secondary color
/// - Surface colors
/// - Text colors
/// - Component shapes
```

---

## PUNTO DE ENTRADA

### lib/main.dart

```dart
/// PUNTO DE ENTRADA: main()
/// 
/// EJECUCION:
/// 1. dotenv.load() - carga variables de .env
/// 2. ProviderScope() - activa Riverpod
/// 3. MainApp - configura app
/// 
/// FLUJO:
/// main() → dotenv → ProviderScope → MainApp → MaterialApp.router → GoRouter
```

---

## MAPAS MENTALES IMPORTANTES

### Flujo de Carga de Datos

```
Pantalla (HomeView)
    ↓ .read(...notifier).loadNextPage()
MoviesNotifier
    ↓ await fetchMoreMovies(page: currentPage)
MovieRepositoryImpl
    ↓ datasource.getNowPlaying(page)
MoviedbDatasource
    ↓ dio.get('/movie/now_playing')
TMDB API
    ↓ retorna JSON
MoviedbDatasource
    ↓ MovieDbResponse.fromJson()
Deserializacion JSON
    ↓ .where().map(MovieMapper)
MovieMapper
    ↓ Movie entities
MoviesNotifier
    ↓ state = [...state, ...movies]
Riverpod
    ↓ notifica cambios
HomeView
    ↓ .watch() triggers rebuild
CustomScrollView + Widgets
    ↓ Renderiza peliculas
Usuario ve pantalla
```

### Componentes Redux / Estado

```
USER ACTION (tap, scroll, etc)
    ↓
WIDGET calls notifier method
    ↓
NOTIFIER executes logic
    ↓
STATE updates
    ↓
RIVERPOD notifies listeners
    ↓
WIDGETS rebuild via .watch()
    ↓
UI updates
```

---

Estos comentarios complementan la GUIA_FLUJO_CON_REFERENCIAS.md.
Combina ambos documentos para una comprension completa de la arquitectura.
