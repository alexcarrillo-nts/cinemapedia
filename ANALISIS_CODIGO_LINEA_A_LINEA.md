# 🔍 ANÁLISIS LÍNEA A LÍNEA - ARCHIVOS CLAVE

Explicación detallada de los archivos más importantes con comentarios en cada línea.

---

## 📌 main.dart - El Punto de Entrada

```dart
// ===== IMPORTACIONES =====
import 'package:flutter/material.dart';
// Importa el framework Flutter con widgets como Scaffold, etc.

import 'package:cinemapedia/config/router/app_router.dart';
// Importa la configuración de rutas (navigationador)

import 'package:flutter_dotenv/flutter_dotenv.dart';
// Importa la librería para leer archivos .env

import 'package:cinemapedia/config/theme/app_theme.dart';
// Importa el tema visual (colores, fuentes, etc.)

import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importa Riverpod para gestión de estado reactiva


// ===== FUNCIÓN MAIN (ENTRADA DE LA APP) =====
Future<void> main() async {
  // 'async' porque cargar .env es asincrónico (puede tardar)
  
  await dotenv.load(fileName: '.env');
  // ESPERA a que cargue el archivo .env
  // Si no existe el archivo, continúa de todas formas
  // El .env contiene: THE_MOVIEDB_KEY=xxxxx

  runApp(
    // Define qué será la raíz de la app
    const ProviderScope(
      // ProviderScope habilita Riverpod en toda la app
      // Sin esto, ref.watch() no funcionaría en ningún Widget
      
      child: MainApp()
      // MainApp es el Widget raíz
    ),
  );
}


// ===== WIDGET PRINCIPAL =====
class MainApp extends StatelessWidget {
  // StatelessWidget = no tiene estado local
  // (el estado global se maneja con Riverpod)
  
  const MainApp({super.key});
  // Constructor const = puede compilarse en tiempo de compilación

  @override
  Widget build(BuildContext context) {
    // BuildContext = contexto de construcción (información del árbol de widgets)
    
    return MaterialApp.router(
      // MaterialApp.router = usa Go Router para navegación
      // (NO es MaterialApp normal)
      
      routerConfig: appRouter,
      // appRouter viene de app_router.dart
      // Define todas las rutas de la app
      // Ruta inicial: /home/0
      // Rutas hijas: /home/0/movie/:id
      
      debugShowCheckedModeBanner: false,
      // Quita la cinta de DEBUG en la esquina
      // (ese texto "DEBUG" rojo/amarillo)
      
      theme: AppTheme().getTheme(),
      // Aplica el tema visual a toda la app
      // Material 3 con color principal azul (#2862F5)
    );
  }
}
```

**¿Qué pasa en orden?**
1. Se ejecuta `main()`
2. Carga el archivo `.env` (espera con `await`)
3. Inicia Flutter con `runApp()`
4. `ProviderScope` envuelve todo (habilita Riverpod)
5. `MainApp` se renderiza
6. `MaterialApp.router` configura tema y rutas
7. Go Router navega a `/home/0`
8. Se muestra `HomeScreen` ✅

---

## 🛣️ app_router.dart - Navegación

```dart
import 'package:go_router/go_router.dart';
// Go Router = librería de navegación moderna

import 'package:cinemapedia/presentation/screens/screens.dart';
// Importa todas las pantallas


// ===== CONFIGURACIÓN DEL ROUTER =====
final appRouter = GoRouter(
  // GoRouter es una variable global que define todas las rutas
  
  initialLocation: '/home/0',
  // Ruta inicial cuando abre la app
  // /home/0 = HomeScreen con pageIndex=0
  
  routes: [
    // Array de todas las rutas posibles
    
    GoRoute(
      path: '/home/:page',
      // :page es un parámetro dinámico
      // /home/0, /home/1, /home/2 → todas válidas
      
      name: HomeScreen.name,
      // Nombre interno de la ruta (para referencias con pushNamed)
      // HomeScreen.name = 'home-screen'
      
      builder: (context, state) {
        // Función que construye el Widget para esta ruta
        // state = información de la navegación
        
        final pageIndex = int.parse(state.params['page'] ?? '0');
        // Extrae el parámetro :page
        // Si no existe, usa '0' por defecto
        // int.parse convierte String '0' → int 0
        
        return HomeScreen(pageIndex: pageIndex);
        // Construye HomeScreen pasando el pageIndex
      },
      
      routes: [
        // Rutas ANIDADAS dentro de /home/:page
        
        GoRoute(
          path: 'movie/:id',
          // Ruta completa: /home/0/movie/505642
          // Relativa a la ruta padre
          
          name: MovieScreen.name,
          
          builder: (context, state) {
            final movieId = state.params['id'] ?? 'no-id';
            // Extrae el ID de la película
            // Si no existe, usa 'no-id'
            
            return MovieScreen(movieId: movieId);
            // Construye la pantalla de detalles
          },
        ),
      ],
    ),
    
    
    GoRoute(
      path: '/',
      // Ruta raíz
      
      redirect: (context, state) => '/home/0',
      // Si accedes a /, redirige a /home/0
      // Esto previene que la app se quede en una pantalla vacía
    ),
  ],
);
```

