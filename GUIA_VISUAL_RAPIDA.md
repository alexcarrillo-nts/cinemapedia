# 📊 GUÍA VISUAL RÁPIDA - CINEMAPEDIA

Una referencia rápida con visualizaciones para consultar mientras códigos.

---

## 🏗️ Estructura de Carpetas (visualizada)

```
lib/
├── 📄 main.dart ⭐ INICIO DE TODO
│   ├─ dotenv.load() → Carga API key
│   ├─ ProviderScope → Habilita Riverpod
│   └─ MainApp() → Inicia la app
│
├── 🎨 config/ → CONFIGURACIÓN
│   ├─ constants/
│   │  └─ environment.dart → Variables globales (API key)
│   ├─ helpers/
│   │  └─ human_formats.dart → Funciones útiles
│   ├─ router/
│   │  └─ app_router.dart → Rutas y navegación
│   └─ theme/
│      └─ app_theme.dart → Tema visual (Material 3)
│
├─ 🎯 domain/ → CONTRATOS (¿QUÉ queremos hacer?)
│   ├─ entities/
│   │  ├─ movie.dart → Clase Movie limpia
│   │  └─ actor.dart → Clase Actor limpia
│   ├─ datasources/
│   │  ├─ movies_datasource.dart → ¿De dónde vienen las películas?
│   │  └─ actors_datasource.dart → ¿De dónde vienen los actores?
│   └─ repositories/
│      ├─ movies_repository.dart → ¿Qué operaciones puedo hacer?
│      └─ actors_repository.dart → ¿Qué operaciones puedo hacer?
│
├─ ⚙️ infrastructure/ → IMPLEMENTACIÓN (¿CÓMO obtenemos datos?)
│   ├─ datasources/
│   │  ├─ moviedb_datasource.dart → Obtiene películas de API
│   │  └─ actor_moviedb_datasource.dart → Obtiene actores de API
│   ├─ models/
│   │  └─ moviedb/
│   │     ├─ movie_moviedb.dart → Película tal como viene de API
│   │     ├─ credits_response.dart → Actores tal como vienen
│   │     └─ moviedb_response.dart → Respuesta paginada de API
│   ├─ mappers/
│   │  ├─ movie_mapper.dart → MovieDB → Movie (JSON limpio)
│   │  └─ actor_mapper.dart → Cast → Actor (JSON limpio)
│   └─ repositories/
│      ├─ movie_repository_impl.dart → Implementa MoviesRepository
│      └─ actor_repository_impl.dart → Implementa ActorsRepository
│
└─ 🎬 presentation/ → INTERFAZ DE USUARIO
   ├─ screens/
   │  └─ movies/
   │     ├─ home_screen.dart → Pantalla principal (con navegación)
   │     └─ movie_screen.dart → Detalle de película
   ├─ views/
   │  └─ movies/
   │     ├─ home_view.dart → Vista de películas
   │     └─ favorites_view.dart → Vista de favoritas
   ├─ widgets/
   │  ├─ movies/
   │  │  ├─ movies_slideshow.dart → Carrusel de películas
   │  │  └─ movie_horizontal_listview.dart → Lista horizontal
   │  └─ shared/
   │     ├─ custom_appbar.dart → Barra superior
   │     ├─ custom_bottom_navigation.dart → Barra inferior
   │     └─ full_screen_loader.dart → Pantalla de cargando
   └─ providers/
      ├─ movies/
      │  ├─ movies_repository_provider.dart → Repository (inmutable)
      │  ├─ movies_providers.dart → Estados de películas
      │  ├─ initial_loading_provider.dart → ¿Está cargando?
      │  ├─ movies_slideshow_provider.dart → Películas para intro
      │  └─ movie_info_provider.dart → Detalles de 1 película
      └─ actors/
         ├─ actors_repository_provider.dart → Repository de actores
         └─ actors_by_movie_provider.dart → Actores por película
```

---

## 🔄 Flujo de Datos (simplificado)

### Flujo 1: Cargar películas al abrir la app

