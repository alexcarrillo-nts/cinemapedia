/// 📱 PUNTO DE ENTRADA DE LA APP - main.dart
///
/// Este archivo es el punto de inicio de toda la aplicación.
/// Aquí se cargan las variables de entorno y se configura Riverpod,
/// el router (navegación) y el tema visual.
///
/// FLUJO:
/// 1. main() carga el archivo .env con la API key
/// 2. ProviderScope envuelve la app para habilitar Riverpod
/// 3. MainApp() se renderiza con MaterialApp.router
/// 4. appRouter navega a la pantalla inicial (/home/0)

import 'package:flutter/material.dart';

import 'package:cinemapedia/config/router/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Función main - La entrada oficial de Flutter
/// 'async' porque cargar .env puede tardar (es asincrónico)
Future<void> main() async{

  /// Carga el archivo .env que contiene variables privadas (API keys, etc)
  /// Archivo .env contiene: THE_MOVIEDB_KEY=xxx
  /// Este archivo NO debe estar en GIT (está en .gitignore)
  await dotenv.load(fileName: '.env');

  runApp(
    /// ProviderScope - Habilita Riverpod en toda la app
    /// Sin esto, ref.watch() y ref.read() no funcionarían
    /// Este es el contenedor que proporciona todos los Providers
    const ProviderScope(child: MainApp() )
  );
}

/// Widget raíz de la aplicación
/// StatelessWidget = no tiene estado local (el estado es global con Riverpod)
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      /// MaterialApp.router usa Go Router para navegación
      /// (NO es MaterialApp normal, es la versión con router)
      
      routerConfig: appRouter,
      /// Rutas definidas en config/router/app_router.dart
      /// Ruta inicial: /home/0 (pantalla principal)
      /// Ruta anidada: /home/0/movie/:id (detalle de película)
      
      debugShowCheckedModeBanner: false,
      /// Quita la cinta "DEBUG" que aparece en esquina superior derecha
      
      theme: AppTheme().getTheme(),
      /// Tema visual de Material 3
      /// Color principal: azul (#2862F5)
      /// Tipografía y estilos definidos en config/theme/app_theme.dart
    );
  }
}
