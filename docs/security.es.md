# Política de Seguridad

<p align="center">
<a href="security.md">English</a> · <strong>Español</strong> · <a href="security.pt-BR.md">Português (BR)</a> · <a href="security.zh.md">中文</a>
</p>

## Versiones Soportadas

**Music App** no está en la Play Store; se distribuye como un APK firmado desde [GitHub Releases](https://github.com/dariomatias-dev/music_app/releases). Solo la última versión publicada recibe correcciones de seguridad — no hay ramas antiguas mantenidas.

## Reportar una Vulnerabilidad

Por favor, **no** abras un issue público en GitHub para una vulnerabilidad de seguridad.

En su lugar, envía un correo a [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com) con:

- Una descripción de la vulnerabilidad y su impacto potencial.
- Pasos para reproducirla (un ejemplo mínimo ayuda mucho).
- La versión de la app y la versión de Android usadas en la prueba.

Este es un proyecto open-source mantenido por una sola persona, a escala de hobby — no hay un equipo de seguridad dedicado ni un SLA formal, pero los reportes se toman en serio y se responden lo antes posible. Una vez que salga una corrección, quien lo reportó será acreditado en las notas de la versión, a menos que prefiera mantenerse anónimo.

## Alcance

La app funciona completamente offline: reproduce archivos de audio ya presentes en el dispositivo, guarda todo localmente (SQLite vía `drift`, `shared_preferences`), y no hace ninguna solicitud de red. Las clases de problema más relevantes son, por lo tanto, locales: cómo maneja entradas no confiables de archivos (lectura de metadatos de audio, importación de copias de seguridad en JSON/base de datos) y cómo almacena datos en el dispositivo — no algo relacionado con servidor o cuenta, ya que no existe ni servidor ni cuenta.
