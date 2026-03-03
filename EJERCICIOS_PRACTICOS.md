# 🎓 EJERCICIOS PRÁCTICOS - Aprende Haciendo

Desafíos progresivos para entender mejor cómo funciona Cinemapedia.

---

## 📌 Cómo usar esta guía

Cada ejercicio tiene:
1. **Descripción**: Qué debe hacer
2. **Pista**: Dónde mirar
3. **Solución**: Código completo

Intenta hacerlo primero sin ver la solución. ¡El aprendizaje está en intentar!

---

## 🟢 EJERCICIOS NIVEL 1: ENTENDER EL FLUJO

### Ejercicio 1.1: Rastrear una petición HTTP

**Descripción**: Cuando usuario abre la app, ¿cuántas peticiones HTTP se hacen? ¿A cuáles URLs?

**Pista**: Mira `HomeView.initState()` - ¿qué providers se cargan?

**Solución**:
```
4 peticiones HTTP en paralelo:

1. movieRepository.getNowPlaying()
   → GET /movie/now_playing?page=1&api_key=xxx&language=es-ES

2. movieRepository.getPopular()
   → GET /movie/popular?page=1&api_key=xxx&language=es-ES

3. movieRepository.getTopRated()
   → GET /movie/top_rated?page=1&api_key=xxx&language=es-ES

4. movieRepository.getUpcoming()
   → GET /movie/upcoming?page=1&api_key=xxx&language=es-ES

Cada una retorna List<Movie> que se guarda en su provider.
```

---

### Ejercicio 1.2: Identificar dónde ocurre la transformación de datos

**Descripción**: JSON de la API → Movie Entity. ¿Cuántos pasos hay? ¿En qué orden?

**Pista**: Mira el método `_jsonToMovies()` en `moviedb_datasource.dart`

**Solución**:
```dart
// Paso 1: JSON crudo
{
  "results": [
    {
      "id": 505642,
      "title": "Avatar",
      "poster_path": "/abc123.jpg",
      "release_date": "2022-12-16"
    }
  ]
}

// Paso 2: JSON → MovieDbResponse
MovieDbResponse.fromJson(json) 
  → contiene: results = List<MovieMovieDB>

// Paso 3: List<MovieMovieDB> → List<Movie>
.map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
  → cada MovieMovieDB se transforma en Movie

// Paso 4: Movie entity limpia
Movie(
  id: 505642,
  title: "Avatar",
  posterPath: "https://image.tmdb.org/t/p/w500/abc123.jpg",
  releaseDate: DateTime(2022, 12, 16)
)
```

---

### Ejercicio 1.3: ¿Qué sucede si el user scrollea el listview horizontal hasta el final?

**Descripción**: En `MovieHorizontalListview`, ¿qué pasa al detectar scroll?

**Pista**: Busca `loadNextPage` en el widget

**Solución**:
```dart
// En home_view.dart:
MovieHorizontalListview(
  movies: nowPlayingMovies,
  title: 'En cines',
  loadNextPage: () => 
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
)

// El widget MovieHorizontalListview tiene un ScrollController
// que detecta cuando está al final:
// if (scrollPosition >= maxScroll * 0.95) {
//   widget.loadNextPage()
// }

// Lo que llama:
// ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
//   → MoviesNotifier.loadNextPage()
//   → currentPage++
//   → fetchMoreMovies(page: 2)
//   → request a API
//   → películas nuevas añadidas al state
//   → ListView se reconstruye con más elementos
```

---

## 🟡 EJERCICIOS NIVEL 2: MODIFICAR CÓDIGO

### Ejercicio 2.1: Añadir una categoría nueva de películas

**Descripción**: Añade una nueva categoría "Películas que Pronto Verás" (watchlist).

**Pistas**:
1. Copia `upcomingMoviesProvider` en `presentation/providers/movies/movies_providers.dart`
2. Renómbralo a `watchlistMoviesProvider`
3. Usa `movieRepository.getUpcoming` (o la función que quieras)

**Solución**:

