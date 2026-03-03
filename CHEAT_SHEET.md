# ⚡ CHEAT SHEET - Referencia Rápida de Cinemapedia

Pegalo en tu escritorio o guarda como PDF. Copiar-pega cuando necesites.

---

## 📦 Estructura de Archivos (Dónde está todo)

```
lib/
├── main.dart                          ← INICIO aquí
├── config/
│   ├── constants/environment.dart     ← API key
│   ├── helpers/human_formats.dart     ← Funciones útiles
│   ├── router/app_router.dart         ← RUTAS
│   └── theme/app_theme.dart           ← COLORES
├── domain/                            ← CONTRATOS (interfaces)
│   ├── entities/    ← Clases puras
│   ├── datasources/ ← ¿De dónde vienen datos?
│   └── repositories/← ¿Qué operaciones hay?
├── infrastructure/                    ← IMPLEMENTACIÓN
│   ├── datasources/ ← HTTP calls reales
│   ├── models/      ← Estructura JSON cruda
│   ├── mappers/     ← JSON → Entity limpia
│   └── repositories/← Implementa contratos
└── presentation/                      ← UI
    ├── screens/     ← Pantallas completas
    ├── views/       ← Secciones de pantallas
    ├── widgets/     ← Componentes reutilizables
    └── providers/   ← ESTADO (Riverpod)
```

---

## 🔄 Flujo de Datos (Cómo viajan los datos)

```
┌──────────────┐
│ HomeView     │ ref.watch(provider)
└──────┬───────┘
       ↓
┌──────────────────┐
│ MoviesNotifier   │ ref.read(.notifier).loadNextPage()
│ (Riverpod)       │
└──────┬───────────┘
       ↓
┌──────────────────────┐
│ MovieRepository      │ repository.getNowPlaying()
└──────┬───────────────┘
       ↓
┌──────────────────────┐
│ MoviedbDatasource    │ dio.get('/movie/now_playing')
└──────┬───────────────┘
       ↓
┌──────────────────────┐
│ HTTP GET →           │ https://api.themoviedb.org/3/...
│ ← JSON response      │
└──────┬───────────────┘
       ↓
┌──────────────────────┐
│ MovieMovieDB model   │ JSON crudo parseado
└──────┬───────────────┘
       ↓
┌──────────────────────┐
│ MovieMapper          │ Convierte a Entity limpia
└──────┬───────────────┘
       ↓
┌──────────────────────┐
│ Movie entity         │ Objeto Dart puro
└──────┬───────────────┘
       ↓
┌──────────────────────┐
│ Provider state       │ state = [...state, ...movies]
│ actualizado          │
└──────┬───────────────┘
       ↓
┌──────────────────────┐
│ HomeView se redibuja │ Widget rebuild automático
└──────────────────────┘
```

---

## 🎯 Patrones Rápidos

### Pattern: Crear un nuevo Provider

```dart
// 1. En presentation/providers/movies/nombre_provider.dart

final miProvider = StateNotifierProvider<MiNotifier, List<Movie>>((ref) {
  final repo = ref.watch(movieRepositoryProvider);
  return MiNotifier(function: repo.miMetodo);
});

class MiNotifier extends StateNotifier<List<Movie>> {
  final Function function;
  
  MiNotifier({required this.function}) : super([]);
  
  Future<void> cargar() async {
    final data = await function();
    state = data;
  }
}

// 2. En presentation/views/archivo.dart
final miDato = ref.watch(miProvider);  // Escucha cambios
ref.read(miProvider.notifier).cargar(); // Pide datos
```

### Pattern: Hacer una petición HTTP

```dart
// En infrastructure/datasources/mi_datasource.dart

class MiDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.ejemplo.com',
    queryParameters: {
      'api_key': Environment.apiKey,
    }
  ));

  Future<List<T>> obtener() async {
    try {
      final response = await dio.get('/endpoint');
      // Parse JSON
      return convertir(response.data);
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
```

### Pattern: Mapear datos

