import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

/// ================================================================================
/// VIEW: VISTA PRINCIPAL CON LISTAS DE PELÍCULAS
/// ================================================================================
/// 
/// HomeView es un ConsumerStatefulWidget que muestra 4 categorías de películas
/// en un CustomScrollView con listas horizontales. Es la vista principal después
/// del login/splash.
/// 
/// RESPONSABILIDAD:
/// - Inicializar la carga de 4 categorías en initState
/// - Mostrar indicador de carga mientras llegan datos
/// - Mostrar listas horizontales de película por categoría
/// - Detectar scroll al final (infinite scroll) para cargar más películas
/// 
/// CATEGORÍAS MOSTRADAS:
/// 1. En cines (nowPlaying): Películas actualmente en salas
/// 2. Próximamente (upcoming): Estrenos próximos
/// 3. Populares: Películas con mayor público
/// 4. Mejor valoradas (topRated): Mejor puntuadas
/// 
/// FLUJO DE DATOS:
/// 1. initState() llama loadNextPage() en 4 providers
/// 2. Cada provider trae página 1 del API (máx ~20 películas)
/// 3. initialLoadingProvider detecta cambios y muestra FullScreenLoader si carga
/// 4. build() renders CustomScrollView con MoviesSlideshow + 4 MovieHorizontalListview
/// 5. Al scroll a final de lista, loadNextPage() trae página siguiente
/// 6. Riverpod actualiza estado y redibuja automáticamente
/// 
class HomeView extends ConsumerStatefulWidget {
  const HomeView({ super.key });

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {

  @override
  void initState() {
    super.initState();
    
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( topRatedMoviesProvider.notifier ).loadNextPage();
    ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
  }


  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);
    if ( initialLoading ) return const FullScreenLoader();
    
    final slideShowMovies = ref.watch( moviesSlideshowProvider );
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final popularMovies = ref.watch( popularMoviesProvider );
    final topRatedMovies = ref.watch( topRatedMoviesProvider );
    final upcomingMovies = ref.watch( upcomingMoviesProvider );

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