```dart
// En presentation/providers/movies/movies_providers.dart
// Añade esto después de upcomingMoviesProvider:

final watchlistMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getUpcoming;
  // O la función que prefieras (getPopular, getTopRated, etc)
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

// Luego en home_view.dart, en initState():
ref.read( watchlistMoviesProvider.notifier ).loadNextPage();

// Y en build():
final watchlistMovies = ref.watch( watchlistMoviesProvider );

// Finalmente en el Column de widgets:
MovieHorizontalListview(
  movies: watchlistMovies,
  title: 'Mi Watchlist',
  subTitle: 'Para ver pronto',
  loadNextPage: () => ref.read(watchlistMoviesProvider.notifier).loadNextPage()
),
```

---

### Ejercicio 2.2: Cambiar el idioma de las películas

**Descripción**: Actualmente es "es-ES" (español España). Cambia a "pt-BR" (portugués Brasil).

**Pista**: Busca `'language': 'es-ES'` en el código

**Solución**:

```dart
// En infrastructure/datasources/moviedb_datasource.dart:
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.themoviedb.org/3',
  queryParameters: {
    'api_key': Environment.theMovieDbKey,
    'language': 'pt-BR'  // ← Cambias de 'es-ES' a 'pt-BR'
  }
));

// En infrastructure/datasources/actor_moviedb_datasource.dart:
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.themoviedb.org/3',
  queryParameters: {
    'api_key': Environment.theMovieDbKey,
    'language': 'pt-MX'  // ← También aquí
  }
));

// Ahora todas las peticiones serán en portugués.
// Resultado: títulos, descripciones en portugués.
```

---

### Ejercicio 2.3: Cambiar el color principal de la app

