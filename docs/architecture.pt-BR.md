# Arquitetura

<p align="center">
<a href="architecture.md">English</a> · <a href="architecture.es.md">Español</a> · <strong>Português (BR)</strong> · <a href="architecture.zh.md">中文</a>
</p>

Este documento vai um nível além da visão geral do README. É voltado para quem for trabalhar no código deste repositório: onde um arquivo deve morar, por que uma camada existe, e como as partes conversam entre si.

## Estrutura

```
lib/
  main.dart                 # composition root: fronteira de erros, setup da plataforma, ProviderScope, RestartWidget
  src/
    core/                   # preocupações transversais, compartilhadas por toda feature
      audio/                # integração just_audio + audio_service
      database/             # schema drift, tabelas, DAOs, migrações, seeds de desenvolvimento
      navigation/            # config do go_router, MainShell, navegação adaptativa
      permissions/            # abstração de permissões de mídia e notificação
      services/               # leitura/escrita de metadado, gerador de id, seletores de arquivo, ...
      storage/                # abstração de armazenamento chave-valor (shared_preferences)
      widgets/                 # widgets pequenos usados em todo o app, sem ligação a uma feature
    features/
      <feature>/
        data/                # implementações de repositório, data sources, DTOs/mappers, seeds
        domain/              # entidades, interfaces de repositório, casos de uso
        presentation/
          providers/         # estado derivado/de apresentação
          screens/           # um arquivo por rota
          view_models/       # classes Notifier/AsyncNotifier
          widgets/           # widgets da feature, mais uma pasta por tela
packages/
  app_ui/                    # pacote independente do design system (veja abaixo)
```

Cada feature em `lib/src/features/` é uma fatia vertical: `library`, `player`, `queue`, `playlist`, `favorites` (parte de `library`), `history`, `statistics`, `storage`, `search`, `home`, `settings`, `onboarding`, `splash`.

## Camadas (Clean Architecture + MVVM)

Toda feature que toca em estado persistido segue as mesmas três camadas:

- **`domain`**: Dart puro. Entidades (data classes `freezed`), interfaces abstratas de repositório, e classes de caso de uso (um único método `call()`) para qualquer coisa com lógica de ramificação real (ex.: `CreateBackup`, `RestoreBackup`, `DeleteTrackFile`). Nenhum import de Flutter, Riverpod ou drift aqui.
- **`data`**: implementa as interfaces de repositório do `domain` contra uma fonte de dados concreta (DAOs do drift, `shared_preferences`, plugins de plataforma). Mappers convertem entre os tipos de linha do drift e as entidades de domínio.
- **`presentation`**: telas e widgets, mais `ViewModel`s: classes `Notifier`/`AsyncNotifier` do Riverpod expostas por providers gerados (`riverpod_generator`). Uma tela observa providers; ela nunca fala direto com um repositório, exceto por uma chamada pontual via `ref.read(...)` disparada por uma ação do usuário.

Uma feature só depende da camada `domain` de outra feature (entidades, interfaces de repositório), nunca de sua `data` ou `presentation`. Providers ligam a implementação concreta em arquivos `*_data_providers.dart` por feature.

## Organização dos widgets

As telas são enxutas. Um arquivo de tela observa os providers que precisa, cuida dos callbacks disparados por ações do usuário e compõe widgets: nada do que ela renderiza é definido inline. Esses widgets ficam em `presentation/widgets/`, divididos em dois grupos:

- `widgets/<nome>.dart`, compartilhados dentro da feature: usados por mais de uma tela, ou por um sheet ou diálogo que a feature expõe (`media_row.dart`, `playlist_cover_art.dart`, `track_more_sheet.dart`).
- `widgets/<nome_da_tela>/<componente>.dart`, pertencem a uma única tela, uma classe pública por arquivo, nomeada pelo que renderiza (`widgets/album_screen/album_header.dart`, `widgets/storage_screen/storage_folder_header.dart`).

Duas convenções decorrem disso:

