import 'package:flutter/material.dart';

/// ================================================================================
/// CONFIGURACIÓN DE TEMA (DESIGN SYSTEM)
/// ================================================================================
/// 
/// Esta clase centraliza la configuración visual de toda la app.
/// 
/// Ventajas de centralizar el tema:
/// - Cambio rápido de colores en todo la app
/// - Consistencia visual
/// - Fácil implementar temas oscuro/claro
/// 
/// Material3 (useMaterial3: true):
/// Es el sistema de diseño más moderno de Google (2022+)
/// Proporciona:
/// - Dynamic Color: Colores basados en el wallpaper del dispositivo
/// - Animations: Transiciones suaves
/// - Shapes: Esquinas y formas redondeadas
/// 
class AppTheme {

  /// Retorna la configuración visual de MaterialApp
  ThemeData getTheme() => ThemeData(
    // Usa Material Design 3 (más moderno que Material 2)
    useMaterial3: true,
    // colorSchemeSeed: Color base que genera toda la paleta de colores
    // Material3 genera automáticamente: primary, secondary, tertiary, etc.
    // Hex #2862F5 es un AZUL
    colorSchemeSeed: const Color(0xFF2862F5)
  );


}