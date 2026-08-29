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
- **Mantén las pantallas ligeras**: una pantalla compone widgets y conecta providers. Los componentes van en su propio archivo bajo `presentation/widgets/<nombre_de_pantalla>/` — no como clases privadas al final del archivo de la pantalla, ni como métodos auxiliares `_buildX()`. Consulta [Organización de los widgets](architecture.es.md#organización-de-los-widgets).
- **Respeta el sistema de diseño**: nada de colores, espaciados o duraciones en línea — usa los tokens y componentes de `packages/app_ui`.
- **Agrega pruebas** para todo lo que tenga lógica: un método de repositorio, un caso de uso, un `ViewModel`, el comportamiento de un widget. `packages/app_ui` es un paquete separado con su propia suite de pruebas; los cambios ahí también necesitan sus propias pruebas.
- **Todo documento, cadena de texto y recurso localizado se publica en todos los idiomas soportados** (inglés, español, portugués, chino) — los archivos `lib/l10n/*.arb`, y cualquier documentación en `docs/`.
- **Ejecuta la verificación completa localmente** antes de hacer push:

  ```sh
  ./scripts/verify.sh
  ```

  Ejecuta lo mismo que CI, limitado a los paquetes que cambiaste: formato, análisis, pruebas y el umbral de cobertura (97% para la app, 98% para `packages/app_ui`). Agrega `--gen` cuando el cambio tocó algo que leen `build_runner` o `gen-l10n`, `--all` para verificar ambos paquetes sin importar qué cambió, o `--skip-tests` para una pasada rápida de formato y análisis a mitad del trabajo.

  Las mismas verificaciones a mano, ejecutadas dentro del paquete que estás cambiando:

  ```sh
  fvm flutter analyze
  fvm dart format --output=none --set-exit-if-changed lib test
  fvm flutter test --coverage
  ./scripts/check_coverage.sh coverage/lcov.info 97
  ```

- **Los mensajes de commit** siguen [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `ci:`, etc., con un asunto corto en imperativo. Revisa el `git log` para ver ejemplos ya presentes en el repositorio.

## Qué verifica el CI

Cada push y pull request ejecuta [`.github/workflows/ci.yaml`](../.github/workflows/ci.yaml), en cuatro jobs:

| Job | Qué hace |
| --- | --- |
| `music_app` | Instala dependencias, regenera código y localizaciones, y luego **falla si esa regeneración produce un diff** — los archivos generados deben estar commiteados y actualizados. Después: formato, análisis, pruebas y el umbral del 97% de cobertura. |
| `Build APK` | Se ejecuta tras aprobar `music_app`, y compila una APK de release, publicada como artefacto del workflow y conservada durante 14 días. |
| `packages/app_ui` | Formato, análisis, pruebas y el umbral del 98% de cobertura del paquete del sistema de diseño, de forma independiente de la app. |
| `Integration tests` | Se ejecuta tras aprobar `music_app`, arranca un emulador de Android y ejecuta en él todas las suites de `integration_test/` en una misma sesión, ya que arrancarlo es con diferencia el paso más lento. Necesitan un dispositivo: los flujos leen a través de las stream queries de drift, que nunca emiten bajo el fake async de un `flutter test` normal. El job habilita KVM primero — sin él el emulador cae en renderizado por software y agota el tiempo — y por eso dispone de 45 minutos. |

Hacer push de una etiqueta `v*.*.*` ejecuta [`.github/workflows/release.yml`](../.github/workflows/release.yml): las mismas verificaciones, y luego una APK de release publicada en un release de GitHub con notas generadas automáticamente. Ten en cuenta que la compilación de release se firma con la **keystore de debug** a propósito — esta app no tiene configuración de firma de producción.

### Ejecutar los workflows localmente

[`act`](https://github.com/nektos/act) ejecuta los workflows en Docker, lo que conviene hacer antes de subir un cambio a cualquier cosa bajo `.github/workflows/`. El `.actrc` del repositorio ya fija la imagen del runner, así que no hacen falta flags:

```sh
act -l                                # lista todos los jobs, con su id y stage
act pull_request                      # todo lo que el CI ejecutaría en un PR
act pull_request -j app               # un solo job, por su id
act pull_request -j app --dryrun      # imprime los pasos sin ejecutarlos
```

`-j` recibe el **id** del job (`app`, `build_apk`, `integration`, `app_ui`, `release`), no el nombre visible de la tabla de arriba; `act -l` muestra ambos. La primera ejecución real descarga una imagen de runner de varios gigabytes, y `act` aproxima los runners de GitHub en lugar de reproducirlos exactamente — un `act` en verde es una buena señal, no una garantía.

## Trabajar con un agente de IA

El repositorio lleva su propia configuración de agente, para que un asistente siga el mismo proceso que un colaborador en lugar de improvisar uno por cada prompt:

- [`CLAUDE.md`](../CLAUDE.md) es el acuerdo de trabajo, leído en cada turno: dónde va el código, qué debe probar cada tipo de cambio y qué documentos invalida un cambio.
- [`.claude/skills/ship-change/SKILL.md`](../.claude/skills/ship-change/SKILL.md) contiene las recetas por tipo de cambio: un servicio de `core`, una feature, un componente de `app_ui`, un cambio de esquema con su migración, un texto localizado, una actualización de dependencia.
- [`.claude/settings.json`](../.claude/settings.json) conecta dos hooks. Cada archivo Dart escrito se formatea de inmediato, y un hook `Stop` se niega a terminar el turno mientras haya cambios de código que no pasaron `./scripts/verify.sh`.
- [`.github/pull_request_template.md`](../.github/pull_request_template.md) pone la misma lista de verificación frente a quien revisa.

Nada de esto reemplaza al CI, que sigue siendo la autoridad. Existe para que la verificación local coincida con lo que dirá el CI. Cambiar el acuerdo, las recetas o los hooks es un cambio normal: actualiza esta sección junto con ellos.

## Actualizaciones de dependencias

Dependabot está configurado en [`.github/dependabot.yml`](../.github/dependabot.yml) y abre pull requests semanales para cuatro ecosistemas: pub (la app), pub (`packages/app_ui`), Gradle (`android/`) y GitHub Actions.

Esos pull requests pasan por el mismo CI que cualquier otro. Antes de aprobar uno, consulta [`dependencies.md`](dependencies.es.md): algunos paquetes están fijados por debajo de su última versión a propósito, y un PR de Dependabot que suba una de esas cadenas debe cerrarse, no fusionarse.

## Código de Conducta

La participación en este proyecto se rige por el [Código de Conducta](code_of_conduct.es.md).