```
┌─────────────┐
│ App starts  │
└──────┬──────┘
       ↓
┌─────────────────────────────┐
│ HomeView.initState()        │
│ ref.read(...).loadNextPage()│
└──────┬──────────────────────┘
       ↓
┌─────────────────────────────────┐
│ MoviesNotifier.loadNextPage()   │
│ - currentPage++                 │
│ - await fetchMoreMovies()       │
│ - state = [... movies]          │
└──────┬──────────────────────────┘
       ↓
┌──────────────────────────────────┐
│ MovieRepositoryImpl.getNowPlaying │
│ return datasource.getNowPlaying()│
└──────┬───────────────────────────┘
       ↓
┌────────────────────────────────────────┐
│ MoviedbDatasource.getNowPlaying()      │
│ - response = dio.get('/movie/...')     │
│ - JSON → MovieMovieDB (model)          │
│ - MovieMapper → Movie (entity)         │
│ return List<Movie>                    │
└──────┬─────────────────────────────────┘
       ↓
┌──────────────────────┐
│ API Response        │
│ {results: [...]}    │
└──────────────────────┘
       ↓ (mappers)
┌──────────────────────┐
│ Movie entities      │
│ [Movie(...), ...]  │
└──────┬───────────────┘
       ↓
┌────────────────────────────┐
│ HomeView                   │
│ ref.watch() detecta cambio │
│ Widget rebuild ✨         │
└──────┬─────────────────────┘
       ↓
┌──────────────────────────┐
│ User sees movies 📺     │
└──────────────────────────┘
```

### Flujo 2: Usuario toca una película

```
┌──────────────────────────┐
│ User taps MovieCard     │
└──────┬───────────────────┘
       ↓
┌─────────────────────────────────────┐
│ GoRouter.pushNamed(                │
│   MovieScreen.name,                │
│   params: {'id': movieId}          │
│ )                                  │
└──────┬────────────────────────────────┘
       ↓
┌────────────────────────────────────┐
│ app_router.dart                   │
│ '/home/0/movie/:id' → MovieScreen │
└──────┬───────────────────────────────┘
       ↓
┌────────────────────────────────────┐
│ MovieScreen (constructo)          │
│ movieId = param['id']             │
└──────┬───────────────────────────────┘
       ↓
┌──────────────────────────────────────────┐
│ MovieScreenState.initState()            │
│ ref.read(movieInfoProvider.notifier)    │
│   .loadMovie(widget.movieId)           │
│ ref.read(actorsByMovieProvider.notifier)│
│   .loadActors(widget.movieId)          │
└──────┬───────────────────────────────────┘
       ↓
┌─────────────────────────────┐
│ Pide detalles de película   │
│ Pide lista de actores       │
└──────┬──────────────────────┘
       ↓
┌─────────────────────────┐
│ MovieScreen widget build│
│ movie = ref.watch       │
│ if null → show loader   │
│ if data → show details  │
└──────┬──────────────────┘
       ↓
┌──────────────────────────┐
│ Movie details visible 🎬 │
└──────────────────────────┘
```

---

## 🔗 Flujo de Dependencias (Quién usa a quién)

```
PRESENTATION LAYER
├─ HomeScreen
│  └─ HomeView (ConsumerStatefulWidget)
│     ├─ watches: nowPlayingMoviesProvider
│     ├─ watches: popularMoviesProvider
│     ├─ watches: upcomingMoviesProvider
│     ├─ watches: topRatedMoviesProvider
│     ├─ watches: initialLoadingProvider
│     └─ reads: *.notifier.loadNextPage()
│
├─ MovieScreen
│  ├─ watches: movieInfoProvider
│  ├─ reads: movieInfoProvider.notifier.loadMovie()
│  ├─ reads: actorsByMovieProvider.notifier.loadActors()
│  └─ displays: Movie details + Actors
│
└─ Widgets (MovieCard, MovieHorizontalListview, etc)
   └─ receive movies as parameters
      └─ onTap → GoRouter.pushNamed()

         ⬇️

PROVIDERS (State Management)
├─ nowPlayingMoviesProvider
├─ popularMoviesProvider
├─ upcomingMoviesProvider
├─ topRatedMoviesProvider
├─ movieInfoProvider
├─ actorsByMovieProvider
├─ initialLoadingProvider
└─ moviesSlideshowProvider
   │ Todos usan
   └─→ movieRepositoryProvider
      └─→ actorsRepositoryProvider

         ⬇️

REPOSITORIES (Intermediate)
├─ MovieRepositoryImpl
│  └─ calls: MoviedbDatasource
└─ ActorRepositoryImpl
   └─ calls: ActorMovieDbDatasource

         ⬇️

DATASOURCES (HTTP Calls)
├─ MoviedbDatasource
│  ├─ makes: Dio HTTP requests
│  ├─ parses: MovieMovieDB models
│  └─ calls: MovieMapper.movieDBToEntity()
└─ ActorMovieDbDatasource
   ├─ makes: Dio HTTP requests
   ├─ parses: Cast models
   └─ calls: ActorMapper.castToEntity()

         ⬇️

MAPPERS (Data Transformation)
├─ MovieMapper
│  └─ MovieMovieDB → Movie (entity)
└─ ActorMapper
   └─ Cast → Actor (entity)

         ⬇️

MODELS (Raw API Data)
├─ MovieMovieDB
├─ MovieDbResponse
├─ Cast
└─ CreditsResponse

         ⬇️

THE MOVIE DB API
└─ https://api.themoviedb.org/3/
   ├─ /movie/now_playing
   ├─ /movie/popular
   ├─ /movie/top_rated
   ├─ /movie/upcoming
   ├─ /movie/{id}
   └─ /movie/{id}/credits
```

