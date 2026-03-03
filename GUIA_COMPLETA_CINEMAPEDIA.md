# 📚 GUÍA COMPLETA DE CINEMAPEDIA - Flujo de la App

Una guía paso a paso para entender cómo funciona una aplicación Flutter moderna con arquitectura en capas, gestión de estado con Riverpod y consumo de APIs externas.

---

## 🎯 Índice

1. [Visión General](#visión-general)
2. [Estructura del Proyecto](#estructura-del-proyecto)
3. [Arquitectura en Capas](#arquitectura-en-capas)
4. [Flujo de Datos](#flujo-de-datos)
5. [Explicación de Componentes](#explicación-de-componentes)
6. [Flujo Detallado de Ejecución](#flujo-detallado-de-ejecución)

---

## 🔍 Visión General

### ¿Qué es Cinemapedia?

**Cinemapedia** es una aplicación móvil de películas que:
- Muestra películas en diferentes categorías (En cines, Próximas, Populares, Mejor valoradas)
- Permite ver detalles completos de cada película
- Muestra los actores de cada película
- Consume datos de la API pública de **The Movie Database (TMDb)**

### Tecnologías principales

- **Framework**: Flutter (UI multiplataforma)
- **Gestión de Estado**: Riverpod (Proveedores reactivos)
- **Enrutamiento**: Go Router (Navegación entre pantallas)
- **HTTP**: Dio (Cliente HTTP)
- **Tema**: Material 3
- **Variables de entorno**: flutter_dotenv

---

## 📁 Estructura del Proyecto

```
cinemapedia/
├── lib/
│   ├── main.dart                          # Punto de entrada de la app
│   ├── config/                            # Configuración de la app
│   │   ├── constants/
│   │   │   └── environment.dart          # Variables de entorno (API keys)
│   │   ├── helpers/
│   │   │   └── human_formats.dart        # Funciones de formato (fechas, números)
│   │   ├── router/
│   │   │   └── app_router.dart           # Definición de rutas
│   │   └── theme/
│   │       └── app_theme.dart            # Tema visual de la app
│   │
│   ├── domain/                            # LÓGICA DE NEGOCIO (Independiente de cómo obtenemos datos)
│   │   ├── entities/                      # Modelos de datos puros
│   │   │   ├── movie.dart                # Entidad Película
│   │   │   └── actor.dart                # Entidad Actor
│   │   ├── datasources/                   # Contratos (interfaces) de donde vienen los datos
│   │   │   ├── movies_datasource.dart    # ¿Cómo obtenemos películas?
│   │   │   └── actors_datasource.dart    # ¿Cómo obtenemos actores?
│   │   └── repositories/                  # Contratos de lógica
│   │       ├── movies_repository.dart    # ¿Qué operaciones hay sobre películas?
│   │       └── actors_repository.dart    # ¿Qué operaciones hay sobre actores?
│   │
│   ├── infrastructure/                    # IMPLEMENTACIÓN (Cómo realmente obtenemos y procesamos datos)
│   │   ├── datasources/                   # Implementación real de datasources
│   │   │   ├── moviedb_datasource.dart   # Obtiene películas de TMDb API
│   │   │   └── actor_moviedb_datasource.dart # Obtiene actores de TMDb API
│   │   ├── models/                        # Modelos que conforman los datos crudos de la API
│   │   │   └── moviedb/
│   │   │       ├── moviedb_response.dart
│   │   │       ├── movie_moviedb.dart    # Cómo llega una película desde la API
│   │   │       ├── movie_details.dart
│   │   │       └── credits_response.dart # Cómo llegan los actores desde la API
│   │   ├── mappers/                       # Conversores de modelos
│   │   │   ├── movie_mapper.dart         # MovieDB model → Movie entity
│   │   │   └── actor_mapper.dart         # Cast model → Actor entity
│   │   └── repositories/                  # Implementación de los contratos del domain
│   │       ├── movie_repository_impl.dart
│   │       └── actor_repository_impl.dart
│   │
│   └── presentation/                      # INTERFAZ DE USUARIO
│       ├── screens/                       # Pantallas completas
│       │   └── movies/
│       │       ├── home_screen.dart       # Pantalla principal con navegación
│       │       └── movie_screen.dart      # Detalle de una película
│       ├── views/                         # Secciones dentro de pantallas
│       │   └── movies/
│       │       ├── home_view.dart         # Vista principal de películas
│       │       └── favorites_view.dart    # Vista de favoritas
│       ├── widgets/                       # Componentes reutilizables
│       │   ├── movies/
│       │   │   ├── movies_slideshow.dart
│       │   │   └── movie_horizontal_listview.dart
│       │   └── shared/
│       │       ├── custom_appbar.dart
│       │       ├── custom_bottom_navigation.dart
│       │       └── full_screen_loader.dart
│       ├── providers/                     # Gestión de estado (Riverpod)
│       │   ├── movies/
│       │   │   ├── movies_repository_provider.dart
│       │   │   ├── movies_providers.dart
│       │   │   ├── initial_loading_provider.dart
│       │   │   ├── movies_slideshow_provider.dart
│       │   │   └── movie_info_provider.dart
│       │   ├── actors/
│       │   │   ├── actors_repository_provider.dart
│       │   │   └── actors_by_movie_provider.dart
│       │   └── search/
│       └── delegates/
│
├── .env                                   # Variables de entorno (NO en GIT)
├── android/                               # Código específico para Android
├── ios/                                   # Código específico para iOS
├── web/                                   # Código específico para Web
├── windows/                               # Código específico para Windows
├── macos/                                 # Código específico para macOS
├── pubspec.yaml                           # Dependencias del proyecto
└── README.md
```

---

## 🏗️ Arquitectura en Capas

Esta app usa **Clean Architecture** = 3 capas independientes

```
┌─────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                  │
│              (Interfaz de Usuario - Flutter)            │
│  Screens → Views → Widgets → Providers (Estado)        │
└──────────────────────┬──────────────────────────────────┘
                       │ Los widgets piden datos
                       │ a los Providers
                       ↓
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                        │
│                  (Lógica de Negocio)                    │
│  - Entities (Modelos puros de datos)                    │
│  - Repositories (¿Qué operaciones puedo hacer?)        │
│  - Datasources (¿De dónde vienen los datos?)           │
│  ⚠️ NO SABE cómo se obtienen los datos                 │
└──────────────────────┬──────────────────────────────────┘
                       │ Los Repositories usan
                       │ Datasources
                       ↓
┌─────────────────────────────────────────────────────────┐
│              INFRASTRUCTURE LAYER                        │
│        (Implementación - Cómo obtenemos datos)          │
│  - Datasources Implementation (Llama a APIs)            │
│  - Models (Cómo llegan los datos sin procesar)         │
│  - Repositories Implementation (Usa datasources)        │
│  - Mappers (Convierte API response → Entity)           │
└─────────────────────┬───────────────────────────────────┘
                      │ Las APIs devuelven JSON
                      │
                      ↓
            ┌──────────────────┐
            │  The Movie DB     │
            │      API          │
            └──────────────────┘
```

### ¿Por qué 3 capas?

1. **Domain**: Lógica pura del negocio (QUÉ hacer)
2. **Infrastructure**: Cómo conseguir los datos (CÓMO hacerlo)
3. **Presentation**: Mostrar datos al usuario (INTERFACE)

**Ventaja**: Si cambiamos de API (de TMDb a OMDB), solo cambiamos Infrastructure, Domain y Presentation siguen igual.

---

## 🔄 Flujo de Datos

### Flujo simplificado: Usuario abre la app

```
1. main.dart carga
   ↓
2. dotenv.load() carga la API key del .env
   ↓
3. MainApp() inicia con Riverpod (ProviderScope)
   ↓
4. Go Router lee la ruta inicial → HomeScreen
   ↓
5. HomeScreen carga HomeView
   ↓
6. HomeView.initState() pide datos:
   - ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
   - ref.read(popularMoviesProvider.notifier).loadNextPage()
   - ref.read(topRatedMoviesProvider.notifier).loadNextPage()
   - ref.read(upcomingMoviesProvider.notifier).loadNextPage()
   ↓
7. Cada Provider (MoviesNotifier):
   a) Llama al Repositorio
   b) El Repositorio llama al DataSource
   c) DataSource hace petición HTTP a TMDb
   d) Llega JSON de la API
   ↓
8. El DataSource convierte JSON → MovieMovieDB (modelo crudo)
   ↓
9. El Mapper convierte MovieMovieDB → Movie (entidad limpia)
   ↓
10. El Provider recibe List<Movie> y actualiza el estado
    ↓
11. Los Widgets escuchan cambios en el Provider con ref.watch()
    ↓
12. Los Widgets se reconstruyen con los nuevos datos
    ↓
13. El usuario ve las películas en pantalla ✅
```

---

## 📚 Explicación de Componentes

### **CAPA 1: DOMAIN (Lo que queremos hacer)**

#### Entidades: `domain/entities/`

| Archivo | Qué es | Ejemplo |
|---------|--------|---------|
| **movie.dart** | Clase que representa una película | Título, descripción, fecha, rating |
| **actor.dart** | Clase que representa un actor | Nombre, foto, personaje |

**Características**:
- No tienen métodos complejos
- Solo contienen datos
- Son iguales en toda la app (no cambian)

```dart
// Ejemplo de Entity
class Movie {
  final int id;
  final String title;
  final String overview;
  final DateTime releaseDate;
  final double voteAverage;
  // ... más campos
}
```

#### Datasources: `domain/datasources/`

Contrato (interfaz abstracta) que dice "¿De dónde obtenemos los datos?"

```dart
// NO IMPLEMENTA, solo es un contrato
abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({ int page = 1 });
  Future<List<Movie>> getPopular({ int page = 1 });
  Future<List<Movie>> getUpcoming({ int page = 1 });
  Future<List<Movie>> getTopRated({ int page = 1 });
  Future<Movie> getMovieById( String id );
  Future<List<Movie>> searchMovies( String query );
}
```

#### Repositories: `domain/repositories/`

Contrato que dice "¿Qué operaciones puedo hacer con las películas?"

```dart
// Similar al DataSource, pero es el contrato que usa la app
abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({ int page = 1 });
  Future<List<Movie>> getPopular({ int page = 1 });
  // ... igual que DataSource
}
```

**¿Por qué dos contratos (Datasource + Repository)?**
- **Datasource**: Especifica cómo OBTENER datos de una FUENTE
- **Repository**: Especifica qué OPERACIONES puede hacer la app
  
Si necesitamos obtener películas de dos APIs, hacemos dos Datasources pero un solo Repository.

---

### **CAPA 2: INFRASTRUCTURE (Cómo obtenemos los datos)**

#### Models: `infrastructure/models/`

Cómo llegan los datos SIN PROCESAR de la API. Son casi iguales a las Entities pero con campos que quizá no necesitamos.

```dart
// Esto es lo que la API devuelve (crudo)
class MovieMovieDB {
  final String title;
  final String backdropPath;
  final DateTime? releaseDate;
  // ... campos adicionales
  
  // Factory para crear desde JSON
  factory MovieMovieDB.fromJson(Map<String, dynamic> json) => MovieMovieDB(
    title: json["title"] ?? 'No Title',
    backdropPath: json["backdrop_path"] ?? '',
    // ...
  );
}
```

#### DataSources Impl: `infrastructure/datasources/`

**Implementación real** del contrato del Domain. Aquí obtenemos datos de APIs.

```dart
// IMPLEMENTACIÓN real
class MoviedbDatasource extends MoviesDatasource {
  
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-ES'
    }
  ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {'page': page}
    );
    
    // JSON → MovieMovieDB → Movie
    return _jsonToMovies(response.data);
  }

  List<Movie> _jsonToMovies(Map<String,dynamic> json) {
    final movieDBResponse = MovieDbResponse.fromJson(json);
    
    return movieDBResponse.results
      .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
      .toList();
  }
}
```

**¿Qué pasa aquí?**
1. Usa `Dio` para hacer petición HTTP a la API
2. Recibe JSON de la respuesta
3. Convierte JSON → List<MovieMovieDB> (modelos crudos)
4. Usa Mapper para convertir MovieMovieDB → Movie (entidad limpia)
5. Devuelve List<Movie>

#### Mappers: `infrastructure/mappers/`

Convierte datos crudos de la API en entidades limpias de la app.

```dart
class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
    id: moviedb.id,
    title: moviedb.title,
    posterPath: (moviedb.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
      : 'https://placeholder.com/poster.jpg',
    // Arregla datos, añade URLs, etc
  );
}
```

#### Repositories Impl: `infrastructure/repositories/`

Implementación real del Repository del Domain.

```dart
class MovieRepositoryImpl extends MoviesRepository {
  
  final MoviesDatasource datasource;
  
  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }
}
```

**Es muy simple**: Solo delega al DataSource. ¿Para qué sirve entonces?
- Permite cambiar el DataSource sin afectar el resto
- En apps más complejas, pueden hacer lógica adicional (caché, lógica de negocio)

---

### **CAPA 3: PRESENTATION (La UI)**

#### Providers: `presentation/providers/`

**Riverpod** es un gestor de estado. Los Providers son como "variables reactivas" que notifican a los Widgets cuando cambian.

```dart
// Provider simple (inmutable, no cambia)
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviedbDatasource());
});

// StateNotifierProvider (puede cambiar)
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

// Map StateNotifier (para cachear múltiples películas)
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return MovieMapNotifier(getMovie: movieRepository.getMovieById);
});
```

**¿Cómo funcionan?**

1. **`ref.watch(provider)`** - El Widget "escucha" el provider. Si cambia, se reconstruye.
2. **`ref.read(provider.notifier)`** - Accede al Notifier para llamar métodos que cambien el estado.

```dart
// En un Widget ConsumerStatefulWidget
class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    
    // Pide al Provider que cargue datos
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    // Escucha cambios en el Provider
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    
    return ListView(
      children: nowPlayingMovies.map((movie) => MovieCard(movie)).toList()
    );
  }
}
```

#### State Notifiers

Son clases que manejan la lógica del estado.

```dart
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    
    isLoading = true;
    currentPage++;
    
    final moreMovies = await fetchMoreMovies(page: currentPage);
    
    state = [...state, ...moreMovies]; // Actualiza el estado
    
    isLoading = false;
  }
}
```

#### Screens: `presentation/screens/`

Pantallas completas (entera la pantalla).

```dart
class HomeScreen extends StatelessWidget {
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: [
          HomeView(),      // Películas
          SizedBox(),      // Categorías (vacío)
          FavoritesView(), // Favoritas
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex),
    );
  }
}
```

#### Views: `presentation/views/`

Secciones dentro de pantallas.

```dart
class HomeView extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context) {
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(...),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Column(
              children: [
                MoviesSlideshow(movies: slideShowMovies),
                MovieHorizontalListview(movies: nowPlayingMovies),
              ],
            ),
          ),
        )
      ],
    );
  }
}
```

#### Widgets: `presentation/widgets/`

Componentes reutilizables pequeños.

```dart
class MovieHorizontalListview extends StatelessWidget {
  final List<Movie> movies;
  final String title;
  final VoidCallback loadNextPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => MovieCard(movies[index]),
          ),
        ),
      ],
    );
  }
}
```

---

## 🎬 Flujo Detallado de Ejecución

### Escenario: Usuario abre la app y ve películas

#### Paso 1️⃣: Inicialización

```dart
// main.dart
Future<void> main() async {
  await dotenv.load(fileName: '.env');
  // Carga la API key desde .env
  
  runApp(
    const ProviderScope(child: MainApp())
  );
  // ProviderScope permite usar Riverpod en toda la app
}
```

**¿Qué sucede?**
- Lee el archivo `.env` que contiene `THE_MOVIEDB_KEY=xxx`
- Inicia Flutter con soporte para Riverpod
- Dibuja `MainApp()` que es el punto de entrada

#### Paso 2️⃣: Configuración de Material

```dart
// main.dart → MainApp
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // Rutas definidas en go_router
      theme: AppTheme().getTheme(), // Tema Material 3
    );
  }
}
```

**¿Qué sucede?**
- Configura el tema visual (colores, tipografía)
- Configura el enrutador (navegación entre pantallas)

#### Paso 3️⃣: Go Router navega a la ruta inicial

```dart
// config/router/app_router.dart
final appRouter = GoRouter(
  initialLocation: '/home/0', // Pantalla inicial
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.params['page'] ?? '0');
        return HomeScreen(pageIndex: pageIndex);
      },
    ),
  ],
);
```

**¿Qué sucede?**
- Navega a `/home/0` (HomeScreen con página 0)
- Crea `HomeScreen(pageIndex: 0)`

#### Paso 4️⃣: HomeScreen dibuja

```dart
// presentation/screens/movies/home_screen.dart
class HomeScreen extends StatelessWidget {
  final int pageIndex; // 0 = HomeView, 1 = Categorías, 2 = Favoritas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex, // 0
        children: [
          HomeView(),      // ← Se dibuja esta
          SizedBox(),
          FavoritesView(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex),
    );
  }
}
```

**¿Qué sucede?**
- `PageIndex=0` → Dibuja `HomeView`
- Añade una barra de navegación inferior

#### Paso 5️⃣: HomeView solicita datos

```dart
// presentation/views/movies/home_view.dart
class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    
    // ⚡ AQUÍ COMIENZAN LAS PETICIONES HTTP ⚡
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    // Escucha si hay cambios en los datos
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return FullScreenLoader(); // Mostrar cargando
    
    // Cuando terminan de cargar:
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    // ...
  }
}
```

**¿Qué sucede?**
1. Al montar el widget, pide datos (initState)
2. Mientras carga, muestra un loader
3. Escucha cambios en los Providers
4. Cuando llegan datos, reconstruye el widget

#### Paso 6️⃣: MoviesNotifier obtiene películas

```dart
// presentation/providers/movies/movies_providers.dart
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies; // Función que obtiene películas

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    
    isLoading = true;
    currentPage++;
    
    // fetchMoreMovies = movieRepository.getNowPlaying
    final List<Movie> moreMovies = await fetchMoreMovies(page: currentPage);
    
    // Actualiza el estado (notifica a los Widgets que escuchan)
    state = [...state, ...moreMovies];
    
    isLoading = false;
  }
}
```

**¿Qué sucede?**
1. Aumenta `currentPage` (página 1)
2. Llama a `movieRepository.getNowPlaying(page: 1)`
3. Espera la respuesta
4. Actualiza `state` con las nuevas películas

#### Paso 7️⃣: Repository delega al DataSource

```dart
// infrastructure/repositories/movie_repository_impl.dart
class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource;

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }
}
```

**¿Qué sucede?**
- Solo pasa la llamada al DataSource
- Es un intermediario

#### Paso 8️⃣: DataSource hace la petición HTTP

```dart
// infrastructure/datasources/moviedb_datasource.dart
class MoviedbDatasource extends MoviesDatasource {
  
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey, // Obtenido del .env
      'language': 'es-ES'
    }
  ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    // ⚡ PETICIÓN HTTP
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {'page': page}
    );
    // response.data = { "results": [{...}, {...}] }

    return _jsonToMovies(response.data);
  }

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    // JSON → MovieDbResponse
    final movieDBResponse = MovieDbResponse.fromJson(json);
    
    // MovieMovieDB → Movie (usando Mapper)
    final List<Movie> movies = movieDBResponse.results
      .where((moviedb) => moviedb.posterPath != 'no-poster')
      .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
      .toList();

    return movies;
  }
}
```

**¿Qué sucede?**
1. Usa `Dio` (cliente HTTP) para hacer GET a `/movie/now_playing`
2. Lleva la API key en los queryParameters
3. Recibe JSON de la API tipo:
```json
{
  "results": [
    {
      "title": "Avatar",
      "poster_path": "/abc123.jpg",
      "release_date": "2022-12-16",
      // ... más campos
    },
    // ... más películas
  ]
}
```

#### Paso 9️⃣: Mapper convierte los datos

```dart
// infrastructure/mappers/movie_mapper.dart
class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
    id: moviedb.id,
    title: moviedb.title,
    posterPath: (moviedb.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
      : 'https://placeholder.com/poster.jpg',
    backdropPath: (moviedb.backdropPath != '')
      ? 'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
      : 'https://placeholder.com/backdrop.jpg',
    releaseDate: moviedb.releaseDate ?? DateTime.now(),
    // Convierte todos los campos
  );
}
```

**¿Qué sucede?**
- Convierte `MovieMovieDB` (datos crudos) → `Movie` (entidad limpia)
- Arregla URLs (añade dominio)
- Maneja valores null (proporciona valores por defecto)

#### Paso 🔟: Los Widgets se reconstruyen

Ahora que hay datos en `nowPlayingMoviesProvider`:

```dart
// presentation/views/movies/home_view.dart
@override
Widget build(BuildContext context) {
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
  
  // nowPlayingMovies = [Movie(...), Movie(...), ...]
  
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Column(
            children: [
              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: 'En cines',
                loadNextPage: () => ref.read(
                  nowPlayingMoviesProvider.notifier
                ).loadNextPage(),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
```

**¿Qué sucede?**
1. `ref.watch(nowPlayingMoviesProvider)` devuelve la lista de películas
2. Crea un `MovieHorizontalListview` con esas películas
3. El Widget se dibuja con los datos reales

#### Paso 1️⃣1️⃣: MovieHorizontalListview dibuja cada película

```dart
// presentation/widgets/movies/movie_horizontal_listview.dart
class MovieHorizontalListview extends StatelessWidget {
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          
          return GestureDetector(
            onTap: () =>
              GoRouter.of(context).pushNamed(
                MovieScreen.name,
                params: {'id': movie.id.toString()},
              ),
            child: MovieCard(movie: movie),
          );
        },
      ),
    );
  }
}
```

**¿Qué sucede?**
1. Dibuja un ListView horizontal (scroll hacia los lados)
2. Cada película es un `MovieCard`
3. Al tocar una película, navega a `MovieScreen`

#### Paso 1️⃣2️⃣: Usuario ve la app con películas ✅

```
┌─────────────────────────────────┐
│   Custom App Bar                │
├─────────────────────────────────┤
│  🎬 Avatar  🎬 Avatar   🎬 ...  │  ← Slideshow
├─────────────────────────────────┤
│ En cines                         │
│  🎬 Dune   🎬 Oppenheimer ...   │  ← Horizontal List
├─────────────────────────────────┤
│ Próximamente                     │
│  🎬 Godzilla  🎬 Deadpool ...  │
└─────────────────────────────────┘
│ 🏠  📁  ❤️                       │  ← Bottom Navigation
```

#### Paso 1️⃣3️⃣: Usuario toca una película

```dart
// MovieCard toca → MovieScreen(/movie/505642)
GoRouter.of(context).pushNamed(MovieScreen.name, params: {'id': '505642'})
```

El router navega a `/home/0/movie/505642`

#### Paso 1️⃣4️⃣: MovieScreen carga detalles

```dart
// presentation/screens/movies/movie_screen.dart
class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    
    // Pide los detalles de la película
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    
    // Pide los actores
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1
            ),
          ),
        ],
      ),
    );
  }
}
```

**¿Qué sucede?**
1. Solicita detalles completos de esa película
2. Solicita actores de esa película
3. Mientras carga, muestra un spinner
4. Cuando llegan los datos, muestra los detalles

---

## 📊 Diagrama de Relaciones

### ¿Quién llama a quién?

```
┌──────────────┐
│  HomeView    │ watches
│ ref.watch()  ├──→ nowPlayingMoviesProvider
└──────────────┘     │
                     │ reads .notifier
                     ↓
            ┌────────────────────┐
            │ MoviesNotifier     │
            │ loadNextPage()     │
            └────────┬───────────┘
                     │ calls
                     ↓
         ┌───────────────────────┐
         │ MovieRepositoryImpl    │
         │ getNowPlaying()       │
         └───────────┬───────────┘
                     │ calls
                     ↓
        ┌──────────────────────────┐
        │ MoviedbDatasource        │
        │ getNowPlaying()          │
        └──────────┬───────────────┘
                   │ hace GET
                   ↓
          ┌────────────────────┐
          │ https://api.      │
          │ themoviedb.org    │
          │ /movie/now_       │
          │ playing           │
          └────────┬───────────┘
                   │ JSON response
                   ↓
         ┌──────────────────────┐
         │ MovieMapper          │
         │ movieDBToEntity()    │
         └──────────┬───────────┘
                    │ Movie entity
                    ↓
          ┌────────────────────┐
          │ MoviesNotifier     │
          │ state = movies     │
          └────────┬───────────┘
                   │ notifica
                   ↓
            ┌──────────────┐
            │  HomeView    │
            │ ref.watch()  │ recibe cambios
            │ rebuild()    │ se redibuja
            └──────────────┘
```

### Flujo de una película al ser tocada

```
MovieCard (onTap)
    ↓
GoRouter.pushNamed(MovieScreen.name, params: {id})
    ↓
app_router.dart (define la ruta)
    ↓
MovieScreen (constructo)
    ↓
MovieScreenState (initState)
    ↓
movieInfoProvider.notifier.loadMovie(id)
    ↓
MovieMapNotifier.loadMovie()
    ↓
movieRepository.getMovieById(id)
    ↓
datasource.getMovieById(id)
    ↓
Dio.get('/movie/{id}')
    ↓
TMDb API devuelve JSON
    ↓
MovieMapper.movieDetailsToEntity()
    ↓
Movie entity
    ↓
State actualizado: state[id] = movie
    ↓
MovieScreen.build() (ref.watch) detecta cambio
    ↓
Widget se redibuja con la película
```

---

## 🔐 Seguridad: API Key

¿Cómo se protege la API key?

```dart
// .env (NO debe estar en GIT)
THE_MOVIEDB_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

// config/constants/environment.dart
class Environment {
  static String theMovieDbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay api key';
}

// .gitignore (previene subir el .env)
.env
```

**Por qué funciona:**
1. Al iniciar, `main()` carga `.env` con `await dotenv.load()`
2. `Environment.theMovieDbKey` accede a esa variable
3. Cada petición HTTP incluye la API key
4. El `.env` no se sube a GitHub (seguridad)

---

## 🎨 Patrones de Código

### 1. Consumer vs ConsumerStateful

```dart
// ConsumerWidget (sin estado)
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(provider);
    return Text(data.toString());
  }
}

// ConsumerStatefulWidget (con estado local)
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends ConsumerState<MyScreen> {
  int localCounter = 0; // Estado local del widget
  
  @override
  void initState() {
    super.initState();
    ref.read(provider.notifier).loadData(); // Pedir datos
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(provider); // Escuchar cambios
    return Text(data.toString());
  }
}
```

### 2. StateNotifier vs StateNotifierProvider

```dart
// El Notifier (lógica del estado)
class MoviesNotifier extends StateNotifier<List<Movie>> {
  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    final movies = await fetchMoreMovies();
    state = [...state, ...movies];
  }
}

// El Provider (expone el Notifier y el estado)
final moviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final repo = ref.watch(movieRepositoryProvider);
  return MoviesNotifier(fetchMoreMovies: repo.getNowPlaying);
});

// En un widget:
ref.watch(moviesProvider)        // Escucha la lista de películas
ref.read(moviesProvider.notifier).loadNextPage() // Llama metododel Notifier
```

### 3. Mapeo de datos (patrón Mapper)

```dart
// Antes del mapper:
Map<String, dynamic> json = {
  "id": 505642,
  "title": "Avatar",
  "poster_path": "/abc123.jpg",  // Relativo
  "release_date": "2022-12-16",   // String
  "backdrop_path": "",             // Vacío
};

// Después del mapper:
Movie movie = Movie(
  id: 505642,
  title: "Avatar",
  posterPath: "https://image.tmdb.org/t/p/w500/abc123.jpg", // URL completa
  releaseDate: DateTime(2022, 12, 16),                      // DateTime
  backdropPath: "https://placeholder.com/backdrop.jpg",    // Default si vacío
);
```

---

## 📋 Resumen: Cómo fluye TODO

```
1. USUARIO ABRE APP
   ↓
2. main.dart carga .env y inicia ProviderScope
   ↓
3. Go Router navega a /home/0 (HomeScreen)
   ↓
4. HomeScreen dibuja HomeView
   ↓
5. HomeView.initState() pide películas (ref.read(...).loadNextPage())
   ↓
6. MoviesNotifier llama moviesRepository.getNowPlaying()
   ↓
7. MovieRepositoryImpl delega a MoviedbDatasource.getNowPlaying()
   ↓
8. MoviedbDatasource hace GET a https://api.themoviedb.org/3/movie/now_playing
   ↓
9. API devuelve JSON con películas
   ↓
10. MovieMapper convierte JSON → Movie entities
   ↓
11. MoviesNotifier.state se actualiza con las películas
   ↓
12. Todos los Widgets que hacen ref.watch(nowPlayingMoviesProvider) 
    se reconstruyen automáticamente
   ↓
13. HomeView muestra las películas en pantalla
   ↓
14. Usuario toca una película → MovieScreen
   ↓
15. MovieScreen pide detalles (movieInfoProvider.loadMovie)
   ↓
16. Mismo flujo → Detalles en pantalla
   ↓
17. Usuario interactúa y la magia reactiva de Riverpod actualiza todo ✨
```

---

## 🎓 Conceptos Clave Aprendidos

| Concepto | Explicación |
|----------|-------------|
| **Clean Architecture** | Dividir código en capas: Domain, Infrastructure, Presentation |
| **Dependency Injection** | Pasar dependencias (Repository, DataSource) en constructores |
| **Abstracción (Interfaces)** | Domain define qué, Infrastructure implementa cómo |
| **Mapper Pattern** | Convertir modelos crudos de API en entidades limpias |
| **Riverpod** | Gestor de estado reactivo con Providers |
| **StateNotifier** | Clase que maneja la lógica para cambiar el estado |
| **ConsumerWidget** | Widget que puede acceder a Providers (ref) |
| **ref.watch()** | Escucha cambios en un Provider (reconstruye) |
| **ref.read()** | Lee un Provider una vez (no reconstruye) |
| **Go Router** | Gestor de rutas y navegación |
| **Dio** | Cliente HTTP (como Axios en JavaScript) |
| **Serialización JSON** | Convertir JSON ↔ Objetos Dart |

---

## 💡 Tips Importantes

1. **Domain nunca depende de Infrastructure**: Domain no sabe cómo se obtienen datos
2. **Infrastructure depende de Domain**: Infrastructure usa las interfaces del Domain
3. **Presentation usa tanto Domain como Infrastructure**: Presentation usa Entities y Controllers
4. **Los Mappers son tu amigo**: Convierten datos crudos en datos limpios
5. **Riverpod notifica automáticamente**: Cambio en state → Widgets se reconstruyen
6. **Lazy Loading**: Mapas en StateNotifier (movieInfoProvider, actorsByMovieProvider) cachean datos para no repetir peticiones

---

## 🚀 Próximos Pasos para Aprender

1. Añade un caché local con SQLite o Hive
2. Implementa búsqueda de películas
3. Añade funcionalidad de "Favoritas" con persistencia
4. Implementa paginación infinita (scroll infinito)
5. Añade tests unitarios a los Notifiers
6. Crea un servicio de autenticación

---

¡Felicidades! 🎉 Ahora entiendes cómo funciona una app Flutter moderna y profesional.