```dart
// En infrastructure/mappers/mi_mapper.dart

class MiMapper {
  static Entity modelToEntity(Model model) => Entity(
    campo1: model.campo1,
    campo2: model.campo2 != null 
      ? 'https://...' + model.campo2 
      : 'https://default.jpg',
  );
}
```

### Pattern: Guardar en caché

```dart
// En el Notifier o Provider

Map<String, Entity> cache = {};

Future<void> cargar(String id) async {
  if (cache[id] != null) return; // Ya está
  
  final data = await repository.obtener(id);
  cache[id] = data;
  state = {...state, ...{id: data}};
}
```

---

## 💻 Snippets de Código

### Navegar a otra pantalla

```dart
// Push (ir adelante)
GoRouter.of(context).push('/home/0/movie/505642');

// PushNamed (usar nombre de ruta)
GoRouter.of(context).pushNamed(
  MovieScreen.name,
  params: {'id': '505642'}
);

// Go (reemplazar pantalla actual)
GoRouter.of(context).go('/home/1');

// Pop (volver)
context.pop();
```

### Escuchar Providers en Widget

```dart
// ConsumerWidget (sin estado)
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(provider);
    return Text(data.toString());
  }
}

// ConsumerStatefulWidget (con estado)
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => MyState();
}

class MyState extends ConsumerState<MyScreen> {
  @override
  void initState() {
    ref.read(provider.notifier).cargar();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(provider);
    return Text(data.toString());
  }
}
```

### Manejo de errores HTTP

```dart
try {
  final response = await dio.get('/endpoint');
  return parsear(response.data);
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    throw Exception('Conexión perdida');
  } else if (e.response?.statusCode == 401) {
    throw Exception('No autorizado');
  }
  rethrow;
}
```

### Parsear JSON a Objetos

```dart
// Usando factory pattern
class Movie {
  final int id;
  final String title;
  
  Movie({required this.id, required this.title});
  
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json['id'],
    title: json['title'] ?? 'Sin título',
  );
}

// Uso:
final movie = Movie.fromJson(jsonData);
```

### Mostrar un loader mientras carga

```dart
final isLoading = ref.watch(initialLoadingProvider);
if (isLoading) {
  return Center(child: CircularProgressIndicator());
}

// O un full screen loader
if (isLoading) return const FullScreenLoader();

// Datos cuando termina
return ListView(children: items);
```

---

## 🔑 Importaciones Más Usadas

```dart
// Flutter
import 'package:flutter/material.dart';

// Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Go Router
import 'package:go_router/go_router.dart';

// Dio (HTTP)
import 'package:dio/dio.dart';

// flutter_dotenv
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Rutas de tu proyecto
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';
```

---

## 📝 Convenciones de Nombres

```
Carpetas:       lowercase_with_underscores
Archivos:       lowercase_with_underscores.dart

Clases:         PascalCase
  - Widgets:        MyWidget
  - Notifiers:      MyNotifier
  - Entities:       Movie
  - Models:         MovieMovieDB
  - Mappers:        MovieMapper

Funciones:      camelCase
  - Públicas:       myFunction()
  - Privadas:       _myPrivateFunction()

Variables:      camelCase
  - Constantes:     const MY_CONST = 123
  - Providers:      myProvider
  - States:         myState

Archivos:       
  - Providers:      nombre_provider.dart
  - Screens:        nombre_screen.dart
  - Widgets:        nombre_widget.dart
  - Models:         nombre_model.dart
```

---

## ⚙️ Configuración Común

### Cambiar el color principal

```dart
// En config/theme/app_theme.dart
ThemeData getTheme() => ThemeData(
  useMaterial3: true,
  colorSchemeSeed: const Color(0xFFFF0000) // Rojo
);
```

### Cambiar idioma de películas

```dart
// En datasources
queryParameters: {
  'language': 'pt-BR'  // Cambia aquí
}
```

### Cambiar ruta inicial

```dart
// En config/router/app_router.dart
final appRouter = GoRouter(
  initialLocation: '/home/1' // Cambia aquí
);
```

### Cambiar API key

```
// En .env
THE_MOVIEDB_KEY=TU_API_KEY_AQUI
```

---

## 🐛 Debugging Rápido

