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
- **Combine com o design system**: nada de cor, espaçamento ou duração inline — use os tokens e componentes do `packages/app_ui`.
- **Adicione testes** pra qualquer coisa com lógica: um método de repositório, um caso de uso, um `ViewModel`, o comportamento de um widget. O `packages/app_ui` é um pacote separado com sua própria suíte de testes; mudanças ali também precisam dos próprios testes.
- **Todo documento, string e recurso localizado sai em todo idioma suportado** (inglês, espanhol, português, chinês) — os arquivos `lib/l10n/*.arb`, e qualquer documentação em `docs/`.
- **Rode a checagem completa localmente** antes de dar push:

  ```sh
  fvm flutter analyze
  fvm dart format --output=none --set-exit-if-changed lib test
  fvm flutter test --coverage
  ./scripts/check_coverage.sh coverage/lcov.info 97
  ```

  (Rode os mesmos quatro comandos dentro de `packages/app_ui/` pra mudanças ali; o limite de cobertura lá é 98.)

- **Mensagens de commit** seguem [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `ci:`, etc., com um assunto curto no imperativo. Olhe o `git log` pra ver exemplos já no repositório.

## O que o CI checa

Todo push e pull request roda as mesmas checagens descritas acima, mais uma verificação de que os arquivos gerados (saída do build_runner, localizações) estão commitados e atualizados, e um build da APK de release. Veja `.github/workflows/ci.yml` pros passos exatos.

## Código de Conduta

A participação neste projeto é regida pelo [Código de Conduta](code_of_conduct.pt-BR.md).
