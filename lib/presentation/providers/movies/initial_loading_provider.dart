import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

/// ================================================================================
/// PROVIDER: DETECCIÓN DE CARGA INICIAL
/// ================================================================================
/// 
/// Este Provider determina si la aplicación aún está cargando datos iniciales.
/// 
/// RESPONSABILIDAD:
/// - Revisa si las 4 categorías de películas están cargadas (no vacías)
/// - Retorna true si ALGUNA categoría aún está cargando
/// - Retorna false cuando TODAS las categorías tienen datos
/// 
/// CASOS DE USO:
/// - Mostrar FullScreenLoader mientras se cargan datos
/// - Bloquear UI hasta tener mínimo una película de cada categoría
/// - Indicador visual de progreso de carga inicial
/// 
/// FLUJO:
/// 1. HomeView.initState() llama loadNextPage() en 4 providers
/// 2. Cada provider trae datos del API
/// 3. initialLoadingProvider detecta cambios automáticamente
/// 4. Si alguno está vacío = true (mostrará loader)
/// 5. Si todos tienen datos = false (mostrará contenido)
/// 
final initialLoadingProvider = Provider<bool>((ref) {

  final step1 = ref.watch( nowPlayingMoviesProvider ).isEmpty;
  final step2 = ref.watch( popularMoviesProvider ).isEmpty;
  final step3 = ref.watch( topRatedMoviesProvider ).isEmpty;
  final step4 = ref.watch( upcomingMoviesProvider ).isEmpty;

  if( step1 || step2 || step3 || step4 ) return true;

  return false; // terminamos de cargar
});