**Mapeo de rutas:**
- `/` → redirige a `/home/0`
- `/home/0` → `HomeScreen(pageIndex: 0)` - Películas
- `/home/1` → `HomeScreen(pageIndex: 1)` - Categorías
- `/home/2` → `HomeScreen(pageIndex: 2)` - Favoritas
- `/home/0/movie/505642` → `MovieScreen(movieId: "505642")`

**Cómo navegar:**
```dart
// Forma correcta 1: Usar nombre
GoRouter.of(context).pushNamed(MovieScreen.name, params: {'id': '505642'});

// Forma correcta 2: Usar ruta
GoRouter.of(context).push('/home/0/movie/505642');

// Forma correcta 3: Reemplazar pantalla
GoRouter.of(context).go('/home/1');
```

---

## 🎯 presentation/providers/movies/movies_providers.dart - Gestor de Estado

```dart
// ===== IMPORTACIONES =====
import 'package:cinemapedia/domain/entities/movie.dart';
// Movie = la entidad limpia que queremos

import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
// Provider que proporciona el Repository

import 'package:flutter_riverpod/flutter_riverpod.dart';
// Riverpod para crear Providers


// ===== DEFINICIÓN DEL PROVIDER =====
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  // StateNotifierProvider<T, S>
  //   T = clase que maneja el estado (MoviesNotifier)
  //   S = tipo del estado (List<Movie>)
  //
  // (ref) = parámetro que permite acceder a otros providers
  
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  // ref.watch = accede a movieRepositoryProvider y obtiene su valor
  // .getNowPlaying = función para obtener películas en cines
  // Tipo: Future<List<Movie>> Function({int page})
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
    // Crea el Notifier pasándole la función
  );
});

// Igual para otras categorías de películas...
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider ).getPopular;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});


// ===== TIPO DE DATO PERSONALIZADO =====
typedef MovieCallback = Future<List<Movie>> Function({ int page });
// Define que MovieCallback es:
// Una función async que recibe un parámetro page
// y devuelve Future<List<Movie>>


// ===== CLASE QUE MANEJA EL ESTADO =====
class MoviesNotifier extends StateNotifier<List<Movie>> {
  // Extiende StateNotifier<T> donde T = tipo del estado
  // En este caso: StateNotifier<List<Movie>>
  
  int currentPage = 0;
  // Qué página vamos a cargar (empieza en 0)
  
  bool isLoading = false;
  // Bandera: ¿están de cargando datos?
  
  MovieCallback fetchMoreMovies;
  // Función para obtener películas desde el repository
  
  
  MoviesNotifier({
    required this.fetchMoreMovies,
    // Constructor: recibe obligatoriamente fetchMoreMovies
  }): super([]);
  // super([]) = el estado inicial es una lista vacía


  Future<void> loadNextPage() async {
    // Función pública que carga la siguiente página
    
    if (isLoading) return;
    // Si ya estamos cargando, no hagas nada (evita peticiones dobles)
    
    isLoading = true;
    // Marca que estamos cargando
    
    currentPage++;
    // Pasa a la siguiente página (1, 2, 3, ...)
    
    // ⚡ PETICIÓN ASINCRÓNICA
    final List<Movie> moreMovies = await fetchMoreMovies(page: currentPage);
    // Llama la función fetchMoreMovies (que es repository.getNowPlaying)
    // Espera con 'await' a que termine
    // Devuelve List<Movie> con las nuevas películas
    
    state = [...state, ...moreMovies];
    // ACTUALIZA EL ESTADO
    // [...state] = spread operator (copia todos los elementos)
    // [...state, ...moreMovies] = lista anterior + películas nuevas
    // Esto NOTIFICA a todos los Widgets que hacen ref.watch()
    
    isLoading = false;
    // Marca que terminó la carga
  }
}
```

