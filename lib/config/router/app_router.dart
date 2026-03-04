/// 🛣️ ENRUTADOR DE LA APP - app_router.dart
///
/// Aquí se definen todas las rutas (pantallas) de la aplicación.
/// Usa Go Router para manejar la navegación de forma moderna.
///
/// RUTAS DISPONIBLES:
/// - / → Redirige a /home/0
/// - /home/:page → HomeScreen (0=Películas, 1=Categorías, 2=Favoritas)
/// - /home/:page/movie/:id → MovieScreen (detalles de película)
///
/// PARÁMETROS:
/// :page = 0, 1 o 2 (qué vista mostrar en HomeScreen)
/// :id = ID de película (usada en MovieScreen)

import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart';

/// Router global de la aplicación
/// Es accesible desde cualquier parte con: GoRouter.of(context)
final appRouter = GoRouter(
  /// Ruta inicial cuando abre la app
  initialLocation: '/home/0',
  
  routes: [
    /// RUTA PRINCIPAL: Pantalla con navegación inferior
    GoRoute(
      path: '/home/:page',
      /// :page es un parámetro dinámico
      /// Ejemplos: /home/0, /home/1, /home/2
      
      name: HomeScreen.name,
      /// Nombre de la ruta (para usar con pushNamed)
      /// Así: GoRouter.of(context).pushNamed(HomeScreen.name)
      
      builder: (context, state) {
        /// Extrae el parámetro :page y lo convierte en int
        final pageIndex = int.parse( state.params['page'] ?? '0' );

        return HomeScreen( pageIndex: pageIndex );
        /// pageIndex = 0 → HomeView (películas)
        /// pageIndex = 1 → Categorías
        /// pageIndex = 2 → FavoritesView
      },
      
      routes: [
        /// RUTA ANIDADA: Detalle de película
        GoRoute(
          path: 'movie/:id',
          /// Ruta completa: /home/0/movie/505642
          /// :id es el ID de la película de TMDb
          
          name: MovieScreen.name,
          
          builder: (context, state) {
            final movieId = state.params['id'] ?? 'no-id';

            return MovieScreen( movieId: movieId );
            /// Abre pantalla de detalles de la película
          },
        ),
      ]
    ),

    /// RUTA RAÍZ: Redirección
    GoRoute(
      path: '/',
      /// Si alguien intenta ir a /, redirige automáticamente
      
      redirect: ( _ , __ ) => '/home/0',
      /// Esto asegura que siempre hay una pantalla válida
    ),
  ]
);
