# sendto-webp-converter
Windows環境で画像ファイルを簡単にWebP形式に変換するPowerShellスクリプトです。右クリックの「送る」メニューから直接実行できます。

## 機能
- 複数の画像ファイルを一括でWebP形式に変換
- Windows エクスプローラーの右クリックメニューから直接実行

## 対応ファイル形式
- JPEG (.jpg, .jpeg)
- PNG (.png)
- TIFF (.tiff, .tif)

## 必要な環境
- Windows 10/11
- PowerShell 5.1以上
- Google WebP Tools（cwebp.exe）

## 使用方法
### 1. Google WebP Toolsのインストール
1. 以下のURLから最新版をダウンロード
https://developers.google.com/speed/webp/docs/precompiled?hl=ja

2. 展開した中身を任意のフォルダに配置（例：C:\Tools\webp\）
3. cwebp.exeのパスを環境変数PATHに追加

### 2. このリポジトリを`git clone`またはダウンロード

```
git clone https://github.com/Natsugure/sendto-webp-converter.git
```

### 3. 「送る」メニューにバッチファイルを登録する
エクスプローラのアドレスバーに``shell:sendto`を入力して移動。`scripts\sendto_webp_converter_laucher.bat`のショートカットを作成する。
`.lnk`のファイル名が「送る」メニュー内の表示名になるので、任意の名前に変更する。（例：WebPに変換）

### 4. 画像ファイルを選択して、「送る」メニューからスクリプトを起動する

## ライセンス
MIT License