import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart';

/// ================================================================================
/// CONFIGURACIÓN DE RUTAS (NAVIGATION)
/// ================================================================================
/// 
/// GoRouter es un sistema de navegación similar a las URLs en un sitio web.
/// Cada ruta tiene:
/// - path: La "dirección" (ejemplo: /home/0, /home/0/movie/505642)
/// - builder: El widget que se muestra cuando se navega a esa ruta
/// - routes: Sub-rutas anidadas
/// 
/// Ventajas sobre Navigator tradicional:
/// - URLs predecibles (como en web)
/// - Manejo de deep links (enlace directos a pantallas)
/// - Más fácil de testear
/// 
/// ESTRUCTURA:
/// /home/:page
///   ├── /home/0 (HomeScreen - inicio)
///   ├── /home/1 (HomeScreen - categorías)
///   ├── /home/2 (HomeScreen - favoritos)
///   └── /home/:page/movie/:id (MovieScreen - detalles de película)
/// 
final appRouter = GoRouter(
  // La primera ruta que se carga al iniciar la app
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:page', // :page es un parámetro dinámico
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.params['page'] ?? '0');
        return HomeScreen(pageIndex: pageIndex);
      },
      routes: [
        // Ruta anidada: Solo accesible desde /home/:page
        GoRoute(
          path: 'movie/:id', // URL completa: /home/:page/movie/:id
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.params['id'] ?? 'no-id';
            return MovieScreen(movieId: movieId);
          },
        ),
      ],
    ),

    // Ruta 404 / redireccionamiento
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0', // Si alguien va a /, redirige a /home/0
    ),
  ],
);