**Cómo se usa:**
```dart
final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
// nowPlayingMovies = List<Movie> actual
// Si state cambia, el Widget se reconstruye

ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
// Lee el Notifier y llama loadNextPage()
// No reconstruye el Widget
```

---

## 🎬 infrastructure/datasources/moviedb_datasource.dart - Obtener Datos

```dart
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:dio/dio.dart';
// Dio = cliente HTTP (como fetch en JavaScript)

import 'package:cinemapedia/config/constants/environment.dart';
// Env = variables de entorno (API key)

import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
// MoviesDatasource = interfaz (contrato)

import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
// MovieMapper = convierte modelos

import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';


// ===== IMPLEMENTACIÓN DE DATASOURCE =====
class MoviedbDatasource extends MoviesDatasource {
  // Extiende MoviesDatasource (implementa su contrato)
  // MoviesDatasource dice "tienes que implementar estos métodos"
  
  
  // ===== CONFIGURACIÓN HTTP =====
  final dio = Dio(BaseOptions(
    // Dio = cliente HTTP
    // BaseOptions = configuración por defecto para todas las peticiones
    
    baseUrl: 'https://api.themoviedb.org/3',
    // URL BASE: todas las peticiones usa esta como prefijo
    // GET /movie/now_playing → https://api.themoviedb.org/3/movie/now_playing
    
    queryParameters: {
      // Parámetros que se añaden a TODAS las peticiones
      
      'api_key': Environment.theMovieDbKey,
      // API key cargada desde .env
      // Se envía en cada petición: ?api_key=xxxxx
      
      'language': 'es-ES'
      // Idioma de respuestas: español España
      // Se envía en cada petición: &language=es-ES
    }
  ));


  // ===== MÉTODO PRIVADO: CONVERTIR JSON A MOVIES =====
  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    // Método privado (con _) = solo se usa dentro de esta clase
    // Convierte JSON crudo → List<Movie> limpia
    
    final movieDBResponse = MovieDbResponse.fromJson(json);
    // json = {"results": [{...}, {...}]}
    // Convierte en objeto MovieDbResponse
    // MovieDbResponse tiene un campo 'results' que es List<MovieMovieDB>
    
    final List<Movie> movies = movieDBResponse.results
      // movieDBResponse.results = List<MovieMovieDB>
      
      .where((moviedb) => moviedb.posterPath != 'no-poster' )
      // Filtra: solo películas con poster válido
      // Quita películas sin imagen
      
      .map(
        (moviedb) => MovieMapper.movieDBToEntity(moviedb)
        // Convierte cada MovieMovieDB → Movie
        // .map() transforma cada elemento en otro tipo
      )
      
      .toList();
    // Convierte el Iterable en List
    
    return movies;
    // Devuelve List<Movie> limpia
  }


  // ===== MÉTODOS PÚBLICOS (Implementan el contrato) =====
  
  @override
  // @override = estoy implementando un método de la clase padre
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    // async = es asincrónico (hace petición HTTP)
    // {int page = 1} = parámetro opcional, defecto 1
    // Devuelve Future<List<Movie>> = promesa de películas
    
    final response = await dio.get(
      // dio.get = petición HTTP GET
      // await = espera a que termine
      
      '/movie/now_playing',
      // Ruta a petición (relativa a baseUrl)
      // URL completa: https://api.themoviedb.org/3/movie/now_playing
      
      queryParameters: {
        'page': page
        // Parámetro adicional (además de los de BaseOptions)
        // ?page=1&api_key=xxxx&language=es-ES
      }
    );
    // response = respuesta HTTP
    
    return _jsonToMovies(response.data);
    // response.data = JSON de la respuesta
    // Convierte JSON → List<Movie>
  }
  
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    // Exactamente igual, pero ruta diferente
    
    final response = await dio.get('/movie/popular', 
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);    
  }

  // ... getTopRated, getUpcoming similares ...
}
```

