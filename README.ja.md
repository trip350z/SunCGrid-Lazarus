# SunColGrid Lazarus / LCL版

[English](README.md) · [GitHub](https://github.com/trip350z/SunCGrid-Lazarus) · [CI](https://github.com/trip350z/SunCGrid-Lazarus/actions/workflows/build.yml)

Delphi 7用 SunCGrid.pas（SUNTEC、2000–2009）を基にした移植版です。
ソースはUTF-8です。原作者表記を保持しています。元コードには明示的なライセンス条件が記載されていないため、リポジトリ全体にMIT等を付与していません。[LICENSE](LICENSE)と[NOTICE.md](NOTICE.md)を確認してください。公開されていること自体は、元コードの再利用・再配布条件を新たに許諾するものではありません。

## インストール

1. Lazarusで「パッケージ → パッケージファイルを開く」から `sungridlcl.lpk` を開きます。
2. 「コンパイル」を実行します。
3. 「使用 → インストール」を選び、IDEを再構築します。
4. コンポーネントパレットの「164SYSTEMS」に `TSunColGrid` が追加されます。

IDEへの登録が不要な場合は、SunCGrid.pasをプロジェクトのユニット検索パスに置き、usesにSunCGridを追加して生成できます。

## サンプル

`demo/SunGridDemo.lpi` をLazarusで開いて実行してください。
日本語、列の配置指定、交互色、セル背景色、複数行、登録フォント、選択に対応する固定セル色を確認できます。
コマンドラインでは `lazbuild demo/SunGridDemo.lpi` でビルドします。

## Windows / Linux / macOS

同じSunCGrid.pasを各OSのLazarus / LCLでコンパイルする構成です。
OSごとの動作保証済みという意味ではなく、以下をビルド・確認対象としています。

| OS | ウィジェットセット | サンプルプロジェクト |
| --- | --- | --- |
| Windows | win32 | demo/SunGridDemo.lpi |
| Linux | gtk2 / qt5 / qt6 | demo/SunGridDemo.lpi |
| macOS | cocoa | demo/SunGridDemoMac.lpi |

各OSに、そのCPU向けのFree Pascal、Lazarus、対象ウィジェットセットのLCLと開発用ライブラリを用意してください。
LinuxのQt版は、選んだQtバージョンに対応するLCLバインディングと実行時ライブラリも必要です。
macOSはXcode Command Line ToolsとmacOS SDKを用意し、Cocoa用の64bit環境を使用します。
IntelとApple Siliconは、それぞれのCPU向けツールチェーンで別々にビルドしてください。
このスクリプトは各OS上でのネイティブビルド用です。

Linuxではリポジトリのルートで実行します。

```sh
sh build.sh gtk2
# Qtを使う場合（対応するLCLとライブラリが必要）
sh build.sh qt5
sh build.sh qt6
./demo/SunGridDemo
```

macOSでは次を実行します。

```sh
sh build.sh cocoa
open demo/SunGridDemo.app
```

lazbuildがPATHにない場合は、Lazarusのインストール先をPATHに追加してください。
IDEから使う場合も、同じsungridlcl.lpkを開いてコンパイル・インストールします。
macOSのIDEではSunGridDemoMac.lpiを開き、LCLウィジェットタイプにCocoaを指定します。
macOS用プロジェクトはUseAppBundleを有効にしています。配布用の署名・公証は含みません。

ソースとプロジェクトは同じフォルダー構成でコピーしてください。Linuxなどではファイル名の大文字・小文字を保持します。
コンパイル済みユニットはCPU・OS・ウィジェットセットごとのディレクトリに出力します。
日本語フォント名は固定していないため、各OSに日本語を表示できるフォントが必要です。
文字入力はLCLの標準セルエディターに任せています。IMEやコピー・貼り付けは各OSで確認してください。
ブラシのハッチ模様、フォーカス枠、折り返し位置はウィジェットセットによって見た目が異なる場合があります。

## 互換性と変更点

- クラス名TSunColGrid、元の追加プロパティとメソッド名を維持しました。TowColors、ClearStingsという元の綴りも維持しています。
- CellColorsなどの添字は0始まりです。行番号-1は通常行向けの列共通設定です。個別セルの設定がある場合、そのレコード全体が優先されます。
- FontCount / AddFont / CellFontsを維持し、フォント番号-1はグリッドの標準フォントを表します。
- TTextLayoutはLCLのGraphics.TTextLayoutへの型別名です。
- Windows API描画をLCLのCanvas.TextRect / TTextStyleに置き換えました。日本語や折り返しの描画結果はOS・フォント・ウィジェットセットによって異なります。
- ClearAllCellParams後の二重解放、境界チェック、DeleteFont後のインデックスずれ、設計時の内部リスト未確保を修正しました。
- 列数を減らして再び増やした場合は、その列の設定が残ります。全消去はClearAllCellParamsで行います。行・列の移動や挿入に設定を追従する処理は追加していません。
- 既存DelphiフォームのDFMからLFMへの変換は、このパッケージとは別にLazarusで行ってください。
- DelphiのDCUはFree Pascalで利用できないため、PASから再コンパイルします。元のDCRは読み込まず、IDEの標準アイコンを使用します。

## 検証状況

パッケージと両サンプルプロジェクトのXML構文、参照ファイルの存在、ソース内のWindows API依存の除去、build.shのLF改行を確認しました。
Windows x64 / FPC 3.2.2でパッケージ・デモ・テストをローカル検証しました。2026-11-23の[CI検証](https://github.com/trip350z/SunCGrid-Lazarus/actions/runs/45105065514)で、Windows x64、Linux GTK2、macOS Intel Cocoaのビルドと回帰テストがすべて通過しました。最新の結果はCIリンクを確認してください。IDE登録、画面の見た目、IME、Qt、Apple Siliconは別途確認が必要です。
Lazarus上でビルド後、サンプルの表示、セル編集、選択移動、ClearAllCellParamsの繰り返し呼び出しを確認してください。

各OSで確認する項目:

- ビルドとIDEへの登録、サンプルの起動・終了。
- 日本語と「A&B」の表示、左・中央・右寄せ、複数行と折り返し。
- セルの編集、日本語IME、コピー・貼り付け。
- 選択移動時の固定セル色、スクロール、罫線、ブラシ模様。
- 高DPI / Retinaでの表示、セル幅を極端に狭くした際の描画。
- ClearAllCellParamsの繰り返し呼び出し、フォント追加・削除。

LCLの罫線処理は公式の[DrawCellGridリファレンス](https://lazarus-ccr.sourceforge.io/docs/lcl/grids/tcustomgrid.drawcellgrid.html)に合わせています。

## Windowsビルドと回帰テスト

WindowsのPowerShellでは `./build.ps1`、lazbuildがPATHにない場合は `./build.ps1 -LazBuild 'E:\path\to\lazbuild.exe'` でビルドできます。
Linux/macOSのbuild.shもパッケージ・サンプル・テストを一式ビルドします。
Ubuntu/DebianではLazarusの補助ユニットとしてfp-units-miscも用意してください。

テストはtests/SunGridSmoke.lpiです。ビルド後にWindowsでは `./tests/SunGridSmoke.exe`、Linux/macOSでは `./tests/SunGridSmoke` を実行します。
GTKのヘッドレス環境では `xvfb-run -a ./tests/SunGridSmoke` を使用します。
セルパラメーター、境界値、フォントの所有関係と番号調整、繰り返し消去時のキャッシュ、列数の縮小・復元を検証します。
描画や操作の見た目を保証するテストではありません。

貢献方法は[CONTRIBUTING.md](CONTRIBUTING.md)、変更履歴は[CHANGELOG.md](CHANGELOG.md)を参照してください。
