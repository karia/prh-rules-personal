# karia個人用テキスト校正ルール集

```bash
mise up
./scripts/check.sh /path/to/file.md
```

prh・JTF-style・技術文書向けルールをまとめて実行する。自動修正はしない。個別に実行する場合は、以下の通り。

## prh

```bash
mise up
prh --rules profiles/default.yml /path/to/file.md
prh --diff --rules profiles/default.yml /path/to/file.md
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