**¿Qué pasa en orden?**
1. `getNowPlaying(page: 1)` se llama
2. `dio.get('/movie/now_playing', queryParameters: {page: 1})`
3. Se envía GET a `https://api.themoviedb.org/3/movie/now_playing?page=1&api_key=xxx&language=es-ES`
4. API devuelve JSON: `{"results": [{...}, {...}]}`
5. `_jsonToMovies()` convierte JSON → List<Movie>
6. Devuelve `List<Movie>`

---

## 🎯 infrastructure/mappers/movie_mapper.dart - Transformar Datos

```dart
import 'package:cinemapedia/domain/entities/movie.dart';
// Movie = entidad limpia

import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';
// MovieMovieDB = modelo crudo del JSON


// ===== CLASE CON MÉTODOS ESTÁTICOS =====
class MovieMapper {
  // Solo tiene métodos estáticos (no se instancia)
  // Es como una "caja de herramientas" de conversiones
  
  
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
    // Método estático: se llama como MovieMapper.movieDBToEntity()
    // Recibe: MovieMovieDB (crudo del JSON)
    // Devuelve: Movie (entidad limpia)
    // => es sintaxis corta para "return"
    
    adult: moviedb.adult,
    // Copia directo (no necesita transformación)
    
    backdropPath: (moviedb.backdropPath != '') 
      // Si backdropPath NO está vacío
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }'
      // Entonces: añade el URL base + ruta relativa
      // Resultado: URL completa para descargar imagen
      // ${} = interpolación de strings (como template literals)
      
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg'
      // Si está vacío: usa imagen por defecto
    
    genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
    // genreIds es List<int> [28, 12, 878]
    // .map() convierte cada int → String
    // Result: List<String> ["28", "12", "878"]
    // (Aunque podría devolver directamente los ids como strings)
    
    id: moviedb.id,
    // Copia
    
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: moviedb.overview,
    popularity: moviedb.popularity,
    
    posterPath: (moviedb.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }'
      : 'https://www.movienewz.com/img/films/poster-holder.jpg',
    // Igual que backdropPath
    
    releaseDate: moviedb.releaseDate != null 
      ? moviedb.releaseDate! 
      : DateTime.now(),
    // Si releaseDate es null, usa fecha actual
    // ! = null assertion (dice "confía en mí, no es null")
    
    title: moviedb.title,
    video: moviedb.video,
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount
  );
}
```

**¿Por qué el Mapper es importante?**

**Antes (crudo del JSON):**
```dart
MovieMovieDB movie = MovieMovieDB(
  title: "Avatar",
  posterPath: "/abc123.jpg",  // Relativo, incompleto
  backdropPath: "",            // Vacío problemático
  releaseDate: null,           // Puede ser null
);
```

**Después (limpio con Mapper):**
```dart
Movie movie = Movie(
  title: "Avatar",
  posterPath: "https://image.tmdb.org/t/p/w500/abc123.jpg",  // URL completa
  backdropPath: "https://placeholder.com/image.jpg",          // Nunca null
  releaseDate: DateTime(2022, 12, 16),                        // Nunca null
);
```

---

## 👁️ presentation/views/movies/home_view.dart - Ver Datos

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ConsumerStatefulWidget = StatefulWidget + Riverpod

import 'package:cinemapedia/presentation/providers/providers.dart';
// Todos los providers
import 'package:cinemapedia/presentation/widgets/widgets.dart';
// Todos los widgets


// ===== WIDGET CON ESTADO Y RIVERPOD =====
class HomeView extends ConsumerStatefulWidget {
  // ConsumerStatefulWidget = puede usar ref.watch() y ref.read()
  // StatefulWidget = tiene estado local + initState()
  
  const HomeView({ super.key });

  @override
  HomeViewState createState() => HomeViewState();
  // Crea el estado del widget
}


// ===== ESTADO DEL WIDGET =====
class HomeViewState extends ConsumerState<HomeView> {
  // ConsumerState = tiene acceso a ref (Riverpod)
  
  @override
  void initState() {
    // Se ejecuta UNA VEZ cuando el widget se monta
    // PERFECTO para hacer peticiones iniciales
    
    super.initState();
    // Llama inicialiación de la clase padre
    
    // ⚡ PIDE DATOS CUANDO ABRE LA PANTALLA ⚡
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    // ref.read() = obtén el Notifier (no escuches cambios)
    // .notifier = accede al MoviesNotifier (no la lista)
    // .loadNextPage() = llama la función para descargar películas
    
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( topRatedMoviesProvider.notifier ).loadNextPage();
    ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
    // Mismo para otras categorías
  }


