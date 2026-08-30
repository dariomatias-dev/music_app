# Arquitectura

<p align="center">
<a href="architecture.md">English</a> · <strong>Español</strong> · <a href="architecture.pt-BR.md">Português (BR)</a> · <a href="architecture.zh.md">中文</a>
</p>

Este documento profundiza un nivel más que la visión general del README. Está pensado para quien vaya a modificar código en este repositorio: dónde va cada archivo, por qué existe una capa, y cómo se comunican las piezas entre sí.

## Estructura

```
lib/
  main.dart                 # composition root: límite de errores, configuración de plataforma, ProviderScope, RestartWidget
  src/
    core/                   # asuntos transversales, compartidos por todas las features
      audio/                # integración just_audio + audio_service
      database/             # esquema drift, tablas, DAOs, migraciones
      navigation/            # configuración de go_router, MainShell, navegación adaptativa
      permissions/            # abstracción de permisos multimedia
      services/               # lectura/escritura de metadatos, generador de id, selectores de archivo, ...
      storage/                # abstracción de almacenamiento clave-valor (shared_preferences)
      widgets/                 # widgets pequeños usados en toda la app, sin atarse a una feature
    features/
      <feature>/
        data/                # implementaciones de repositorio, data sources, DTOs/mappers
        domain/              # entidades, interfaces de repositorio, casos de uso
        presentation/
          providers/         # estado derivado/de presentación
          screens/           # un archivo por ruta
          view_models/       # clases Notifier/AsyncNotifier
          widgets/           # widgets de la feature, más una carpeta por pantalla
packages/
  app_ui/                    # paquete independiente del sistema de diseño (ver abajo)
```

Cada feature bajo `lib/src/features/` es un corte vertical: `library`, `player`, `queue`, `playlist`, `favorites` (parte de `library`), `history`, `statistics`, `storage`, `search`, `home`, `settings`, `onboarding`, `splash`.

## Capas (Clean Architecture + MVVM)

Toda feature que toca estado persistido sigue las mismas tres capas:

- **`domain`** — Dart puro. Entidades (data classes `freezed`), interfaces abstractas de repositorio, y clases de caso de uso (un único método `call()`) para cualquier cosa con lógica de ramificación real (p. ej. `CreateBackup`, `RestoreBackup`, `DeleteTrackFile`). Sin imports de Flutter, Riverpod ni drift aquí.
- **`data`** — implementa las interfaces de repositorio de `domain` contra una fuente de datos concreta (DAOs de drift, `shared_preferences`, plugins de plataforma). Los mappers convierten entre los tipos de fila de drift y las entidades de dominio.
- **`presentation`** — pantallas y widgets, más `ViewModel`s: clases `Notifier`/`AsyncNotifier` de Riverpod expuestas mediante providers generados (`riverpod_generator`). Una pantalla observa providers; nunca habla directamente con un repositorio salvo por una llamada puntual vía `ref.read(...)` disparada por una acción del usuario.

Una feature solo depende de la capa `domain` de otra feature (entidades, interfaces de repositorio), nunca de su `data` o `presentation`. Los providers conectan la implementación concreta en archivos `*_data_providers.dart` por feature.

## Organización de los widgets

Las pantallas se mantienen ligeras. Un archivo de pantalla observa los providers que necesita, se encarga de los callbacks que dispara una acción del usuario y compone widgets — nada de lo que renderiza se define inline. Esos widgets viven en `presentation/widgets/`, divididos en dos grupos:

- `widgets/<nombre>.dart` — compartidos dentro de la feature: usados por más de una pantalla, o por un sheet o diálogo que la feature expone (`media_row.dart`, `playlist_cover_art.dart`, `track_more_sheet.dart`).
- `widgets/<nombre_de_pantalla>/<componente>.dart` — pertenecen a una sola pantalla, una clase pública por archivo, nombrada por lo que renderiza (`widgets/album_screen/album_header.dart`, `widgets/storage_screen/storage_folder_header.dart`).

De esto se derivan dos convenciones:

- **Nada de clases de widget privadas al final del archivo de la pantalla, ni de métodos auxiliares `_buildX()`.** Ambos impiden que un componente se reconstruya de forma independiente, y un método `_buildX()` nunca puede ser `const`. En su lugar, el componente pasa a ser una clase real en su propio archivo.
- **Los componentes de pantalla son públicos** (`AlbumHeader`, no `_AlbumHeader`), ya que ahora cruzan la frontera de un archivo. Siguen siendo internos a la feature por convención: nada fuera de la feature dueña los importa. Un componente que una segunda feature realmente necesite pertenece a `app_ui` si es solo presentación, o a `lib/src/core/widgets/` si depende del estado de la app.

Un archivo de pantalla que supera las 300–400 líneas aproximadamente es la señal de que aún queda un componente inline por extraer.

## Gestión de estado