---

## 📋 Tabla Rápida: Quién es Quién

| Archivo | Qué es | Responsabilidad | Devuelve |
|---------|--------|-----------------|----------|
| **entity/movie.dart** | Clase | Representar una película | Movie object |
| **entity/actor.dart** | Clase | Representar un actor | Actor object |
| **datasource/movies_datasource.dart** | Interfaz | Contrato de obtención | Sin implementar |
| **repository/movies_repository.dart** | Interfaz | Contrato de operaciones | Sin implementar |
| **datasource/moviedb_datasource.dart** | Clase | Obtener datos del API | List<Movie> |
| **repository/movie_repository_impl.dart** | Clase | Implementar operaciones | Delega a datasource |
| **model/movie_moviedb.dart** | Clase | Estructura JSON cruda | Movie del JSON |
| **mapper/movie_mapper.dart** | Clase utilitaria | Convertir modelos | Movie entity limpia |
| **provider/movies_providers.dart** | Riverpod | Gestionar estado | List<Movie> reactivo |
| **screen/home_screen.dart** | Widget | Pantalla completa | UI final |
| **view/home_view.dart** | Widget | Sección de pantalla | UI con datos |
| **widget/movie_horizontal_listview.dart** | Widget | Componente pequeño | UI reutilizable |

---

## 🎯 Patrón General

### Patrón para OBTENER datos

```
HomeView
  ↓ lee
Movieprovider (Riverpod)
  ↓ usa
MovieRepository (Domain - contrato)
  ↓ implementado por
MovieRepositoryImpl (Infrastructure)
  ↓ delega
MoviedbDatasource (Infrastructure)
  ↓ hace HTTP
Dio HTTP Client
  ↓ llama
The Movie DB API
  ↓ devuelve
JSON response
  ↓ parseado
MovieMovieDB model (raw)
  ↓ mapeado
Movie entity (clean)
  ↓ actualiza
Provider state
  ↓ notifica
HomeView rebuild
  ↓ muestra
User vé películas en pantalla
```

### Patrón para ENVIAR datos a componentes hijos

```
HomeView
  │ tiene List<Movie> movies
  ├─→ pasa a MovieHorizontalListview(movies: movies)
  │   │ tiene List<Movie> movies
  │   ├─→ pasa a MovieCard(movie: movie)
  │   │   │ tiene Movie movie
  │   │   └─→ onTap: () => GoRouter.pushNamed()

MovieHorizontalListview(movies, loadNextPage)
  │ tiene Function loadNextPage
  └─→ cuando scroll está al final
      └─→ llama loadNextPage()
          └─→ ref.read(provider.notifier).loadNextPage()
```

---

## 💾 Estado en Riverpod

### Tipos de Providers

```
// 1. Provider (IMMutable - nunca cambia)
final configProvider = Provider((ref) {
  return AppConfig(); // Siempre el mismo
});

// 2. StateNotifierProvider (puede cambiar)
final moviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  return MoviesNotifier(fetchMoreMovies: repo.getNowPlaying);
});

// El estado es List<Movie>
// Cambios: state = [...state, ...new]
// Watch: ref.watch(moviesProvider) → List<Movie>
// Notifier: ref.read(moviesProvider.notifier) → MoviesNotifier

// 3. FutureProvider (async que solo se corre 1 vez)
final movieDetailsProvider = FutureProvider<Movie>((ref) async {
  return await repo.getMovieById('123');
});

// 4. StreamProvider (async que emite múltiples valores)
final movieStreamProvider = StreamProvider<Movie>((ref) async* {
  while(true) {
    yield await fetchMovie();
    await Future.delayed(Duration(seconds: 5));
  }
});
```