  @override
  Widget build(BuildContext context) {
    // Se ejecuta CADA VEZ que hay un cambio en un provider
    // o cuando el widget necesita rendericse
    
    // ===== ESCUCHA CAMBIOS =====
    final initialLoading = ref.watch(initialLoadingProvider);
    // ¿Estamos en la fase inicial de carga?
    // Si algún provider está vacío, initialLoading = true
    
    if ( initialLoading ) return const FullScreenLoader();
    // Mientras carga, muestra una pantalla de "Cargando..."
    // (spinner + fondo oscuro)
    
    final slideShowMovies = ref.watch( moviesSlideshowProvider );
    // Películas para el carrusel (5 películas destacadas)
    
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    // Películas en cines (lista que se completa)
    
    final popularMovies = ref.watch( popularMoviesProvider );
    // Películas populares
    
    final topRatedMovies = ref.watch( topRatedMoviesProvider );
    // Mejores valoradas
    
    final upcomingMovies = ref.watch( upcomingMoviesProvider );
    // Próximas películas
    
    // Cada ref.watch() hace que el Widget se reconstruya
    // si ese provider cambia


    return CustomScrollView(
      // CustomScrollView = permite SliverWidgets (scrolls complejos)
      
      slivers: [
        // Sliver = widget que se comporta bien en scroll
        
        const SliverAppBar(
          // Barra superior que se encoge al scroll
          
          floating: true,
          // Aparece cuando scrollea hacia arriba
          
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
            // Widget personalizado en la barra
          ),
        ),


        SliverList(
          // Lista deslizable
          delegate: SliverChildBuilderDelegate(
            // Constructor: construye items dinámicamente
            
            (context, index) {
              // index = posición en la lista (siempre 0 en este caso)
              // porque solo hay 1 item (una Column)
              
              return Column(
                // Una columna con TODAS las secciones
                children: [
            
                  MoviesSlideshow(
                    // Carrusel de películas destacadas
                    movies: slideShowMovies
                    // Pasa las películas del provider
                  ),
            
                  MovieHorizontalListview(
                    // Lista horizontal de películas en cines
                    
                    movies: nowPlayingMovies,
                    // Las películas del provider
                    
                    title: 'En cines',
                    subTitle: 'Lunes 20',
                    
                    loadNextPage: () =>
                      // Callback: se llama cuando scroll llega al final
                      ref.read(nowPlayingMoviesProvider.notifier)
                        .loadNextPage()
                      // Pide la siguiente página de películas
                  ),
            
                  MovieHorizontalListview(
                    movies: upcomingMovies,
                    title: 'Próximamente',
                    subTitle: 'En este mes',
                    loadNextPage: () =>
                      ref.read(upcomingMoviesProvider.notifier)
                        .loadNextPage()
                  ),
            
                  MovieHorizontalListview(
                    movies: popularMovies,
                    title: 'Populares',
                    loadNextPage: () =>
                      ref.read(popularMoviesProvider.notifier)
                        .loadNextPage()
                  ),
                ],
              );
            },
            
            childCount: 1,
            // Hay solo 1 item en la lista (la Column con todo)
          ),
        )
      ],
    );
  }
}
```

**¿Qué pasa en orden?**
1. HomeView se monta → `initState()`
2. `initState()` pide películas (4 peticiones HTTP simultáneamente)
3. Mientras llegan, `initialLoadingProvider = true` → muestra loader
4. Cuando llegan las películas, providers se actualizan
5. `ref.watch()` detecta cambios → widget se reconstruye
6. Se muestran las película en pantalla
7. Usuario scrollea → cuando llega al final
8. `MovieHorizontalListview` llama `loadNextPage()`
9. Pide más películas, actua.liza el estado
10. Más películas aparecen (scrolling infinito) ✅

---

## 📊 presentation/providers/movies/movie_info_provider.dart - Caché de Películas

```dart
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';


// ===== PROVIDER CON CACHÉ =====
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  // StateNotifierProvider<T, S>
  // T = MovieMapNotifier (clase que maneja el estado)
  // S = Map<String, Movie> (tipo del estado)
  
  final movieRepository = ref.watch( movieRepositoryProvider );
  // Obtiene el repository para llamar getMovieById
  
  return MovieMapNotifier(
    getMovie: movieRepository.getMovieById
    // Pasa la función para obtener películas por ID
  );
});