[Riverpod](https://riverpod.dev/) de principio a fin, con `riverpod_generator` para el código repetitivo:

- `Provider` para dependencias sin estado (repositorios, casos de uso).
- `NotifierProvider` / `AsyncNotifierProvider` para cualquier cosa con comportamiento (un `ViewModel`).
- `StreamProvider` donde un repositorio ya expone un `Stream` (la mayoría de los métodos `watch*` de los repositorios).

Los providers se agrupan por rol, no un archivo por provider: `library_providers.dart` (estado derivado/de presentación), `library_data_providers.dart` (repositorios/data sources), y así sucesivamente.

## Navegación

[go_router](https://pub.dev/packages/go_router) con un `StatefulShellRoute.indexedStack` para las cuatro pestañas principales (Inicio, Buscar, Biblioteca, Configuración), cada una preservando su propia pila de navegación al cambiar de pestaña. `MainShell` (`lib/src/core/navigation/main_shell.dart`) renderiza ese shell, adaptándose con un `LayoutBuilder`:

- Por debajo de `AppBreakpoints.medium` (840px): una barra de navegación inferior estilo teléfono.
- A partir de ahí (tablets, foldables desplegados): un `NavigationRail` lateral.

Las rutas de detalle (álbum, artista, lista de reproducción, reproductor, ...) se apilan sobre la pila de la pestaña activa, cada una envuelta en su propio `MiniPlayerDock` para mantener visible el mini-reproductor flotante.

## Persistencia

[drift](https://pub.dev/packages/drift) (una capa SQLite con tipado seguro) sostiene todo lo duradero: la biblioteca indexada (pistas/álbumes/artistas), listas de reproducción, favoritos, historial de reproducción, caché de letras, historial de búsqueda y carpetas excluidas. `AppDatabase` (`lib/src/core/database/app_database.dart`) declara el esquema y la estrategia de migración; cada tabla tiene su propio par `*Table`/`*Dao`. Las preferencias del usuario que no necesitan consultas (tema, idioma, duración del crossfade, ...) pasan por `shared_preferences` detrás de una pequeña abstracción `KeyValueStorage`.

Existen dos mecanismos de respaldo independientes, ambos accesibles desde Configuración → Almacenamiento:

- Una **exportación JSON** portátil (`CreateBackup`/`RestoreBackup`) solo de los datos creados por el usuario — listas de reproducción, favoritos, historial, carpetas excluidas, historial de búsqueda y preferencias — referenciados por el `sourceId` estable de cada pista en lugar de su id interno específico de la instalación, y fusionados (no reemplazados) al restaurar.
- Un **respaldo crudo de la base de datos** (`CreateDatabaseBackup`/`RestoreDatabaseBackup`), una instantánea byte a byte vía `VACUUM INTO` de todo el archivo SQLite, incluyendo la biblioteca indexada. Restaurarlo reemplaza el archivo por completo y reinicia la app (mediante `RestartWidget`, un cambio de `Key` que desmonta y reconstruye todo el `ProviderScope`) para reabrir una conexión limpia.

## Audio

[just_audio](https://pub.dev/packages/just_audio) maneja la reproducción en sí; [audio_service](https://pub.dev/packages/audio_service) la expone al sistema operativo (pantalla de bloqueo, notificación, controles Bluetooth) a través de `MusicAudioHandler`. Tanto los metadatos que ve el sistema como el efecto de crossfade propio de la app se disparan a partir de la misma señal — el cambio nativo de `currentIndex` de `just_audio` en un límite de pista — así que nunca se desincronizan entre sí.

El crossfade, tal como está implementado hoy, es una rampa de volumen de un solo reproductor: el motor nativo hace su propio cambio gapless instantáneo de la pista A a la B, y `PlaybackTransitionEffects` solo hace un fade-in de B desde el silencio después de eso — no son dos fuentes audibles superponiéndose de verdad. Es una simplificación conocida, no un error.

## Manejo de errores

`main.dart` instala el límite más externo de la app antes que cualquier otra cosa. `FlutterError.onError` y `PlatformDispatcher.onError` van los dos a un `ErrorReporter` (`lib/src/core/errors/`), porque ambos por defecto imprimen en debug y no hacen nada en release: sin ellos, un widget que lanza durante el build deja una caja de error y ningún rastro, y un error que escapa de un callback asíncrono desprendido desaparece por completo. El manejador de plataforma reporta y marca el error como manejado, para que un fallo en el canal de un plugin o en un stream sin oyentes no pueda derribar el isolate y llevarse la reproducción con él.

Dos caminos muestran un fallo del que no se puede proteger al usuario, ambos a través de `AppFailureScreen` (`lib/src/core/widgets/`): `ErrorWidget.builder`, cuando una parte de la app en marcha falla al construirse, y el respaldo de arranque, cuando la configuración de plataforma de `main.dart` lanza antes de que exista app alguna, ofreciendo entonces repetir toda la secuencia. Ambos pueden invocarse sin `Theme`, `Directionality` ni `Localizations` por encima, así que `AppFailureScreen` resuelve los tres desde la plataforma y no desde su `BuildContext`; leer un ancestro ausente lanzaría desde dentro de la pantalla que existe para reportar el lanzamiento.

Dentro de la app, un fallo que una pantalla concreta puede explicar sigue siendo asunto de esa pantalla: lo captura, muestra un `AppToast` o un `AppErrorState`, y no llega a este límite.

## Sistema de diseño (`packages/app_ui`)

Un paquete Flutter autocontenido, versionado y probado de forma independiente de la app (su propio job de CI, su propio umbral de cobertura). Exporta:

- **Tokens**: `AppSpacing`, `AppSizes`, `AppRadius`, `AppDurations`, `AppCurves`, `AppBreakpoints`, escalas de tipografía y color.
- **Tema**: `AppTheme` claro/oscuro, expuesto a los widgets vía una extensión de `BuildContext` (`context.colors`).
- **Componentes**: botones, cards, diálogos, sheets, navegación, feedback (toasts), estados (vacío/error/permiso/indexación), y el primitivo de interacción `Pressable` sobre el que se construye todo widget tocable.

La app nunca redefine un color, un valor de espaciado o una curva de animación en línea — todo viene de `app_ui`.

## Pruebas

Consulta la sección de Pruebas del README para los números actuales de archivos y umbrales de cobertura. En resumen: pruebas unitarias para repositorios/casos de uso/view models, pruebas de widgets para pantallas/componentes (incluyendo golden tests para el sistema de diseño y pantallas clave), y algunos flujos de extremo a extremo en `integration_test/` (onboarding → escaneo → Inicio, reproducción desde la biblioteca, y persistencia de datos a través de un reinicio simulado).
