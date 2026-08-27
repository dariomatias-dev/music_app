# Política de Seguridad

<p align="center">
<a href="security.md">English</a> · <strong>Español</strong> · <a href="security.pt-BR.md">Português (BR)</a> · <a href="security.zh.md">中文</a>
</p>

## Versiones Soportadas

**Music App** se mantiene como código fuente. La única versión soportada es la rama `main` actual: allí es donde se aplican las correcciones de seguridad, y no se retroportan a commits anteriores.

## Reportar una Vulnerabilidad

Por favor, **no** abras un issue público en GitHub para reportar una vulnerabilidad de seguridad.

En su lugar, envía un correo a [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com) con:

- Una descripción de la vulnerabilidad y su impacto potencial.
- Pasos para reproducirla (un ejemplo mínimo es de gran ayuda).
- El commit desde el que compilaste y la versión de Android utilizada en la prueba.

Este es un proyecto open-source mantenido por una sola persona, a escala de hobby: no hay un equipo de seguridad dedicado ni un SLA formal, pero todo reporte se toma en serio y se responde con la mayor brevedad posible. Una vez publicada una corrección, quien la reportó será acreditado, salvo que prefiera permanecer anónimo.

## Alcance

La aplicación funciona completamente offline: reproduce archivos de audio ya presentes en el dispositivo, almacena todos los datos localmente (SQLite mediante `drift`, `shared_preferences`) y no realiza ninguna solicitud de red. Por ello, las clases de problema más relevantes son locales: cómo maneja la aplicación entradas no confiables de archivos (lectura de metadatos de audio, importación de copias de seguridad en JSON y en base de datos) y cómo almacena los datos en el dispositivo. Las cuestiones relacionadas con servidor o cuenta no se aplican, ya que no existe servidor ni cuenta.
