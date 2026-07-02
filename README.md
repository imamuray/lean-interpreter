# lean-interpreter

Lean 4 で実装した簡単なインタプリタです。  
整数の四則演算、変数、let構文をサポートしています。

## 機能

- 整数の計算（+ - * /）
- 変数
- let 式
- REPL（対話実行）

例：
```
> 1 + 2 * 3
7
let x = 10 in x + 2
> 12
```

## 開発環境

以下のいずれかで開発できます。

### VSCode + Dev Container

- VSCodeでリポジトリを開く
- Dev Containers 拡張を使用
- 「Reopen in Container」を選択

### GitHub Codespaces

- リポジトリをCodespacesで開く
- Dev Containerが自動で起動する

## ビルド方法

プロジェクトのビルド：

```bash
lake build
```

## 実行方法

インタプリタの実行：

```bash
lake exe interpreter
```
