# Contribuindo

<p align="center">
<a href="contributing.md">English</a> · <a href="contributing.es.md">Español</a> · <strong>Português (BR)</strong> · <a href="contributing.zh.md">中文</a>
</p>

Obrigado por considerar contribuir. Este documento cobre a configuração do ambiente, convenções, e o que um pull request precisa ter antes de estar pronto para revisão. Pra entender como o código está organizado, veja [`architecture.md`](architecture.pt-BR.md).

## Configuração

O projeto trava a versão do SDK do Flutter via [FVM](https://fvm.app/), então todo comando abaixo usa `fvm flutter` em vez de um `flutter` instalado direto.

```sh
git clone https://github.com/dariomatias-dev/music_app.git
cd music_app
fvm install
fvm flutter pub get
git config core.hooksPath .githooks
```

Essa última linha aponta o git para [`.githooks/`](../.githooks), onde um hook `commit-msg` rejeita um assunto que não segue a convenção descrita abaixo. O git não compartilha hooks pelo clone, então é um comando por cópia local.

Código gerado (freezed, json_serializable, drift, riverpod_generator, go_router_builder) e as localizações não ficam versionados já compilados a cada mudança. Regenere depois de puxar o repositório ou editar qualquer coisa que dependa deles:

```sh
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter gen-l10n
```

Os ícones do launcher também são gerados, a partir da arte em `assets/icons/`. Regenere depois de alterá-la e versione o que for escrito em `android/` e `ios/`:

```sh
fvm dart run flutter_launcher_icons
```

Execute o app em um dispositivo conectado ou emulador com `fvm flutter run`.

### Dados de exemplo

Até que uma varredura encontre arquivos de áudio no dispositivo, o app abre com uma biblioteca vazia, o que é um jeito lento de olhar para uma tela. Execute com os seeds de desenvolvimento:

```sh
fvm flutter run --dart-define=SEED_ENABLED=true
```

Isso escreve uma biblioteca com artistas, álbuns, faixas, playlists, favoritos, histórico de reprodução e buscas recentes, datados em relação ao momento da execução. Executar de novo substitui essas linhas em vez de adicionar uma segunda cópia, e não toca em mais nada no banco.

A flag é de tempo de compilação e os seeds se recusam a rodar fora do modo debug, então nem os dados de exemplo nem o código que os escreve chegam a uma build de release.

Para preencher um arquivo de banco sem dispositivo e sem build, `dart run scripts/seed.dart` escreve um em `build/seed/`.

## Antes de abrir um pull request

- **Abra uma issue primeiro** para discutir a mudança, a menos que seja uma correção pequena e óbvia.
- **Siga a estrutura existente**: feature-first, camadas `data`/`domain`/`presentation`, Riverpod para o estado, e nenhum padrão novo sem discutir antes. Veja [`architecture.md`](architecture.pt-BR.md).
- **Mantenha as telas enxutas**: uma tela compõe widgets e liga providers. Componentes vão para o próprio arquivo em `presentation/widgets/<nome_da_tela>/`, não como classes privadas no fim do arquivo da tela, nem como métodos auxiliares `_buildX()`. Veja [Organização dos widgets](architecture.pt-BR.md#organização-dos-widgets).
- **Combine com o design system**: nada de cor, espaçamento ou duração inline. Use os tokens e componentes do `packages/app_ui`.
- **Adicione testes** para qualquer coisa com lógica: um método de repositório, um caso de uso, um `ViewModel`, o comportamento de um widget. O `packages/app_ui` é um pacote separado com sua própria suíte de testes; mudanças ali também precisam dos próprios testes.
- **Todo documento, string e recurso localizado sai em todo idioma suportado** (inglês, espanhol, português, chinês): os arquivos `lib/l10n/*.arb`, e qualquer documentação em `docs/`. O [`scripts/check_l10n.sh`](../scripts/check_l10n.sh) garante a parte dos ARB, no `verify.sh` e no CI.
- **Execute a checagem completa localmente** antes do push:

  ```sh
  ./scripts/verify.sh
  ```

  Ele executa o que o CI executa, limitado aos pacotes que você mudou: formatação, análise, testes e o limite de cobertura (97% para o app, 98% para `packages/app_ui`). Use `--gen` quando a mudança tocou algo que o `build_runner` ou o `gen-l10n` leem, `--all` para checar os dois pacotes independentemente do que mudou, ou `--skip-tests` para uma passada rápida de formatação e análise no meio do trabalho.

  As mesmas checagens na mão, rodadas dentro do pacote que está sendo alterado:

  ```sh
  fvm flutter analyze
  fvm dart format --output=none --set-exit-if-changed lib test
  fvm flutter test --coverage
  ./scripts/check_coverage.sh coverage/lcov.info 97
  ```

- **Mensagens de commit** seguem [Conventional Commits](https://www.conventionalcommits.org/), verificadas pelo hook `commit-msg` ativado na instalação:

  ```
  <tipo>(<escopo opcional>): <assunto>
  ```

  O tipo é um de `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style` ou `test`; o escopo vai em minúsculas (`player`, `app_ui`, `l10n`); o assunto é curto e no imperativo, começa em minúscula e não leva ponto final. Use `!` antes dos dois pontos para uma mudança incompatível.

  O hook também mantém a mensagem no formato que as ferramentas do git esperam: a linha de assunto inteira fica dentro de **72 caracteres**, que é onde o `git log --oneline` e o GitHub cortam; o corpo é separado do assunto por uma linha em branco, e suas linhas quebram em **80**. URLs, footers como `Co-Authored-By:`, `BREAKING CHANGE:` e `Refs #123`, e blocos de código cercados ficam isentos, porque quebrá-los destrói o que eles significam. Commits de merge e revert que o próprio git escreve ficam de fora. Olhe o `git log` para ver exemplos já no repositório.

## O que o CI checa

Todo push e pull request executa o [`.github/workflows/ci.yaml`](../.github/workflows/ci.yaml), em cinco jobs:

| Job | O que faz |
| --- | --- |
| `Vulnerabilities` | Analisa o `pubspec.lock` e o `packages/app_ui/pubspec.lock` contra a base OSV com o [OSV-Scanner](https://google.github.io/osv-scanner/), que cobre os avisos do pub. Executa de forma independente dos demais jobs, já que um aviso recém-divulgado não é motivo para impedir que os testes reportem. |
| `music_app` | Instala dependências, regenera código e localizações, e então **falha se essa regeneração produzir um diff**, pois os arquivos gerados precisam estar commitados e atualizados. Depois: formatação, análise, testes e o limite de 97% de cobertura, e envia o relatório para o Codecov sob a flag `app`. |
| `Build APK` | Executa depois do `music_app` passar, e builda uma APK de release, publicada como artefato do workflow e mantida por 14 dias. |
| `packages/app_ui` | Formatação, análise, testes e o limite de 98% de cobertura do pacote do design system, de forma independente do app, enviado ao Codecov sob a flag `app_ui`. |
| `Integration tests` | Executa depois do `music_app` passar, inicia um emulador Android e executa nele todas as suítes de `integration_test/` em uma mesma sessão, já que subir o emulador é de longe o passo mais lento. Elas exigem um device: os fluxos leem através das stream queries do drift, que nunca emitem sob o fake async de um `flutter test` comum. O job habilita o KVM antes, sem o qual o emulador cai em renderização por software e estoura o tempo. Ele também builda uma APK de debug **antes** de subir o emulador: um build Android frio baixa uma plataforma extra do SDK e o CMake e compila fontes nativas, o que sozinho ultrapassa o limite de 8 minutos sob o qual cada suíte executa. Somando os dois, o job tem orçamento de 40 minutos. |

As releases são preparadas pelo [release-please](https://github.com/googleapis/release-please). Ele lê os Conventional Commits integrados na `main` e mantém um pull request aberto com a próxima versão e a entrada de `CHANGELOG.md` derivada deles. Ao fazer merge desse pull request, a versão é escrita no `pubspec.yaml`, o commit é marcado com a tag e o release do GitHub é publicado.

O [`.github/workflows/release.yml`](../.github/workflows/release.yml) então executa as mesmas checagens do CI e anexa a APK de release. Ele é chamado diretamente pelo [`release_please.yml`](../.github/workflows/release_please.yml), já que o GitHub não inicia um workflow a partir de uma tag publicada com o token padrão, e continua respondendo a uma tag `v*.*.*` publicada à mão, criando o release por conta própria nesse caso. Vale notar que o build de release é assinado com a **keystore de debug** de propósito, pois este app não tem configuração de assinatura de produção.

### Relatórios de cobertura

O [`scripts/check_coverage.sh`](../scripts/check_coverage.sh) é o que reprova um build; o [Codecov](https://codecov.io/gh/dariomatias-dev/music_app) é o que torna o número legível. Cada pacote envia seu `lcov.info` sob a própria flag, então os dois limites são acompanhados separadamente, e cada pull request recebe um comentário com a variação por flag e anotações inline nas linhas novas sem cobertura. O [`codecov.yml`](../codecov.yml) guarda os alvos e repete as exclusões do script: fontes geradas, `lib/l10n/` e as declarações de tabelas do drift.

Os envios se autenticam com um secret de repositório `CODECOV_TOKEN`. Pull requests vindos de forks não conseguem lê-lo e caem no envio sem token do Codecov, por isso o passo está deliberadamente com `fail_ci_if_error: false`: um envio que falha é um relatório faltando, nunca um build reprovado.

Para o mesmo resultado localmente, sem conta, renderize o arquivo `lcov` em HTML:

```sh
fvm flutter test --coverage
genhtml coverage/lcov.info -o coverage/html   # apt install lcov
xdg-open coverage/html/index.html
```

### Rodando os workflows localmente

O [`act`](https://github.com/nektos/act) executa os workflows no Docker, o que vale a pena antes do push em qualquer mudança em `.github/workflows/`. O `.actrc` do repositório já fixa a imagem do runner, então nenhuma flag é necessária:

```sh
act -l                                # lista todos os jobs, com id e stage
act pull_request                      # tudo que o CI rodaria em um PR
act pull_request -j app               # um job só, pelo id
act pull_request -j app --dryrun      # imprime os passos sem executar
```

O `act` não executa a action do job de emulador, então duas restrições dela só aparecem no CI. A action divide o `script` por quebra de linha e executa **cada linha como um `sh -c` próprio**, então um loop ou qualquer construção shell de várias linhas chega sem a palavra-chave de fechamento; escreva um comando completo por linha. Além disso, o `--no-dds`, o primeiro instinto quando uma execução falha ao subir o Dart Development Service, quebra o comparador de goldens que o `flutter_tools` registra para integration tests, e a suíte passa a falhar no load mesmo com todos os testes passando.

O `-j` recebe o **id** do job (`vulnerabilities`, `app`, `build_apk`, `integration`, `app_ui`, `release`), não o nome de exibição da tabela acima; o `act -l` mostra os dois. A primeira execução de verdade baixa uma imagem de runner de vários gigabytes, e o `act` aproxima os runners do GitHub em vez de reproduzi-los exatamente, então um `act` verde é um bom sinal, não uma garantia.

## Trabalhando com um agente de IA

O repositório carrega a própria configuração de agente, para que um assistente siga o mesmo processo que um contribuidor em vez de improvisar um a cada prompt:

- [`CLAUDE.md`](../CLAUDE.md) é o acordo de trabalho, lido a cada turno: onde o código vai, o que cada tipo de mudança obriga a testar e quais documentos uma mudança invalida.
- [`.claude/skills/ship-change/SKILL.md`](../.claude/skills/ship-change/SKILL.md) guarda as receitas por tipo de mudança: um serviço de `core`, uma feature, um componente de `app_ui`, uma mudança de schema com a migração, um texto localizado, um bump de dependência.
- [`.claude/settings.json`](../.claude/settings.json) liga dois hooks. Todo arquivo Dart escrito é formatado na hora, e um hook `Stop` se recusa a encerrar o turno enquanto houver mudanças de código que não passaram no `./scripts/verify.sh`.
- [`.github/pull_request_template.md`](../.github/pull_request_template.md) coloca a mesma checklist na frente de quem revisa.

Nada disso substitui o CI, que continua sendo a autoridade. Existe para que a checagem local bata com o que o CI vai dizer. Mudar o acordo, as receitas ou os hooks é uma mudança normal: atualize esta seção junto.

## Atualizações de dependências

O [Renovate](https://docs.renovatebot.com/) está configurado em [`renovate.json`](../renovate.json) e abre pull requests semanais para pub, Gradle e GitHub Actions, acompanhando os dois arquivos `pubspec.yaml`. Ele também mantém uma issue de Dependency Dashboard listando tudo o que está segurando e por quê.

Os pins do [`dependencies.md`](dependencies.pt-BR.md) ficam codificados ali em vez de dependerem de serem pegos na revisão: `drift`, `sqlite3`, `intl` e `flutter_rust_bridge` estão desabilitados por completo, o Gradle e o Android Gradle Plugin ficam limitados abaixo da linha 9.x, e os pacotes do Riverpod são agrupados para a cadeia se mover junta. Isso substitui o ritual semanal de fechar pull requests que os pins proíbem.

Esses pull requests passam pelo mesmo CI que qualquer outro. Quando um pin for levantado, remova a regra dele do `renovate.json` na mesma mudança que atualizar o [`dependencies.md`](dependencies.pt-BR.md).

## Código de Conduta

A participação neste projeto é regida pelo [Código de Conduta](code_of_conduct.pt-BR.md).
