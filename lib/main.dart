import 'package:flutter/material.dart';

import 'package:cinemapedia/config/router/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ================================================================================
/// PUNTO DE ENTRADA DE LA APLICACIÓN
/// ================================================================================
/// 
/// La función main() es el primer código que ejecuta Flutter.
/// 
/// 1. dotenv.load() - Carga las variables de entorno desde el archivo '.env'
///    Esto incluye la API Key de The Movie Database que es sensible
///    y no debe estar en el código.
/// 
/// 2. ProviderScope - Envuelve la aplicación para activar Riverpod.
///    Sin ProviderScope, los providers no funcionarían.
///    Es como encender el "sistema de gestión de estado".
/// 
/// 3. MainApp - El widget raíz que configura MaterialApp con el router.
/// 
Future<void> main() async{

  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(child: MainApp() )
  );
}

/// ================================================================================
/// WIDGET RAÍZ DE LA APLICACIÓN
/// ================================================================================
/// 
/// MainApp es un StatelessWidget (sin estado propio) que configura
/// la aplicación principal.
/// 
/// - MaterialApp.router: Usa GoRouter para navegación moderna
///   (similar a navegación web, no al Navigator tradicional)
/// 
/// - routerConfig: appRouter define todas las rutas de la app
///   (ver lib/config/router/app_router.dart)
/// 
/// - theme: Aplica un tema visual consistente (colores, formas, etc.)
///   (ver lib/config/theme/app_theme.dart)
/// 
/// - debugShowCheckedModeBanner: false desactiva la cinta "Debug"
///   que aparece en la esquina superior derecha
/// 
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