- **Nada de classes de widget privadas no fim do arquivo da tela, nem de métodos auxiliares `_buildX()`.** Os dois impedem que um componente seja reconstruído de forma independente, e um método `_buildX()` nunca pode ser `const`. Em vez disso, o componente vira uma classe de verdade no seu próprio arquivo.
- **Componentes de tela são públicos** (`AlbumHeader`, não `_AlbumHeader`), já que agora cruzam a fronteira de um arquivo. Eles continuam internos à feature por convenção: nada fora da feature dona deles os importa. Um componente que uma segunda feature realmente precise pertence ao `app_ui`, se for só apresentação, ou a `lib/src/core/widgets/`, se depender do estado do app.

Um arquivo de tela passando de mais ou menos 300–400 linhas é o sinal de que ainda há um componente inline esperando ser extraído.

## Gerenciamento de estado

[Riverpod](https://riverpod.dev/) do início ao fim, com `riverpod_generator` cuidando do boilerplate:

- `Provider` para dependências sem estado (repositórios, casos de uso).
- `NotifierProvider` / `AsyncNotifierProvider` para qualquer coisa com comportamento (um `ViewModel`).
- `StreamProvider` onde um repositório já expõe um `Stream` (a maioria dos métodos `watch*` dos repositórios).

Os providers são agrupados por papel, não um arquivo por provider: `library_providers.dart` (estado derivado/de apresentação), `library_data_providers.dart` (repositórios/data sources), e assim por diante.

## Navegação

[go_router](https://pub.dev/packages/go_router) com um `StatefulShellRoute.indexedStack` pras quatro abas principais (Início, Buscar, Biblioteca, Configurações), cada uma preservando sua própria pilha de navegação ao trocar de aba. `MainShell` (`lib/src/core/navigation/main_shell.dart`) renderiza esse shell, se adaptando com um `LayoutBuilder`:

- Abaixo de `AppBreakpoints.medium` (840px): barra de navegação inferior, estilo celular.
- A partir daí (tablets, foldables abertos): um `NavigationRail` lateral.

Rotas de detalhe (álbum, artista, playlist, player, ...) são empilhadas sobre a pilha da aba ativa, cada uma envolvida em seu próprio `MiniPlayerDock` para manter o mini-player flutuante visível.

## Persistência

[drift](https://pub.dev/packages/drift) (uma camada SQLite com tipagem segura) sustenta tudo que é durável: a biblioteca indexada (faixas/álbuns/artistas), playlists, favoritos, histórico de reprodução, cache de letras, histórico de busca e pastas excluídas. `AppDatabase` (`lib/src/core/database/app_database.dart`) declara o schema e a estratégia de migração; cada tabela tem seu próprio par `*Table`/`*Dao`. Preferências do usuário que não precisam de consulta (tema, idioma, duração do crossfade, ...) passam por `shared_preferences` atrás de uma pequena abstração `KeyValueStorage`.

O SQLite mantém as foreign keys desligadas a menos que a conexão peça, então o `beforeOpen` liga a verificação, e as linhas que pertencem a uma faixa ou a uma playlist (favoritos, letras em cache, eventos de reprodução, entradas de playlist) caem em cascata junto. Antes disso, deletar uma faixa deixava tudo isso para trás: sumia de qualquer coisa que resolvesse um id de faixa, mas as estatísticas que agregam eventos por conta própria continuavam contando, então os totais deixavam de bater com as faixas listadas embaixo deles.

Existem dois mecanismos de backup independentes, ambos acessíveis em Configurações → Armazenamento:

- Um **export JSON** portátil (`CreateBackup`/`RestoreBackup`) só dos dados criados pelo usuário (playlists, favoritos, histórico, pastas excluídas, histórico de busca e preferências), referenciado pelo `sourceId` estável de cada faixa (não pelo id interno específico da instalação), e mesclado (não substituído) na restauração.
- Um **backup bruto do banco** (`CreateDatabaseBackup`/`RestoreDatabaseBackup`), um snapshot byte a byte via `VACUUM INTO` do arquivo SQLite inteiro, incluindo a biblioteca indexada. Restaurá-lo substitui o arquivo por completo e reinicia o app (via `RestartWidget`, uma troca de `Key` que desmonta e reconstrói todo o `ProviderScope`) para reabrir uma conexão limpa.

## Áudio

[just_audio](https://pub.dev/packages/just_audio) conduz a reprodução em si; [audio_service](https://pub.dev/packages/audio_service) a expõe para o sistema operacional (tela de bloqueio, notificação, controles Bluetooth) através do `MusicAudioHandler`. Tanto o metadado voltado para o sistema quanto o efeito de crossfade do próprio app disparam a partir do mesmo sinal (a mudança nativa de `currentIndex` do `just_audio` em uma transição de faixa), então nunca ficam dessincronizados entre si.

O crossfade, como implementado hoje, é uma rampa de volume de um único player: o engine nativo faz sua própria troca gapless instantânea da faixa A para B, e o `PlaybackTransitionEffects` só faz o fade-in de B a partir do silêncio depois disso. Não são duas fontes audíveis se sobrepondo de fato. É uma simplificação conhecida, não um bug.

## Tratamento de erros

O `main.dart` instala a fronteira mais externa do app antes de qualquer outra coisa rodar. `FlutterError.onError` e `PlatformDispatcher.onError` vão os dois para um `ErrorReporter` (`lib/src/core/errors/`), porque ambos por padrão imprimem em debug e não fazem nada em release. Sem eles, um widget que lança durante o build deixa uma caixa de erro e nenhum rastro, e um erro que escapa de um callback assíncrono solto some de vez. O handler de plataforma reporta e marca o erro como tratado, para que uma falha no canal de um plugin ou em um stream sem ouvintes não derrube o isolate e leve a reprodução junto.

Dois caminhos mostram uma falha da qual não é possível proteger o usuário, ambos via `AppFailureScreen` (`lib/src/core/widgets/`): o `ErrorWidget.builder`, quando uma parte do app em execução falha ao construir, e o fallback de inicialização, quando o setup de plataforma do `main.dart` lança antes de existir app algum, esse oferecendo executar a sequência inteira de novo. Os dois podem ser invocados sem `Theme`, `Directionality` ou `Localizations` acima, então o `AppFailureScreen` resolve os três a partir da plataforma, não do seu `BuildContext`; ler um ancestral ausente lançaria de dentro da própria tela que existe para reportar o lançamento.

Abaixo dessa fronteira, `AppException` (`lib/src/core/errors/`) é o vocabulário de falhas do próprio app: `PermissionException`, `FileException` e `PlaybackException`. Falhas de terceiros são convertidas antes de sair da camada que as causou, para que as camadas superiores lidem com um tipo só em vez do que `dart:io`, o drift ou um plugin resolverem lançar. O `FileException.guard` envolve as chamadas de disco e do seletor de arquivos na camada de dados e nos casos de uso de armazenamento, mantendo a mensagem e o `cause` original juntos.

Dentro do app, uma falha que uma tela específica consegue explicar continua sendo assunto daquela tela: ela captura, mostra um `AppToast` ou um `AppErrorState`, e não chega nessa fronteira. Esses catches são deliberadamente amplos, já que uma única operação pode passar por SQLite, sistema de arquivos e seletor de arquivos ao mesmo tempo, então eles também entregam o erro capturado ao `ErrorReporter`: o toast diz uma frase, o report guarda a causa.

## Design system (`packages/app_ui`)

Um pacote Flutter autocontido, versionado e testado independentemente do app (seu próprio job de CI, seu próprio limite de cobertura). Ele exporta:

- **Tokens**: `AppSpacing`, `AppSizes`, `AppRadius`, `AppDurations`, `AppCurves`, `AppBreakpoints`, escalas de tipografia e cor.
- **Tema**: `AppTheme` claro/escuro, exposto aos widgets via uma extensão de `BuildContext` (`context.colors`).
- **Componentes**: botões, cards, diálogos, sheets, navegação, feedback (toasts), estados (vazio/erro/permissão/indexação), e o primitivo de interação `Pressable` sobre o qual todo widget tocável é construído.

O app nunca redefine uma cor, um valor de espaçamento ou uma curva de animação inline. Tudo vem do `app_ui`.

## Testes

Veja a seção Testes do README para os números atuais de arquivos e limites de cobertura. Em resumo: testes unitários para repositórios/casos de uso/view models, testes de widget para telas/componentes (incluindo golden tests para o design system e telas-chave), e alguns fluxos ponta a ponta em `integration_test/` (onboarding → scan → Início, reprodução a partir da biblioteca, e persistência de dados através de um restart simulado).