/*
  State es un Mapa (diccionario):
  {
    '505642': Movie(...),           // ID película → Película
    '505643': Movie(...),           // ID película → Película
    '505645': Movie(...),           // Cada película cacheada
    '501231': Movie(...),
  }
*/


// ===== TIPO DE DATO PERSONALIZADO =====
typedef GetMovieCallback = Future<Movie>Function(String movieId);
// Función que recibe un ID y devuelve una Película


// ===== CLASE QUE MANEJA EL CACHÉ =====
class MovieMapNotifier extends StateNotifier<Map<String,Movie>> {
  // Extiende StateNotifier<T> donde T = Map<String, Movie>
  // T = es un mapa que cachea películas por ID
  
  final GetMovieCallback getMovie;
  // Función para obtener película de la API
  
  MovieMapNotifier({
    required this.getMovie,
  }): super({});
  // super({}) = estado inicial = mapa vacío


  Future<void> loadMovie( String movieId ) async {
    // Carga una película específica por ID
    
    if ( state[movieId] != null ) return;
    // ⚡ CACHÉ: si ya tenemos esa película, no pedirla de nuevo
    // Si state['505642'] existe, no hace petición HTTP
    
    final movie = await getMovie( movieId );
    // Petición HTTP: obtiene la película de la API
    
    state = { 
      ...state,           // Expande el mapa anterior
      movieId: movie      // Añade/actualiza una entrada
    };
    // Actualiza el estado (notifica a listeners)
  }
}
```

**¿Cómo funciona el caché?**

**Vez 1: Usuario toca película 505642**
```dart
loadMovie('505642')
  ↓
state['505642'] == null    // No está en caché
  ↓
Pide a la API
  ↓
state = {'505642': Movie(...)}  // Cachea
```

**Vez 2: Usuario toca película 505642 de nuevo**
```dart
loadMovie('505642')
  ↓
state['505642'] != null    // YA ESTÁ EN CACHÉ
  ↓
return                      // NO pide a la API
  ↓
Instantáneo ⚡
```

Esto evita peticiones redundantes y hace la app más rápida.

---

## 🔐 config/constants/environment.dart - API Key

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
// flutter_dotenv = librería para leer .env


class Environment {
  // Clase con variables globales de configuración
  
  static String theMovieDbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay api key';
  // static = variable de clase (no de instancia)
  //   Se accede como Environment.theMovieDbKey (sin new)
  // dotenv.env = diccionario con variables del .env
  // ['THE_MOVIEDB_KEY'] = obtén el valor de esa clave
  // ?? 'No hay api key' = si es null, usa este valor por defecto
  
  // Resultado:
  // Si .env tiene: THE_MOVIEDB_KEY=xyz789
  // Entonces: theMovieDbKey = "xyz789"
  //
  // Si .env no existe/está vacío:
  // Entonces: theMovieDbKey = "No hay api key"
}
```

**¿Dónde se usa?**
```dart
// En moviedb_datasource.dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.themoviedb.org/3',
  queryParameters: {
    'api_key': Environment.theMovieDbKey,  // ← AQUÍ
    'language': 'es-ES'
  }
));

// La petición HTTP incluye: ?api_key=xyz789&language=es-ES
```

---

## 🎯 Resumen: Flujo de Una Función

Cuando llamas `ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()`:

```
1. ref.read(nowPlayingMoviesProvider.notifier)
   → Obtiene MoviesNotifier

2. .loadNextPage()
   → Ejecuta la función

3. if (isLoading) return;
   → Evita peticiones dobles

4. currentPage++
   → Página 1

5. await fetchMoreMovies(page: currentPage)
   → Llama movieRepository.getNowPlaying(page: 1)
   → que llama datasource.getNowPlaying(page: 1)
   → que hace GET a /movie/now_playing?page=1...
   → API devuelve JSON
   → convierte JSON → MovieMovieDB → Movie
   → devuelve List<Movie>

6. state = [...state, ...moreMovies]
   → Actualiza el estado (añade películas nuevas)
   → NOTIFICA a todos los widgets que hacen ref.watch()

7. isLoading = false
   → Permite siguientes peticiones

8. Los Widgets detectan cambio
   → Se reconstruyen automáticamente
   → Muestran las nuevas películas
```

---

¡Espero que esto ayude a entender el código! 🚀
