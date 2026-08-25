# Notas de Dependências

<p align="center">
<a href="dependencies.md">English</a> · <a href="dependencies.es.md">Español</a> · <strong>Português (BR)</strong> · <a href="dependencies.zh.md">中文</a>
</p>

A maioria das dependências no `pubspec.yaml` usa uma faixa flexível (`^x.y.z`) e é atualizada livremente. Algumas ficam presas numa versão exata, ou limitadas abaixo da última disponível, por motivos que não são óbvios só olhando o `pubspec.yaml`. Este documento é esse contexto, pra ninguém precisar redescobrir do zero (ou pior, "corrigir" o pin sem entender por que ele existe).

## `intl: 0.20.2` (pin exato)

Forçado pelo `flutter_localizations`, que vem do próprio SDK do Flutter, não do pub.dev. A versão do SDK do Flutter instalada dita qual versão do `intl` o `flutter_localizations` exige; atualizar o `intl` sozinho, sem antes atualizar o SDK do Flutter, vai falhar na resolução.

## `drift: 2.31.0`, `drift_dev: 2.31.0` (pin exato, abaixo da última versão)

`drift`/`drift_dev` 2.32.0+ exigem `analyzer` na faixa `^10.0.0–^13.0.0`. O `riverpod_generator` (atualmente `^3.0.0`) depende transitivamente do `riverpod_analyzer_utils`, que limita o `analyzer` bem abaixo disso (`^7`–`^9`, nas versões compatíveis com `riverpod_generator ^3.0.0`). As duas faixas não se sobrepõem, então `drift`/`drift_dev` ficam travados na última versão compatível com a faixa de analyzer que o `riverpod_generator ^3.0.0` permite.

**Não é um bump pequeno.** Destravar o `drift` exige `drift_dev 2.34+`, que precisa de `analyzer ^13`. A única versão do `riverpod_analyzer_utils` que também aceita `analyzer ^13` é a `1.0.0-dev.11`, que só é distribuída como dependência transitiva do `riverpod_generator ^4.0.8`. Isso, por sua vez, exige `riverpod_annotation ^4.0.6` — um **bump de versão major do próprio Riverpod**, que também levaria o `flutter_riverpod` pra 4.x e provavelmente afetaria código gerado e a sintaxe de providers no app inteiro. Acompanhe isso upstream; não tente fazer como um bump de dependência isolado.

## `sqlite3_flutter_libs: 0.5.42` (pin exato, abaixo da última versão)

A última versão do pacote (`0.6.0+eol`) é um tombstone intencional — um pacote vazio cuja descrição diz *"Not used anymore, update to version 3.x of package:sqlite3 instead"* (não é mais usado, atualize pra versão 3.x do package:sqlite3). Os binários nativos dele deixam de ser necessários quando o `sqlite3` (os bindings Dart) migra pra sua linha 3.x, que passa a cuidar disso sozinho.

Essa migração é **o mesmo bloqueio do pin do `drift` acima**, não um separado: `sqlite3` 3.x exige `drift ^2.34`, e o `drift` 2.31.0 (travado pelo motivo acima) só aceita `sqlite3 ^2.6`. Resolver a cadeia `drift`/Riverpod resolve esse também — não tente atualizar `sqlite3_flutter_libs` ou `sqlite3` isoladamente.

## Como checar atualizações

```sh
fvm flutter pub outdated
```

Rode isso de vez em quando pra ver o que realmente é resolvível versus o que está bloqueado pelas cadeias acima. A seção "Débito técnico" do `ROADMAP.md` rastreia os itens em aberto deste documento que ainda precisam de ação.
