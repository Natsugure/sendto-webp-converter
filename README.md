# sendto-webp-converter
Windows環境で画像ファイルを簡単にWebP形式に変換するPowerShellスクリプトです。右クリックの「送る」メニューから直接実行できます。

## 機能
- 複数の画像ファイルを一括でWebP形式に変換
- Windows エクスプローラーの右クリックの「送る」メニューから直接実行

## 対応ファイル形式
- JPEG (.jpg, .jpeg)
- PNG (.png)
- TIFF (.tiff, .tif)

## 必要な環境
- Windows 10/11
- PowerShell 5.1以上

## インストール方法
### 1. このリポジトリを`git clone`またはダウンロード

```
git clone https://github.com/Natsugure/sendto-webp-converter.git
```

### 2. install.batを実行する
`install.bat`をダブルクリックして実行すると、sendtoフォルダにショートカットが作成され、「送る」メニューに「WebPに変換」が追加されます。

## 使用方法
1. 画像ファイル(JPG/PNG/TIFF)を右クリック（複数選択可）
2. 「送る」→「WebPに変換」を選択
3. 変換されたファイルは同じフォルダの「webp_output」に保存されます

## アンインストール方法
1. `uninstall.bat`を実行し、SendToフォルダのショートカットを削除します。
2. スクリプトが含まれるフォルダを全てごみ箱に入れて削除します。

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Third-party Components

This project includes third-party software components:
- `bin/cwebp.exe`: BSD 3-Clause License (Google Inc.) - see [NOTICE.txt](NOTICE.txt) for details