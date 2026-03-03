import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/views/views.dart';

/// ================================================================================
/// SCREEN: PANTALLA PRINCIPAL CON NAVEGACIÓN INFERIOR
/// ================================================================================
/// 
/// HomeScreen es un StatelessWidget que actúa como contenedor principal
/// de la app. Gestiona la navegación entre 3 vistas usando IndexedStack
/// y CustomBottomNavigation.
/// 
/// RESPONSABILIDAD:
/// - Mostrar una de 3 vistas según el índice de página
/// - Mantener la bottom navigation sincronizada
/// - Preservar estado de cada vista (IndexedStack las mantiene en memoria)
/// 
/// ESTRUCTURA:
/// - Recibe pageIndex por parámetro (0=Home, 1=Categorías, 2=Favoritos)
/// - IndexedStack mantiene todas las vistas cargadas pero solo muestra una
/// - CustomBottomNavigation permite cambiar entre pestañas
/// 
/// VISTAS DISPONIBLES:
/// 1. HomeView (index=0): Listados de películas (Ahora, Próximas, Populares, Top Rated)
/// 2. CategoriesView (index=1): Placeholder de categorías (SizedBox.expand())
/// 3. FavoritesView (index=2): Películas marcadas como favorito
/// 
/// FLUJO DE DATOS:
/// Router -> HomeScreen(pageIndex: 0) 
///       -> Scaffold con IndexedStack
///       -> HomeView / CategoriesView / FavoritesView
/// 
class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({
    super.key, 
    required this.pageIndex
  });

  final viewRoutes =  const <Widget>[
    HomeView(),
    SizedBox(), // <--- categorias View
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation( currentIndex: pageIndex ),
    );
  }
}

