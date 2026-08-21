# karia個人用テキスト校正ルール集

```bash
mise up
./scripts/check.sh /path/to/file.md
```

prh・JTF-style・技術文書向けルール・ひらがな表記・同義語をまとめて実行する。自動修正はしない。
最後に [docs/manual-checks.md](docs/manual-checks.md) を出力する。機械的に検出できない項目を、生成AIに読ませて指摘させるため。

個別に実行する場合は、以下の通り。

## prh

```bash
./scripts/prh.sh /path/to/file.md
```

[textlint-rule-prh](https://github.com/textlint-ja/textlint-rule-prh) 経由で、[prh/rules](https://github.com/prh/rules) と自作の [profiles/karia.yml](profiles/karia.yml) を読ませる。
prh 単体は Markdown を解釈せず、コードブロック・インラインコード・URL の中まで指摘してしまうため。

自作ルールには `specs` を書いてある。prh はルール読み込み時にこれを検証するので、実行のたびに回帰テストが走る。

各ルールには準拠する一般ルールを出典として併記している。主な出典は[公用文作成の考え方（文化審議会建議）](https://www.bunka.go.jp/seisaku/bunkashingikai/kokugo/hokoku/93650001_01.html)と[JTF日本語標準スタイルガイド](https://www.jtf.jp/tips/styleguide)。対応する一般ルールが無いものは「出典なし」と明記している。

単体で動かしたい場合（`--diff` を使いたいときなど）は以下の通り。

```bash
./scripts/mise-exec.sh prh --diff --rules profiles/default.yml --rules profiles/karia.yml /path/to/file.md
```

## textlint

[JTF日本語標準スタイル](https://github.com/textlint-ja/textlint-rule-preset-jtf-style) への準拠確認

```bash
./scripts/jtf-style.sh /path/to/file.md
```

[技術文書向けルール](https://github.com/textlint-ja/textlint-rule-preset-ja-technical-writing)（文長・読点の数・冗長表現・助詞の重複など）の確認

```bash
./scripts/ja-technical-writing.sh /path/to/file.md
```

ひらがなに開いたほうが読みやすい[副詞](https://github.com/textlint-ja/textlint-rule-ja-hiragana-fukushi)・[補助動詞](https://github.com/textlint-ja/textlint-rule-ja-hiragana-hojodoushi)・[形式名詞](https://github.com/textlint-ja/textlint-rule-ja-hiragana-keishikimeishi)の確認

```bash
./scripts/ja-hiragana.sh /path/to/file.md
```

[同義語](https://github.com/textlint-ja/textlint-rule-no-synonyms)の表記ゆれ（申し込みと申込の併用など）の確認

```bash
./scripts/no-synonyms.sh /path/to/file.md
```
