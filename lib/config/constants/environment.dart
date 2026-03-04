/// 🔐 VARIABLES DE ENTORNO - environment.dart
///
/// Aquí se cargan las API keys y datos sensibles desde un archivo .env
/// No se suben al repositorio por razones de seguridad.
///
/// El archivo .env debe tener:
/// THE_MOVIEDB_KEY=abc123XYZ

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Clase con acceso a las variables de entorno
class Environment {
  
  /// API Key de The Movie Database
  /// Se carga desde el archivo .env usando flutter_dotenv
  /// Si no está configurada, retorna un mensaje de error
  static String theMovieDbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay api key';

}