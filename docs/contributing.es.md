# Contribuir

<p align="center">
<a href="contributing.md">English</a> · <strong>Español</strong> · <a href="contributing.pt-BR.md">Português (BR)</a> · <a href="contributing.zh.md">中文</a>
</p>

Gracias por considerar contribuir. Este documento cubre la configuración, las convenciones, y qué necesita un pull request antes de estar listo para revisión. Para entender cómo está organizado el código, consulta [`architecture.md`](architecture.es.md).

## Configuración

El proyecto fija la versión del SDK de Flutter vía [FVM](https://fvm.app/), así que todos los comandos de abajo usan `fvm flutter` en lugar de una instalación directa de `flutter`.

```sh
git clone https://github.com/dariomatias-dev/music_app.git
cd music_app
fvm install
fvm flutter pub get
```

El código generado (freezed, json_serializable, drift, riverpod_generator, go_router_builder) y las localizaciones no se commitean ya compilados en cada cambio — regenéralos después de actualizar el repositorio o de editar cualquier cosa de la que dependan:

```sh
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter gen-l10n
```

Ejecuta la app en un dispositivo conectado o emulador con `fvm flutter run`.

## Antes de abrir un pull request

- **Abre un issue primero** para discutir el cambio, a menos que sea una corrección pequeña y obvia.
- **Sigue la estructura existente**: feature-first, capas `data`/`domain`/`presentation`, Riverpod para el estado, ningún patrón nuevo sin discutirlo antes. Consulta [`architecture.md`](architecture.es.md).
- **Respeta el sistema de diseño**: nada de colores, espaciados o duraciones en línea — usa los tokens y componentes de `packages/app_ui`.
- **Agrega pruebas** para todo lo que tenga lógica: un método de repositorio, un caso de uso, un `ViewModel`, el comportamiento de un widget. `packages/app_ui` es un paquete separado con su propia suite de pruebas; los cambios ahí también necesitan sus propias pruebas.
- **Todo documento, cadena de texto y recurso localizado se publica en todos los idiomas soportados** (inglés, español, portugués, chino) — los archivos `lib/l10n/*.arb`, y cualquier documentación en `docs/`.
- **Ejecuta la verificación completa localmente** antes de hacer push:

  ```sh
  fvm flutter analyze
  fvm dart format --output=none --set-exit-if-changed lib test
  fvm flutter test --coverage
  ./scripts/check_coverage.sh coverage/lcov.info 97
  ```

  (Ejecuta los mismos cuatro comandos dentro de `packages/app_ui/` para cambios ahí; su umbral de cobertura es 98.)

- **Los mensajes de commit** siguen [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `ci:`, etc., con un asunto corto en imperativo. Revisa el `git log` para ver ejemplos ya presentes en el repositorio.

## Qué verifica el CI

Cada push y pull request ejecuta las mismas verificaciones descritas arriba, más una comprobación de que los archivos generados (salida de build_runner, localizaciones) están commiteados y actualizados, y una compilación de la APK de release. Consulta `.github/workflows/ci.yml` para los pasos exactos.

## Código de Conducta

La participación en este proyecto se rige por el [Código de Conducta](code_of_conduct.es.md).
