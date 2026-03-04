/// 🎨 TEMA VISUAL DE LA APP - app_theme.dart
///
/// Define los colores, estilos y apariencia visual de toda la aplicación.
/// Usa Material Design 3 con colores derivados del color principal azul (#2862F5).
///
/// Cada widget en la app usa este tema para mantener consistencia visual:
/// - Botones heredan el colorScheme
/// - Textos siguen el textTheme
/// - Iconos usan los colores del theme

import 'package:flutter/material.dart';

/// Clase que contiene la configuración del tema visual
class AppTheme {
  
  /// Crea y retorna el ThemeData completo para MaterialApp
  /// 
  /// Material Design 3 permite que todos los componentes se vean modernos
  /// colorSchemeSeed: Color azul #2862F5 del que se derivan todos los demás colores
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,        // Activar Material Design 3
    colorSchemeSeed: const Color(0xFF2862F5)  // Azul principal
  );

}
