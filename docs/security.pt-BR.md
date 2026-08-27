# Política de Segurança

<p align="center">
<a href="security.md">English</a> · <a href="security.es.md">Español</a> · <strong>Português (BR)</strong> · <a href="security.zh.md">中文</a>
</p>

## Versões Suportadas

O **Music App** é mantido como código-fonte. A única versão suportada é a branch `main` atual: é nela que as correções de segurança são aplicadas, e elas não são retroportadas para commits anteriores.

## Reportando uma Vulnerabilidade

Por favor, **não** abra uma issue pública no GitHub para relatar uma vulnerabilidade de segurança.

Em vez disso, envie um e-mail para [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com) contendo:

- Uma descrição da vulnerabilidade e seu impacto potencial.
- Passos para reproduzi-la (um exemplo mínimo é de grande ajuda).
- O commit a partir do qual você compilou e a versão do Android utilizada no teste.

Este é um projeto open-source mantido por uma única pessoa, em escala de hobby: não há equipe de segurança dedicada nem SLA formal, mas todo relato é levado a sério e respondido com a maior brevidade possível. Assim que uma correção for publicada, quem reportou será creditado, salvo se preferir permanecer anônimo.

## Escopo

O aplicativo funciona totalmente offline: reproduz arquivos de áudio já presentes no dispositivo, armazena todos os dados localmente (SQLite via `drift`, `shared_preferences`) e não realiza nenhuma requisição de rede. Por isso, as classes de problema mais relevantes são locais: como o aplicativo trata entradas não confiáveis de arquivos (leitura de metadados de áudio, importação de backups em JSON e em banco de dados) e como ele armazena dados no dispositivo. Questões relacionadas a servidor ou conta não se aplicam, pois não existe servidor nem conta.
