# Política de Segurança

<p align="center">
<a href="security.md">English</a> · <a href="security.es.md">Español</a> · <strong>Português (BR)</strong> · <a href="security.zh.md">中文</a>
</p>

## Versões Suportadas

O **Music App** não está disponível na Play Store; ele é distribuído como um APK assinado pelas [GitHub Releases](https://github.com/dariomatias-dev/music_app/releases) do projeto. Só a última versão lançada recebe correções de segurança — não há versões antigas sendo mantidas.

## Reportando uma Vulnerabilidade

Por favor, **não** abra uma issue pública no GitHub pra uma vulnerabilidade de segurança.

Em vez disso, envie um e-mail pra [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com) com:

- Uma descrição da vulnerabilidade e seu impacto potencial.
- Passos pra reproduzi-la (um exemplo mínimo ajuda bastante).
- A versão do app e a versão do Android usadas no teste.

Este é um projeto open-source que mantenho sozinho, no ritmo de um hobby — não tem uma equipe de segurança dedicada nem um SLA formal, mas todo relato é levado a sério e respondido o quanto antes. Assim que uma correção sair, quem reportou é creditado nas notas da versão, a menos que prefira ficar anônimo.

## Escopo

O app roda totalmente offline: ele toca arquivos de áudio que já estão no dispositivo, guarda tudo localmente (SQLite via `drift`, `shared_preferences`) e não faz nenhuma requisição de rede. Por isso, os riscos mais relevantes aqui são locais — como o app lida com entrada não confiável de arquivos (leitura de metadado de áudio, importação de backups em JSON/banco de dados) e como ele armazena dados no aparelho — e não algo ligado a servidor ou conta, já que não existe nem um nem outro.