### Problema: "Widget no se actualiza"
```dart
//❌ Mal: ref.read() no escucha cambios
final data = ref.read(provider);

//✅ Bien: ref.watch() escucha cambios
final data = ref.watch(provider);
```

### Problema: "Petición HTTP infinita"
```dart
//❌ Mal: loadData() en build() → loop infinito
@override
Widget build(...) {
  repository.loadData(); // Ejecuta cada rebuild
}

//✅ Bien: en initState() → solo una vez
@override
void initState() {
  ref.read(provider.notifier).loadData();
}
```

### Problema: "API key == null"
```dart
// Verifica que .env existe y main() hace:
await dotenv.load(fileName: '.env');

// Y que .gitignore contiene:
.env
```

### Problema: "Type mismatch: String vs dynamic"
```dart
//❌ Mal
final id = state.params['id'];

//✅ Bien: Cast explícito
final id = state.params['id'] as String;
```

### Ver logs de Dio

```dart
final dio = Dio(BaseOptions(...));
dio.interceptors.add(LoggingInterceptor()); // Ver requests
```

---

## 📊 Tabla de Responsabilidades

| Carpeta/Archivo | Responsabilidad | Puede usar | No puede usar |
|---|---|---|---|
| domain/ | Contratos puros | nada | Infrastructure, Presentation |
| infrastructure/ | Implementar contratos | domain | Presentation |
| presentation/ | Mostrar UI | domain, infrastructure | nada |
| config/ | Configuración global | nada | ... (depende) |

---

## 🎯 Checklist: Antes de hacer Push

- [ ] El app compila sin errores
- [ ] No hay console warnings (build / lint)
- [ ] Las peticiones HTTP funcionan
- [ ] Los datos se muestran en pantalla
- [ ] No hay variables no usadas
- [ ] Nombres siguen convención
- [ ] .env NO está en GIT
- [ ] Código está formateado (dart format)

---

## 🚀 Comandos Útiles de Terminal

```bash
# Correr la app
flutter run

# Correr en web
flutter run -d chrome

# Build para Android/iOS
flutter build apk
flutter build ios

# Limpiar cache
flutter clean

# Obtener dependencias
flutter pub get

# Formatear código
dart format lib/

# Analizar código
dart analyze

# Ver estructura
flutter analyze --watch
```

---

## 📚 Links Importantes

```
The Movie DB API:
https://www.themoviedb.org/settings/api

Riverpod Docs:
https://riverpod.dev/

Go Router Docs:
https://pub.dev/packages/go_router

Dio Package:
https://pub.dev/packages/dio

Dart Docs:
https://dart.dev/guides
```

---

## 💡 Tips Avanzados

### 1. Usar extension methods

```dart
// Extensión en Movie para casos de uso
extension MovieX on Movie {
  String get shortTitle => title.length > 20 
    ? '${title.substring(0, 20)}...' 
    : title;
}

// Uso:
Text(movie.shortTitle)
```

### 2. Usar combine providers

```dart
final listaFiltradaProvider = Provider((ref) {
  final todasLasPeliculas = ref.watch(todosProvider);
  final filtro = ref.watch(filtroProvider);
  
  return todasLasPeliculas
    .where((p) => p.titulo.contains(filtro))
    .toList();
});
```

### 3. Usar select para optimizar rebuilds

```dart
// Sin select: rebuild si CUALQUIER cosa change
final user = ref.watch(userProvider);

// Con select: rebuild SÓ si cambia el nombre
final nombre = ref.watch(userProvider.select((user) => user.name));
```

---

## ⏱️ Timing Reference

| Tarea | Tiempo |
|------|--------|
| Entender estructura | 10 min |
| Seguir un flujo | 30 min |
| Hacer cambio pequeño | 5-10 min |
| Añadir feature nueva | 30-60 min |
| Debuggear error | 15-30 min |

---

## 🎓 Próximo Paso Después de Esto

1. Lee la guía completa
2. Haz los ejercicios
3. Crea tu propio proyecto con esta arquitectura
4. ¡Enseña a otros!

---

**Imprime esto o guarda como PDF** 📄

Última actualización: Marzo 2026

¡Buena suerte! 🚀
