/// 🏠 VISTA PRINCIPAL - home_view.dart
///
/// Pantalla principal de la app mostrando:
/// - Carrusel de películas destacadas (Slideshow)
/// - 4 secciones horizontales:
///   1. En cartelera ahora
///   2. Populares
///   3. Mejor puntuadas
///   4. Próximos estrenos
///
/// PATRÓN:
/// - ConsumerStatefulWidget: Para usar ambos initState y ref.watch()
/// - initState: Carga INICIAL de todas las categorías
/// - ref.watch(): Escucha cambios en providers (datos)
/// - build trae datos de providers y muestra widgets
///
/// FLUJO:
/// 1. HomePage llama HomeView (esta clase)
/// 2. initState carga primera página de cada categoría
/// 3. ref.watch() monitorea si los providers cambian
/// 4. Cuando cargas más (scroll), MoviesList llama loadNextPage
/// 5. Widget se reconstruye con más películas

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

/// Vista principal de la app
/// Muestra 4 categorías de películas + carrusel destacado
class HomeView extends ConsumerStatefulWidget {
  const HomeView({ super.key });

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  
  /// CARGA INICIAL: Primera página de cada categoría
  /// Esto se ejecuta UNA SOLA VEZ cuando el widget se monta
  @override
  void initState() {
    super.initState();
    
    /// ref.read() obtiene el notifier (gestor de estado) sin escuchar cambios
    /// .notifier asegura que obtenemos el MoviesNotifier
    /// .loadNextPage() trae página 1 de la API
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( topRatedMoviesProvider.notifier ).loadNextPage();
    ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    /// Estado: ¿Estamos cargando datos INICIALES?
    final initialLoading = ref.watch(initialLoadingProvider);
    if ( initialLoading ) return const FullScreenLoader();
    
    /// Escucha TODOS los providers de películas
    /// Cuando cambian = widget se reconstruye
    final slideShowMovies = ref.watch( moviesSlideshowProvider );
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final popularMovies = ref.watch( popularMoviesProvider );
    final topRatedMovies = ref.watch( topRatedMoviesProvider );
    final upcomingMovies = ref.watch( upcomingMoviesProvider );

    /// CustomScrollView: Scroll eficiente con SliverWidgets
    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),


        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index) {
              return Column(
                  children: [
              
                    // const CustomAppbar(),
              
                    MoviesSlideshow(movies: slideShowMovies ),
              
                    MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: 'En cines',
                      subTitle: 'Lunes 20',
                      loadNextPage: () =>ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
                      
                    ),
              
                    MovieHorizontalListview(
                      movies: upcomingMovies,
                      title: 'Próximamente',
                      subTitle: 'En este mes',
                      loadNextPage: () =>ref.read(upcomingMoviesProvider.notifier).loadNextPage()
                    ),
              
                    MovieHorizontalListview(
                      movies: popularMovies,
                      title: 'Populares',
                      // subTitle: '',
                      loadNextPage: () =>ref.read(popularMoviesProvider.notifier).loadNextPage()
                    ),
              
                    MovieHorizontalListview(
                      movies: topRatedMovies,
                      title: 'Mejor calificadas',
                      subTitle: 'Desde siempre',
                      loadNextPage: () =>ref.read(topRatedMoviesProvider.notifier).loadNextPage()
                    ),

                    const SizedBox( height: 10 ),
              
              
                  ],
                );
          },
          childCount: 1
        )),

      ]
    );
  }
}