### Acceder a Providers

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    // WATCH - Escucha cambios (rebuild si cambia)
    final movies = ref.watch(moviesProvider);
    
    // READ - Lee 1 vez (no rebuild)
    final config = ref.read(configProvider);
    
    // READ NOTIFIER - Accede a métodos del StateNotifier
    ref.read(moviesProvider.notifier).loadNextPage();
    
    // LISTEN - Callback cuando cambia
    ref.listen(moviesProvider, (previous, next) {
      print('Películas cambiaron: $next');
    });
    
    return Text('${movies.length} películas');
  }
}
```

---

## 🔐 Variables de Entorno

### .env (archivo local, NO en GIT)
```
THE_MOVIEDB_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### .gitignore (impide subirlo a GIT)
```
.env
```

### environment.dart (acceso desde la app)
```dart
class Environment {
  static String theMovieDbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay api key';
}
```

### En requests HTTP
```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.themoviedb.org/3',
  queryParameters: {
    'api_key': Environment.theMovieDbKey, // Añadido automáticamente a todo
    'language': 'es-ES'
  }
));
```

---

## 🚀 Flujos Comunes del Día a Día

### Caso 1: Quiero mostrar una nueva lista de películas

1. **Crea la entidad** (si no existe): `domain/entities/`
2. **Crea el datasource contrato**: `domain/datasources/`
3. **Crea el datasource impl**: `infrastructure/datasources/`
4. **Crea el model**: `infrastructure/models/`
5. **Crea el mapper**: `infrastructure/mappers/`
6. **Crea el repository contrato**: `domain/repositories/`
7. **Crea el repository impl**: `infrastructure/repositories/`
8. **Crea el provider**: `presentation/providers/`
9. **Úsalo en un widget**: `presentation/views/` con `ref.watch()`

### Caso 2: Quiero añadir búsqueda

1. Añade método al **domain/repositories/movies_repository.dart**:
   ```dart
   Future<List<Movie>> searchMovies( String query );
   ```
2. Implementa en **infrastructure/datasources/moviedb_datasource.dart**:
   ```dart
   @override
   Future<List<Movie>> searchMovies(String query) async {
     // GET /search/movie?query=query
   }
   ```
3. Implementa en **infrastructure/repositories/movie_repository_impl.dart**
4. Crea provider en **presentation/providers/search/**
5. Úsalo en **presentation/views/search_view.dart**

### Caso 3: Quiero cachear datos

Usa `Map<String, Movie>` en el StateNotifier:
```dart
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  return MovieMapNotifier(getMovie: repo.getMovieById);
});

class MovieMapNotifier extends StateNotifier<Map<String,Movie>> {
  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return; // Ya está en caché
    
    final movie = await getMovie(movieId);
    state = {...state, movieId: movie}; // Añade a caché
  }
}
```

---

## 🐛 Debugging Tips

### Problema: "Provider not found"
**Solución**: Asegúrate de que está dentro de `ProviderScope` en main.dart

### Problema: "Widget no se redibuja con nuevos datos"
**Solución**: Usa `ref.watch()` no `ref.read()`. Watch detecta cambios.

### Problema: "Petición HTTP se hace 2 veces"
**Solución**: StrictMode de Riverpod en desarrollo. Es normal. En release, solo se hace 1 vez.

### Problema: "API key no se carga"
**Solución**: Verifica que `.env` exista y `main.dart` haga `await dotenv.load()` ANTES de runApp

### Problema: "Mapper no convierte correctamente"
**Solución**: Revisa que el JSON tiene los campos que espera el mapper. Usa try-catch o valores por defecto.

---

## ✨ Resumen en una Línea

> **Datos fluyen desde API → DataSource → Mapper → Entity → Provider → Widget → Pantalla**

---

## 📚 Estructura de Directorios para Copiar

Si necesitas crear una nueva sección (ej: series), copia esta estructura:

```
mkdir -p lib/domain/entities
mkdir -p lib/domain/datasources
mkdir -p lib/domain/repositories
mkdir -p lib/infrastructure/datasources
mkdir -p lib/infrastructure/models
mkdir -p lib/infrastructure/mappers
mkdir -p lib/infrastructure/repositories
mkdir -p lib/presentation/screens
mkdir -p lib/presentation/views
mkdir -p lib/presentation/widgets
mkdir -p lib/presentation/providers
```

---

¡Buen coding! 🚀
