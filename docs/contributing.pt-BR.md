# Contribuindo

<p align="center">
<a href="contributing.md">English</a> · <a href="contributing.es.md">Español</a> · <strong>Português (BR)</strong> · <a href="contributing.zh.md">中文</a>
</p>

Obrigado por considerar contribuir. Este documento cobre a configuração do ambiente, convenções, e o que um pull request precisa ter antes de estar pronto pra revisão. Pra entender como o código está organizado, veja [`architecture.md`](architecture.pt-BR.md).

## Configuração

O projeto trava a versão do SDK do Flutter via [FVM](https://fvm.app/), então todo comando abaixo usa `fvm flutter` em vez de um `flutter` instalado direto.

```sh
git clone https://github.com/dariomatias-dev/music_app.git
cd music_app
fvm install
fvm flutter pub get
```

Código gerado (freezed, json_serializable, drift, riverpod_generator, go_router_builder) e as localizações não ficam versionados já compilados a cada mudança — regenere depois de puxar o repositório ou editar qualquer coisa que dependa deles:

```sh
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter gen-l10n
```

Rode o app num dispositivo conectado ou emulador com `fvm flutter run`.

## Antes de abrir um pull request

- **Abra uma issue primeiro** pra discutir a mudança, a menos que seja uma correção pequena e óbvia.
- **Siga a estrutura existente**: feature-first, camadas `data`/`domain`/`presentation`, Riverpod pro estado, e nenhum padrão novo sem discutir antes. Veja [`architecture.md`](architecture.pt-BR.md).
- **Mantenha as telas enxutas**: uma tela compõe widgets e liga providers. Componentes vão pro próprio arquivo em `presentation/widgets/<nome_da_tela>/` — não como classes privadas no fim do arquivo da tela, nem como métodos auxiliares `_buildX()`. Veja [Organização dos widgets](architecture.pt-BR.md#organização-dos-widgets).
- **Combine com o design system**: nada de cor, espaçamento ou duração inline — use os tokens e componentes do `packages/app_ui`.
- **Adicione testes** pra qualquer coisa com lógica: um método de repositório, um caso de uso, um `ViewModel`, o comportamento de um widget. O `packages/app_ui` é um pacote separado com sua própria suíte de testes; mudanças ali também precisam dos próprios testes.
- **Todo documento, string e recurso localizado sai em todo idioma suportado** (inglês, espanhol, português, chinês) — os arquivos `lib/l10n/*.arb`, e qualquer documentação em `docs/`.
- **Rode a checagem completa localmente** antes de dar push:

  ```sh
  ./scripts/verify.sh
  ```

  Ele roda o que o CI roda, limitado aos pacotes que você mudou: formatação, análise, testes e o limite de cobertura (97% para o app, 98% para `packages/app_ui`). Use `--gen` quando a mudança tocou algo que o `build_runner` ou o `gen-l10n` leem, `--all` para checar os dois pacotes independentemente do que mudou, ou `--skip-tests` para uma passada rápida de formatação e análise no meio do trabalho.

  As mesmas checagens na mão, rodadas dentro do pacote que está sendo alterado:

  ```sh
  fvm flutter analyze
  fvm dart format --output=none --set-exit-if-changed lib test
  fvm flutter test --coverage
  ./scripts/check_coverage.sh coverage/lcov.info 97
  ```

- **Mensagens de commit** seguem [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `ci:`, etc., com um assunto curto no imperativo. Olhe o `git log` pra ver exemplos já no repositório.

## O que o CI checa

Todo push e pull request roda o [`.github/workflows/ci.yaml`](../.github/workflows/ci.yaml), em quatro jobs:

| Job | O que faz |
| --- | --- |
| `music_app` | Instala dependências, regenera código e localizações, e então **falha se essa regeneração produzir um diff** — os arquivos gerados precisam estar commitados e atualizados. Depois: formatação, análise, testes e o limite de 97% de cobertura. |
| `Build APK` | Roda depois do `music_app` passar, e builda uma APK de release, publicada como artefato do workflow e mantida por 14 dias. |
| `packages/app_ui` | Formatação, análise, testes e o limite de 98% de cobertura do pacote do design system, de forma independente do app. |
| `Integration tests` | Roda depois do `music_app` passar, sobe um emulador Android e roda nele todas as suítes de `integration_test/` numa mesma sessão, já que subir o emulador é de longe o passo mais lento. Elas exigem um device: os fluxos leem através das stream queries do drift, que nunca emitem sob o fake async de um `flutter test` comum. O job habilita o KVM antes — sem ele o emulador cai em renderização por software e estoura o tempo — e por isso tem orçamento de 45 minutos. |

Dar push numa tag `v*.*.*` roda o [`.github/workflows/release.yml`](../.github/workflows/release.yml): as mesmas checagens, e então uma APK de release publicada num release do GitHub com notas geradas automaticamente. Vale notar que o build de release é assinado com a **keystore de debug** de propósito — este app não tem configuração de assinatura de produção.

### Rodando os workflows localmente

O [`act`](https://github.com/nektos/act) roda os workflows no Docker, o que vale a pena antes de dar push em qualquer mudança em `.github/workflows/`. O `.actrc` do repositório já fixa a imagem do runner, então nenhuma flag é necessária:

```sh
act -l                                # lista todos os jobs, com id e stage
act pull_request                      # tudo que o CI rodaria num PR
act pull_request -j app               # um job só, pelo id
act pull_request -j app --dryrun      # imprime os passos sem executar
```

O `-j` recebe o **id** do job (`app`, `build_apk`, `integration`, `app_ui`, `release`), não o nome de exibição da tabela acima; o `act -l` mostra os dois. A primeira execução de verdade baixa uma imagem de runner de vários gigabytes, e o `act` aproxima os runners do GitHub em vez de reproduzi-los exatamente — um `act` verde é um bom sinal, não uma garantia.

## Trabalhando com um agente de IA

O repositório carrega a própria configuração de agente, para que um assistente siga o mesmo processo que um contribuidor em vez de improvisar um a cada prompt:

- [`CLAUDE.md`](../CLAUDE.md) é o acordo de trabalho, lido a cada turno: onde o código vai, o que cada tipo de mudança obriga a testar e quais documentos uma mudança invalida.
- [`.claude/skills/ship-change/SKILL.md`](../.claude/skills/ship-change/SKILL.md) guarda as receitas por tipo de mudança: um serviço de `core`, uma feature, um componente de `app_ui`, uma mudança de schema com a migração, um texto localizado, um bump de dependência.
- [`.claude/settings.json`](../.claude/settings.json) liga dois hooks. Todo arquivo Dart escrito é formatado na hora, e um hook `Stop` se recusa a encerrar o turno enquanto houver mudanças de código que não passaram no `./scripts/verify.sh`.
- [`.github/pull_request_template.md`](../.github/pull_request_template.md) coloca a mesma checklist na frente de quem revisa.

Nada disso substitui o CI, que continua sendo a autoridade. Existe para que a checagem local bata com o que o CI vai dizer. Mudar o acordo, as receitas ou os hooks é uma mudança normal: atualize esta seção junto.

## Atualizações de dependências

O Dependabot está configurado em [`.github/dependabot.yml`](../.github/dependabot.yml) e abre pull requests semanais pra quatro ecossistemas: pub (o app), pub (`packages/app_ui`), Gradle (`android/`) e GitHub Actions.

Esses pull requests passam pelo mesmo CI que qualquer outro. Antes de aprovar um, veja o [`dependencies.md`](dependencies.pt-BR.md): alguns pacotes estão presos abaixo da última versão de propósito, e um PR do Dependabot que suba uma dessas cadeias deve ser fechado, não mergeado.

## Código de Conduta

A participação neste projeto é regida pelo [Código de Conduta](code_of_conduct.pt-BR.md).
