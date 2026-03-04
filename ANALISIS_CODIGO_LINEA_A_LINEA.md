# � ÍNDICE DE ARCHIVOS - Guía Rápida por Archivo

Esta página es tu **MAP** para navegar el código de la app. Cada archivo tiene **comentarios doc en el código** que explican qué hace y por qué.

## ✨ Cambio Importante: Documentación en el Código

En lugar de explicaciones largas en este documento, ahora encontrarás **comentarios profesionales** directamente en cada archivo Dart. Cuando abras un archivo:

1. **Encabezado (primeras líneas)**: Explica QUÉ es el archivo
2. **Comentarios inline**: Explican el CÓMO y el POR QUÉ
3. **Doc comments** (///): Documentación de clases y métodos

**Ventaja**: La documentación viaja CON el código. Nunca te quedarás sin saber qué hace una línea.

---

## 🎯 Estructura Rápida

Haz Ctrl+Click en cualquier enlace para ir directamente al archivo.

---

## 🎯 Estructura Rápida

```
lib/
├── main.dart                          ← INICIO aquí
├── config/
│   ├── constants/environment.dart     
│   ├── helpers/human_formats.dart     
│   ├── router/app_router.dart         ← RUTAS
│   └── theme/app_theme.dart           
├── domain/                            ← CONTRATOS (interfaces)
│   ├── entities/
│   │   ├── movie.dart
│   │   └── actor.dart
│   ├── datasources/
│   │   ├── movies_datasource.dart
│   │   └── actors_datasource.dart
│   └── repositories/
│       ├── movies_repository.dart
│       └── actors_repository.dart
├── infrastructure/                    ← IMPLEMENTACIÓN
│   ├── datasources/
│   │   ├── moviedb_datasource.dart
│   │   └── actor_moviedb_datasource.dart
│   ├── models/
│   │   └── moviedb/
│   │       ├── movie_moviedb.dart
│   │       ├── moviedb_response.dart
│   │       ├── movie_details.dart
│   │       └── credits_response.dart
│   ├── mappers/
│   │   ├── movie_mapper.dart
│   │   └── actor_mapper.dart
│   └── repositories/
│       ├── movie_repository_impl.dart
│       └── actor_repository_impl.dart
└── presentation/                      ← UI
    ├── screens/
    │   └── movies/
    │       ├── home_screen.dart
    │       └── movie_screen.dart
    ├── views/
    │   └── movies/
    │       ├── home_view.dart
    │       └── favorites_view.dart
    ├── widgets/
    │   ├── movies/
    │   │   ├── movies_slideshow.dart
    │   │   └── movie_horizontal_listview.dart
    │   └── shared/
    └── providers/
        ├── movies/
        │   ├── movies_repository_provider.dart
        │   ├── movies_providers.dart
        │   ├── initial_loading_provider.dart
        │   ├── movies_slideshow_provider.dart
        │   └── movie_info_provider.dart
        └── actors/
            ├── actors_repository_provider.dart
            └── actors_by_movie_provider.dart
```

---

## 🔴 CONFIGURACIÓN (config/)

### [main.dart](lib/main.dart)
**INICIO DE LA APP**

Qué hace:
- Carga variables de entorno (.env)
- Inicia Flutter con Riverpod
- Configura tema y rutas
- Navega a pantalla inicial

---

### [app_router.dart](lib/config/router/app_router.dart)
**DEFINICIÓN DE RUTAS**

Qué hace:
- Define todas las rutas de navegación
- Pantalla inicial: `/home/0`
- Rutas anidadas: `/home/:page/movie/:id`
- Redirecciones

---

### [app_theme.dart](lib/config/theme/app_theme.dart)
**TEMA VISUAL**

Qué hace:
- Define colores (Material 3)
- Define tipografía
- Aplica a toda la app

---

### [environment.dart](lib/config/constants/environment.dart)
**VARIABLES GLOBALES**

Qué hace:
- Carga API key desde `.env`
- Proporciona const globales

---

### [human_formats.dart](lib/config/helpers/human_formats.dart)
**FUNCIONES DE FORMATO**

Qué hace:
- Formatea fechas
- Formatea números
- Funciones auxiliares

---

## 🟠 LÓGICA DE NEGOCIO (domain/)

### [movie.dart](lib/domain/entities/movie.dart)
**ENTIDAD PELÍCULA**

Qué hace:
- Define estructura de una película
- Campos: id, título, descripción, rating, etc.
- Es una clase pura (sin lógica)

---

### [actor.dart](lib/domain/entities/actor.dart)
**ENTIDAD ACTOR**

Qué hace:
- Define estructura de un actor
- Campos: id, nombre, foto, personaje

---

### [movies_datasource.dart](lib/domain/datasources/movies_datasource.dart)
**CONTRATO: "¿De dónde obtenemos películas?"**

Qué hace:
- Define interfaz abstracta
- Métodos que deben implementarse:
  - getNowPlaying()
  - getPopular()
  - getTopRated()
  - getUpcoming()
  - getMovieById()
  - searchMovies()

---

### [actors_datasource.dart](lib/domain/datasources/actors_datasource.dart)
**CONTRATO: "¿De dónde obtenemos actores?"**

Qué hace:
- Define interfaz abstracta
- Método: getActorsByMovie()

---

### [movies_repository.dart](lib/domain/repositories/movies_repository.dart)
**CONTRATO: "¿Qué operaciones hace la app con películas?"**

Qué hace:
- Define interfaz abstracta
- Métodos públicos de la app

---

### [actors_repository.dart](lib/domain/repositories/actors_repository.dart)
**CONTRATO: "¿Qué operaciones hace la app con actores?"**

---

## 🟡 IMPLEMENTACIÓN HTTP (infrastructure/)

### [moviedb_datasource.dart](lib/infrastructure/datasources/moviedb_datasource.dart)
**OBTIENE PELÍCULAS DE LA API**

Qué hace:
- Hace peticiones HTTP a themoviedb.org
- Parsea JSON a objetos Dart
- Usa Mapper para limpiar datos
- Implementa contrato de domain/datasources

---

### [actor_moviedb_datasource.dart](lib/infrastructure/datasources/actor_moviedb_datasource.dart)
**OBTIENE ACTORES DE LA API**

---

### [movie_moviedb.dart](lib/infrastructure/models/moviedb/movie_moviedb.dart)
**MODELO: Película cruda de API**

Qué hace:
- Estructura de JSON sin procesar
- Contiene método fromJson()
- Tiene todos los campos de la API

---

### [moviedb_response.dart](lib/infrastructure/models/moviedb/moviedb_response.dart)
**MODELO: Respuesta paginada de API**

Qué hace:
- Parsea respuesta paginada
- Contiene List<MovieMovieDB>

---

### [movie_details.dart](lib/infrastructure/models/moviedb/movie_details.dart)
**MODELO: Detalles completos de película**

Qué hace:
- Estructura de película con info adicional
- Más campos que MovieMovieDB

---

### [credits_response.dart](lib/infrastructure/models/moviedb/credits_response.dart)
**MODELO: Respuesta de actores de una película**

Qué hace:
- Parsea lista de actores/cast
- Contiene List<Cast>

---

### [movie_mapper.dart](lib/infrastructure/mappers/movie_mapper.dart)
**CONVIERTE: MovieMovieDB → Movie limpia**

Qué hace:
- Transforma datos crudos en entidades limpias
- Arregla URLs (agrega dominio)
- Maneja valores null
- Método: movieDBToEntity()

---

### [actor_mapper.dart](lib/infrastructure/mappers/actor_mapper.dart)
**CONVIERTE: Cast → Actor limpia**

Qué hace:
- Transforma actores crudos
- Arregla URLs de fotos
- Método: castToEntity()

---

### [movie_repository_impl.dart](lib/infrastructure/repositories/movie_repository_impl.dart)
**IMPLEMENTA: MovieRepository (del domain)**

Qué hace:
- Implementa interfaz de domain/repositories
- Delega operaciones al datasource
- Punto medio entre business logic y datos

---

### [actor_repository_impl.dart](lib/infrastructure/repositories/actor_repository_impl.dart)
**IMPLEMENTA: ActorsRepository (del domain)**

---

## 🟢 INTERFAZ DE USUARIO (presentation/)

### [home_screen.dart](lib/presentation/screens/movies/home_screen.dart)
**PANTALLA PRINCIPAL**

Qué hace:
- Pantalla completa con navegación
- IndexedStack con 3 vistas
- BottomNavigationBar
- Alterna entre Home, Categorías, Favoritas

---

### [movie_screen.dart](lib/presentation/screens/movies/movie_screen.dart)
**PANTALLA DE DETALLES**

Qué hace:
- Muestra detalles de una película
- CustomScrollView (scroll complejo)
- SliverAppBar (barra que se encoge)
- Información de película + actores

---

### [home_view.dart](lib/presentation/views/movies/home_view.dart)
**VISTA PRINCIPAL (lista de películas)**

Qué hace:
- Pide películas al iniciar (initState)
- Watch a 4 providers
- Muestra:
  - Slideshow (carrusel)
  - Películas en cines
  - Próximamente
  - Populares
  - Top valoradas
- Implements scroll infinito

---

### [favorites_view.dart](lib/presentation/views/movies/favorites_view.dart)
**VISTA DE FAVORITAS**

---

### [movies_slideshow.dart](lib/presentation/widgets/movies/movies_slideshow.dart)
**WIDGET: Carrusel de películas**

---

### [movie_horizontal_listview.dart](lib/presentation/widgets/movies/movie_horizontal_listview.dart)
**WIDGET: Lista horizontal scrolleable**

Qué hace:
- Muestra películas en fila horizontal
- Detecta scroll al final
- Llama callback para cargar más

---

## 🔵 GESTIÓN DE ESTADO (presentation/providers/)

### [movies_repository_provider.dart](lib/presentation/providers/movies/movies_repository_provider.dart)
**PROVIDER: Repository inmutable**

Qué hace:
- Crea instancia de MovieRepositoryImpl
- Proporciona acceso a repository
- Usado por otros providers

---

### [movies_providers.dart](lib/presentation/providers/movies/movies_providers.dart)
**PROVIDER: Estados de películas**

Qué hace:
- Define 4 providers (nowPlaying, popular, topRated, upcoming)
- Cada uno maneja su propia lista con pagination
- Clase MoviesNotifier con loadNextPage()

---

### [initial_loading_provider.dart](lib/presentation/providers/movies/initial_loading_provider.dart)
**PROVIDER: ¿Estamos cargando?**

Qué hace:
- Devuelve true si algún provider está vacío
- Usado para mostrar loader inicial

---

### [movies_slideshow_provider.dart](lib/presentation/providers/movies/movies_slideshow_provider.dart)
**PROVIDER: Películas para slideshow**

Qué hace:
- Selecciona 5 películas random
- Para carrusel de inicio

---

### [movie_info_provider.dart](lib/presentation/providers/movies/movie_info_provider.dart)
**PROVIDER: Caché de películas por ID**

Qué hace:
- Almacena películas en Map<ID, Movie>
- Evita peticiones repetidas
- Clase MovieMapNotifier con loadMovie()

---

### [actors_repository_provider.dart](lib/presentation/providers/actors/actors_repository_provider.dart)
**PROVIDER: Repository de actores**

Qué hace:
- Crea instancia ActorRepositoryImpl
- Similar a movies_repository_provider

---

### [actors_by_movie_provider.dart](lib/presentation/providers/actors/actors_by_movie_provider.dart)
**PROVIDER: Caché de actores por película**

Qué hace:
- Almacena actores en Map<movieID, List<Actor>>
- Evita peticiones repetidas
- Clase ActorsByMovieNotifier con loadActors()

---

## 🔀 Flujo completo de datos

```
Usuario abre app
        ↓
home_view.dart (initState)
        ↓
ref.read(provider.notifier).loadNextPage()
        ↓
MoviesNotifier.loadNextPage() [movies_providers.dart]
        ↓
repository.getNowPlaying() [movie_repository_impl.dart]
        ↓
datasource.getNowPlaying() [moviedb_datasource.dart]
        ↓
Dio.get() → API
        ↓
JSON response
        ↓
MovieMovieDB model [movie_moviedb.dart]
        ↓
MovieMapper.movieDBToEntity() [movie_mapper.dart]
        ↓
Movie entity [movie.dart]
        ↓
state actualizado [movies_providers.dart]
        ↓
home_view.dart detecta cambio (ref.watch)
        ↓
Widget rebuild
        ↓
Usuario ve películas
```

---

## 📍 Dónde está cada responsabilidad

| Responsabilidad | Archivo |
|---|---|
| Inicio app | [main.dart](lib/main.dart) |
| Rutas | [app_router.dart](lib/config/router/app_router.dart) |
| Tema | [app_theme.dart](lib/config/theme/app_theme.dart) |
| API key | [environment.dart](lib/config/constants/environment.dart) |
| Contratos | domain/datasources/, domain/repositories/ |
| HTTP | [moviedb_datasource.dart](lib/infrastructure/datasources/moviedb_datasource.dart) |
| Parseo JSON | infrastructure/models/ |
| Transformación | infrastructure/mappers/ |
| Implementación | infrastructure/repositories/ |
| Pantallas | presentation/screens/ |
| Vistas | presentation/views/ |
| Componentes | presentation/widgets/ |
| Estado | presentation/providers/ |

---

## 🎯 Cómo entender un archivo

1. **Abre el archivo** con Ctrl+Click en el link
2. **Lee los comentarios** que están en el código
3. **Mira qué importa** (imagina el flujo)
4. **Entiende qué devuelve** (output)

---

¡Usa los links para navegar rápidamente! 🚀
