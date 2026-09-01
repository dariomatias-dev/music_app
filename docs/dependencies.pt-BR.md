# Notas de Dependências

<p align="center">
<a href="dependencies.md">English</a> · <a href="dependencies.es.md">Español</a> · <strong>Português (BR)</strong> · <a href="dependencies.zh.md">中文</a>
</p>

A maioria das dependências no `pubspec.yaml` usa uma faixa flexível (`^x.y.z`) e é atualizada livremente. Algumas (ali, e nos arquivos de build do Android) ficam presas em uma versão exata, ou limitadas abaixo da última disponível, por motivos que não são óbvios só olhando a constraint. Este documento é esse contexto, para ninguém precisar redescobrir do zero (ou pior, "corrigir" o pin sem entender por que ele existe).

## `intl: 0.20.2` (pin exato)

Forçado pelo `flutter_localizations`, que vem do próprio SDK do Flutter, não do pub.dev. A versão do SDK do Flutter instalada dita qual versão do `intl` o `flutter_localizations` exige; atualizar o `intl` sozinho, sem antes atualizar o SDK do Flutter, vai falhar na resolução.

## `drift: 2.31.0`, `drift_dev: 2.31.0` (pin exato, abaixo da última versão)

`drift`/`drift_dev` 2.32.0+ exigem `analyzer` na faixa `^10.0.0–^13.0.0`. O `riverpod_generator` (atualmente `^3.0.0`) depende transitivamente do `riverpod_analyzer_utils`, que limita o `analyzer` bem abaixo disso (`^7`–`^9`, nas versões compatíveis com `riverpod_generator ^3.0.0`). As duas faixas não se sobrepõem, então `drift`/`drift_dev` ficam travados na última versão compatível com a faixa de analyzer que o `riverpod_generator ^3.0.0` permite.

**Não é um bump pequeno.** Destravar o `drift` exige `drift_dev 2.34+`, que precisa de `analyzer ^13`. A única versão do `riverpod_analyzer_utils` que também aceita `analyzer ^13` é a `1.0.0-dev.11`, que só é distribuída como dependência transitiva do `riverpod_generator ^4.0.8`. Isso, por sua vez, exige `riverpod_annotation ^4.0.6`, um **bump de versão major do próprio Riverpod**, que também levaria o `flutter_riverpod` para 4.x e provavelmente afetaria código gerado e a sintaxe de providers no app inteiro. Acompanhe isso upstream; não tente fazer como um bump de dependência isolado.

## `sqlite3_flutter_libs: 0.5.42` (pin exato, abaixo da última versão)

A última versão do pacote (`0.6.0+eol`) é um tombstone intencional, um pacote vazio cuja descrição diz *"Not used anymore, update to version 3.x of package:sqlite3 instead"* (não é mais usado, atualize para versão 3.x do package:sqlite3). Os binários nativos dele deixam de ser necessários quando o `sqlite3` (os bindings Dart) migra para sua linha 3.x, que passa a cuidar disso sozinho.

Essa migração é **o mesmo bloqueio do pin do `drift` acima**, não um separado: `sqlite3` 3.x exige `drift ^2.34`, e o `drift` 2.31.0 (travado pelo motivo acima) só aceita `sqlite3 ^2.6`. Resolver a cadeia `drift`/Riverpod resolve esse também, então não tente atualizar `sqlite3_flutter_libs` ou `sqlite3` isoladamente.

## `gradle-wrapper: 8.14`, `com.android.application: 8.11.1` (limitados abaixo da última versão)

O `metadata_god` embute o CargoKit, cujo script Gradle chama `exec()`, método que o Gradle 9 removeu. Qualquer bump para o Gradle 9.x quebra o build da APK com `Could not find method exec() ... on project ':metadata_god'`, então o wrapper fica na linha 8.x até o `metadata_god` publicar um CargoKit que compile sob o Gradle 9.

O Android Gradle Plugin é **o mesmo bloqueio visto do outro lado**, não um separado: o AGP 9.x se recusa a rodar abaixo do Gradle 9.5.0, falhando com `Minimum supported Gradle version is 9.5.0`. Resolver o bloqueio do CargoKit resolve esse também, então não tente subir nenhum dos dois além da fronteira 9.x isoladamente.

O limite é essa fronteira, não estas versões exatas. Dentro do 8.x os dois podem se mover, e estão no piso que o Flutter avisa que vai passar a exigir (Gradle 8.14, AGP 8.11.1, Kotlin 2.2.20), que compila sem avisos.

## Como checar atualizações

```sh
fvm flutter pub outdated
```

Execute isso de vez em quando para ver o que realmente é resolvível versus o que está bloqueado pelas cadeias acima.

O Dependabot também abre pull requests de atualização semanais (veja o [`contributing.md`](contributing.pt-BR.md#atualizações-de-dependências)). Ele lê as constraints de versão, não este documento, então vai propor de tempos em tempos bumps que as cadeias acima bloqueiam. Feche esses PRs em vez de mergear: os pins têm razão de ser, e cada um só sai junto com a cadeia à qual pertence.