**Descripción**: La app actual es azul (#2862F5). Cámbiala a rojo (#FF0000).

**Pista**: Busca `colorSchemeSeed` en el código

**Solución**:

```dart
// En config/theme/app_theme.dart:
class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFFFF0000)  // Rojo puro
  );
}

// Otras opciones populares:
// Color(0xFF00FF00)  // Verde
// Color(0xFFFFFF00)  // Amarillo
// Color(0xFF9C27B0)  // Púrpura
// Color(0xFF00BCD4)  // Cyan

// Toda la app se actualiza con el nuevo color automáticamente.
```

---

## 🟠 EJERCICIOS NIVEL 3: CREAR NUEVAS FEATURES

### Ejercicio 3.1: Crear una función para buscar películas

**Descripción**: Añade una función de búsqueda de películas por título.

**Pasos**:

**Paso 1**: Verifica que el repository tiene contrato para búsqueda
```dart
// En domain/repositories/movies_repository.dart
abstract class MoviesRepository {
  // ... otros métodos ...
  Future<List<Movie>> searchMovies( String query );
  // Ya existe, perfecto
}
```

**Paso 2**: Implementa en el datasource
```dart
// En infrastructure/datasources/moviedb_datasource.dart
@override
Future<List<Movie>> searchMovies(String query) async {
  final response = await dio.get(
    '/search/movie',
    queryParameters: {
      'query': query,
      'page': 1
    }
  );
  
  return _jsonToMovies(response.data);
}
```

**Paso 3**: Implementa en el repository
```dart
// En infrastructure/repositories/movie_repository_impl.dart
@override
Future<List<Movie>> searchMovies(String query) {
  return datasource.searchMovies(query);
}
```

**Paso 4**: Crea un provider para búsqueda
```dart
// En presentation/providers/search/ (crear carpeta)
// Nuevo archivo: search_movies_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';

// Provider que almacena el query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider que busca películas
final searchMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  
  if (query.isEmpty) return [];
  
  final repository = ref.watch(movieRepositoryProvider);
  return await repository.searchMovies(query);
});
```

**Paso 5**: Usa en un widget de búsqueda
```dart
// En presentation/views/search/ (crear)
// Nuevo archivo: search_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/search/search_movies_provider.dart';

class SearchView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final searchResult = ref.watch(searchMoviesProvider);
    
    return Column(
      children: [
        // Buscador
        TextField(
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
          decoration: InputDecoration(
            hintText: 'Buscar películas...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        
        // Resultados
        Expanded(
          child: searchResult.when(
            data: (movies) => ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) => 
                MovieCard(movie: movies[index]),
            ),
            loading: () => CircularProgressIndicator(),
            error: (error, st) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }
}
```

---

### Ejercicio 3.2: Añadir favoritas persistentes

**Descripción**: Guarda películas favoritas en SQLite y muestra en la pantalla de favoritas.

**Complejidad**: ALTA - Necesita nueva librería y lógica

**Pasos resumidos**:

1. Añade dependencia `sqflite` a `pubspec.yaml`
2. Crea `domain/entities/favorite.dart`
3. Crea `infrastructure/datasources/favorite_datasource.dart` (SQLite)
4. Crea `domain/repositories/favorites_repository.dart`
5. Crea provider en `presentation/providers/favorites_provider.dart`
6. Crea UI en `presentation/views/movies/favorites_view.dart`

**Código simplificado:**

```dart
// domain/repositories/favorites_repository.dart
abstract class FavoritesRepository {
  Future<void> addFavorite(Movie movie);
  Future<void> removeFavorite(String movieId);
  Future<List<Movie>> getFavorites();
}

// presentation/providers/favorites_provider.dart
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Movie>>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repository: repository);
});

class FavoritesNotifier extends StateNotifier<List<Movie>> {
  final FavoritesRepository repository;
  
  FavoritesNotifier({required this.repository}) : super([]) {
    _loadFavorites();
  }
  
  Future<void> _loadFavorites() async {
    final favorites = await repository.getFavorites();
    state = favorites;
  }
  
  Future<void> toggleFavorite(Movie movie) async {
    final isFavorited = state.any((m) => m.id == movie.id);
    
    if (isFavorited) {
      await repository.removeFavorite(movie.id.toString());
      state = state.where((m) => m.id != movie.id).toList();
    } else {
      await repository.addFavorite(movie);
      state = [...state, movie];
    }
  }
}
```

---

## 🔴 EJERCICIOS NIVEL 4: DEBUGGING Y OPTIMIZACIÓN

### Ejercicio 4.1: ¿Por qué se hacen 2 peticiones a la API al iniciar?

**Descripción**: En development mode, Riverpod hace peticiones 2 veces. ¿Por qué? ¿Cómo evitarlo?

**Explicación**:
```
Strict Mode de Riverpod (solo en development):
- Valida que los providers son puros
- Hace petición 1: carga normal
- Descarta el resultado
- Hace petición 2: verifica que devuelve lo mismo
- Esto es normal en desarrollo, en release solo se hace 1 vez

¿Cómo evitarlo?
No lo haces. Es una característica de validación.
En production build, solo se hace 1 petición.
```

---

### Ejercicio 4.2: Optimizar peticiones HTTP con caché

**Descripción**: Las películas se piden múltiples veces. Impleme un caché en el datasource.

**Solución:**

```dart
// infrastructure/datasources/moviedb_datasource.dart
class MoviedbDatasource extends MoviesDatasource {
  
  final dio = Dio(...);
  
  // CACHÉ EN MEMORIA
  final Map<String, List<Movie>> _cache = {};
  final Map<String, DateTime> _cacheTime = {};
  
  static const Duration CACHE_DURATION = Duration(hours: 1);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    final cacheKey = 'now_playing_$page';
    
    // Verifica si está en caché y no ha expirado
    if (_cache.containsKey(cacheKey)) {
      final lastFetch = _cacheTime[cacheKey];
      if (lastFetch != null && 
          DateTime.now().difference(lastFetch) < CACHE_DURATION) {
        return _cache[cacheKey]!;  // Devuelve caché
      }
    }
    
    // Si no está en caché, pide a API
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {'page': page}
    );
    
    final movies = _jsonToMovies(response.data);
    
    // Guarda en caché
    _cache[cacheKey] = movies;
    _cacheTime[cacheKey] = DateTime.now();
    
    return movies;
  }
}
```

---

### Ejercicio 4.3: Detectar errores de red

**Descripción**: ¿Qué pasa si no hay conexión a internet? Captura y maneja errores.

**Solución:**

```dart
// infrastructure/datasources/moviedb_datasource.dart
@override
Future<List<Movie>> getNowPlaying({int page = 1}) async {
  try {
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {'page': page}
    );
    
    return _jsonToMovies(response.data);
    
  } on DioException catch (e) {
    // DioException = error de HTTP
    
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('Conexión perdida. Intenta de nuevo.');
    } else if (e.type == DioExceptionType.unknown) {
      throw Exception('Sin conexión a internet');
    } else if (e.response?.statusCode == 401) {
      throw Exception('API Key inválida');
    } else {
      throw Exception('Error: ${e.message}');
    }
    
  } catch (e) {
    throw Exception('Error desconocido: $e');
  }
}
```

**Luego en el provider:**

```dart
// presentation/providers/movies/movies_providers.dart
class MoviesNotifier extends StateNotifier<List<Movie>> {
  
  Future<void> loadNextPage() async {
    if (isLoading) return;
    
    isLoading = true;
    
    try {
      currentPage++;
      final moreMovies = await fetchMoreMovies(page: currentPage);
      state = [...state, ...moreMovies];
    } catch (e) {
      // Muestra error al usuario
      print('Error: $e');
      currentPage--;  // Revierte el incremento
    }
    
    isLoading = false;
  }
}
```

---

## 🎯 MINI PROYECTOS

### Mini Proyecto 1: Clon de IMDB simplificado

**Funcionalidades**:
1. Listar películas (✅ ya está)
2. Ver detalles de película (✅ ya está)
3. Ver actores (✅ ya está)
4. Buscar películas (parcialmente - necesita UI)
5. Favoritas (❌ falta implementar)
6. Ratings del usuario (❌ falta implementar)

**Tareas pendientes**:
- [ ] Crear `SearchView` (Ejercicio 3.1)
- [ ] Implementar favoritas en SQLite (Ejercicio 3.2)
- [ ] Mostrar rating del usuario en detalles
- [ ] Filtrar por género
- [ ] Ordenar por diferentes criterios

---

### Mini Proyecto 2: Sistema de recomendaciones

**Idea**: Si el user ve varias películas de acción, recomienda análogas.

**Implementación**:
1. Tracking: guardar películas vistas
2. Análisis: detectar género predominante
3. Recomendación: petición "similares"
4. UI: mostrar en una sección especial

---

## 📝 Respuestas Rápidas

### P: ¿Dónde se actualiza el estado?
**R**: En la clase `StateNotifier` cuando asignas a `state`:
```dart
state = newValue;  // Notifica a listeners
```

### P: ¿Cómo paso datos de un Widget a otro?
**R**: Con Providers (estado global) o parámetros de constructor (local)

### P: ¿Qué es `ref.watch()` vs `ref.read()`?
**R**: 
- `watch()` = escucha cambios (reconstruye widget)
- `read()` = lee una vez (sin escuchar)

### P: ¿Dónde guardo datos persistentes?
**R**: En base de datos (SQLite con sqflite) o SharedPreferences.

### P: ¿Cómo hago autenticación?
**R**: Crea un `AuthRepository` y un `AuthProvider` similar a movies.

### P: ¿Puedo usar Firebase?
**R**: Sí, en el datasource en lugar de Dio.

---

## 🏆 Checklist de Aprendizaje

- [ ] Entiendo qué es Clean Architecture
- [ ] Entiendo qué es un Provider en Riverpod
- [ ] Entiendo qué es un StateNotifier
- [ ] Entiendo qué es un Mapper
- [ ] Puedo rastrear un flujo de datos completo
- [ ] Puedo añadir un nuevo provider
- [ ] Puedo hacer una petición HTTP
- [ ] Puedo parsear JSON a Dart objects
- [ ] Entiendo el ciclo de vida de un Widget
- [ ] Puedo debuggear errores de red
- [ ] Puedo cachear datos
- [ ] Puedo hacer persistencia en BD

Si puedes marcar todos, **¡eres un developer Flutter avanzado!** 🚀

---

¡Sigue practicando! 💪
