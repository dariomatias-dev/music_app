# Notas de Dependencias

<p align="center">
<a href="dependencies.md">English</a> · <strong>Español</strong> · <a href="dependencies.pt-BR.md">Português (BR)</a> · <a href="dependencies.zh.md">中文</a>
</p>

La mayoría de las dependencias en `pubspec.yaml` usan una restricción flexible (`^x.y.z`) y se actualizan libremente. Unas pocas (ahí, y en los archivos de build de Android) quedan fijadas en una versión exacta, o topadas por debajo de la última disponible, por razones que no son obvias solo mirando la restricción. Este documento es ese contexto, para que nadie tenga que redescubrirlo desde cero (o peor, "arreglar" el pin sin entender por qué está ahí).

## `intl: 0.20.2` (pin exacto)

Forzado por `flutter_localizations`, que viene del propio SDK de Flutter, no de pub.dev. La versión del SDK de Flutter instalado dicta qué versión de `intl` exige `flutter_localizations`; actualizar `intl` solo, sin antes actualizar el SDK de Flutter, fallará al resolver.

## `drift: 2.31.0`, `drift_dev: 2.31.0` (pin exacto, topado por debajo de la última versión)

`drift`/`drift_dev` 2.32.0+ requieren `analyzer` en el rango `^10.0.0–^13.0.0`. `riverpod_generator` (actualmente `^3.0.0`) depende transitivamente de `riverpod_analyzer_utils`, que topa `analyzer` bastante por debajo de eso (`^7`–`^9`, en las versiones compatibles con `riverpod_generator ^3.0.0`). Las dos restricciones no se solapan, así que `drift`/`drift_dev` quedan fijados en la última versión compatible con el rango de analyzer que permite `riverpod_generator ^3.0.0`.

**No es un salto pequeño.** Liberar `drift` requiere `drift_dev 2.34+`, que necesita `analyzer ^13`. La única versión de `riverpod_analyzer_utils` que también acepta `analyzer ^13` es `1.0.0-dev.11`, que solo se distribuye como dependencia transitiva de `riverpod_generator ^4.0.8`. Eso, a su vez, requiere `riverpod_annotation ^4.0.6`, un **salto de versión mayor del propio Riverpod**, que también llevaría `flutter_riverpod` a la 4.x y probablemente afectaría código generado y la sintaxis de providers en toda la app. Sigue esto upstream; no lo intentes como una actualización de dependencia aislada.

## `sqlite3_flutter_libs: 0.5.42` (pin exacto, topado por debajo de la última versión)

La última versión del paquete (`0.6.0+eol`) es una lápida intencional, un paquete vacío cuya descripción dice *"Not used anymore, update to version 3.x of package:sqlite3 instead"* (ya no se usa, actualiza a la versión 3.x de package:sqlite3). Sus binarios nativos dejan de ser necesarios cuando `sqlite3` (los bindings de Dart) pasa a su línea 3.x, que asume esa responsabilidad por sí misma.

Esa migración es **el mismo bloqueo que el pin de `drift` de arriba**, no uno separado: `sqlite3` 3.x requiere `drift ^2.34`, y `drift` 2.31.0 (fijado por la razón de arriba) solo acepta `sqlite3 ^2.6`. Resolver la cadena `drift`/Riverpod resuelve esto también, así que no intentes actualizar `sqlite3_flutter_libs` o `sqlite3` de forma aislada.

## `gradle-wrapper: 8.14`, `com.android.application: 8.11.1` (topados por debajo de la última versión)

`metadata_god` incluye CargoKit, cuyo script de Gradle llama a `exec()`, un método que Gradle 9 eliminó. Cualquier subida a Gradle 9.x rompe la compilación de la APK con `Could not find method exec() ... on project ':metadata_god'`, así que el wrapper se queda en la línea 8.x hasta que `metadata_god` publique un CargoKit que compile bajo Gradle 9.

El Android Gradle Plugin es **el mismo bloqueo visto desde el otro lado**, no uno separado: AGP 9.x se niega a ejecutarse por debajo de Gradle 9.5.0, fallando con `Minimum supported Gradle version is 9.5.0`. Resolver el bloqueo de CargoKit resuelve este también, así que no intentes subir ninguno más allá de su frontera 9.x de forma aislada.

El tope es esa frontera, no estas versiones exactas. Dentro de 8.x ambos pueden moverse, y están en el mínimo que Flutter avisa que pronto exigirá (Gradle 8.14, AGP 8.11.1, Kotlin 2.2.20), que compila sin avisos.

## Cómo revisar actualizaciones

```sh
fvm flutter pub outdated
```

Ejecuta esto de vez en cuando para ver qué es realmente resoluble frente a lo que está bloqueado por las cadenas de arriba.

Dependabot también abre pull requests de actualización semanales (consulta [`contributing.md`](contributing.es.md#actualizaciones-de-dependencias)). Lee las restricciones de versión, no este documento, así que periódicamente propondrá subidas que las cadenas de arriba bloquean. Cierra esos PR en lugar de fusionarlos: los pines cumplen una función, y cada uno solo se puede quitar junto con la cadena a la que pertenece.
