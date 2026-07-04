# lean-interpreter

Lean 4 で実装した簡単なインタプリタです。  

## 機能

- 整数の計算（+ - * /）
- bool値と比較演算 (< ==)
- 変数
- let 式
- if 式
- REPL（対話実行）

例：
```
> 1 + 2 * 3
7
> if 1 == 1 then 3 else 4
1
> let x = 10 in x + 2
12
```

## 開発環境

以下のいずれかで開発できます。
開発に必要なツール一式はDev Containerで自動で揃います。

### VSCode + Dev Container

- VSCodeでリポジトリを開く
- Dev Containers 拡張を使用
- 「Reopen in Container」を選択

### GitHub Codespaces

- リポジトリをCodespacesで開く
- Dev Containerが自動で起動する

## ビルドと実行方法

プロジェクトのビルド：

```bash
lake build
```

インタプリタの実行：

```bash
lake exe interpreter
```
