# karia個人用テキスト校正ルール集

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
