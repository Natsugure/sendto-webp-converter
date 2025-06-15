[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SendTo Webp Converter インストーラー" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LauncherPath = Join-Path $ScriptDir "scripts\sendto_webp_converter_launcher.bat"
$PowerShellScriptPath = Join-Path $ScriptDir "scripts\sendto_webp_converter.ps1"

if (-not (Test-Path $LauncherPath)) {
    Write-Host "[エラー] ランチャーファイルが見つかりません:" -ForegroundColor Red
    Write-Host $LauncherPath -ForegroundColor Yellow
    Write-Host
    Read-Host "Enterキーを押して終了..."
    exit 1
}

if (-not (Test-Path $PowerShellScriptPath)) {
    Write-Host "[エラー] PowerShellスクリプトが見つかりません:" -ForegroundColor Red
    Write-Host $PowerShellScriptPath -ForegroundColor Yellow
    Write-Host
    Read-Host "Enterキーを押して終了..."
    exit 1
}

# SendToフォルダのパス取得
try {
    $SendToPath = [Environment]::GetFolderPath('SendTo')
    if ([string]::IsNullOrEmpty($SendToPath)) {
        throw "SendToフォルダのパスを取得できませんでした"
    }
} catch {
    Write-Host "[エラー] SendToフォルダのパスを取得できませんでした。" -ForegroundColor Red
    Write-Host "手動で以下のパスにショートカットを作成してください:" -ForegroundColor Yellow
    Write-Host "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\SendTo" -ForegroundColor Yellow
    Write-Host
    Read-Host "Enterキーを押して終了..."
    exit 1
}

Write-Host "SendToフォルダ: " -NoNewline -ForegroundColor Green
Write-Host $SendToPath
Write-Host "ランチャー: " -NoNewline -ForegroundColor Green
Write-Host $LauncherPath
Write-Host

# cwebp.exeの存在確認
Write-Host "cwebp.exeの存在確認中..." -ForegroundColor Yellow
$BinCwebpPath = Join-Path $ScriptDir "bin\cwebp.exe"

if (Test-Path $BinCwebpPath) {
    Write-Host "cwebp.exeが見つかりました。" -ForegroundColor Green
    Write-Host "パス: $BinCwebpPath" -ForegroundColor Cyan
} else {
    Write-Host "[エラー] cwebp.exeが見つかりません。" -ForegroundColor Red
    Write-Host "binディレクトリにcwebp.exeが配置されているかを確認してください。" -ForegroundColor Yellow
    Write-Host "   ダウンロード: https://developers.google.com/speed/webp/docs/precompiled?hl=ja" -ForegroundColor Cyan
    Write-Host
    Read-Host "Enterキーを押して終了..."
    exit 1
}
Write-Host

# ショートカット作成
$ShortcutPath = Join-Path $SendToPath "WebPに変換.lnk"
Write-Host "ショートカットを作成中..." -ForegroundColor Yellow

try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $LauncherPath
    $Shortcut.WorkingDirectory = Join-Path $ScriptDir "scripts"
    $Shortcut.Description = "画像ファイルをWebP形式に変換"
    $Shortcut.IconLocation = "$env:SystemRoot\system32\imageres.dll,190"
    $Shortcut.Save()
    
    Write-Host "ショートカットを作成しました。" -ForegroundColor Green
} catch {
    Write-Host "[エラー] ショートカットの作成に失敗しました。" -ForegroundColor Red
    Write-Host "エラー詳細: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host
    Write-Host "手動で以下の操作を行ってください:" -ForegroundColor Yellow
    Write-Host "1. エクスプローラーのアドレスバーに「shell:sendto」と入力" -ForegroundColor Yellow
    Write-Host "2. 以下のファイルのショートカットを作成:" -ForegroundColor Yellow
    Write-Host "   $LauncherPath" -ForegroundColor Cyan
    Write-Host "3. ショートカット名を「WebPに変換」に変更" -ForegroundColor Yellow
    Write-Host
    Read-Host "Enterキーを押して終了..."
    exit 1
}

# インストール完了確認
if (Test-Path $ShortcutPath) {
    Write-Host
    Write-Host "[成功] インストールが完了しました！" -ForegroundColor Green
    Write-Host
    Write-Host "使用方法:" -ForegroundColor Cyan
    Write-Host "1. 画像ファイル(JPG/PNG/TIFF)を右クリック" -ForegroundColor White
    Write-Host "2. 「送る」→「WebPに変換」を選択" -ForegroundColor White
    Write-Host "3. 変換されたファイルは同じフォルダの「webp_output」に保存されます" -ForegroundColor White
    Write-Host
    Write-Host "ショートカットの場所: " -NoNewline -ForegroundColor Green
    Write-Host $ShortcutPath
    Write-Host
    
    do {
        $OpenSendTo = Read-Host "SendToフォルダを開きますか？ (y/N)"
        if ($OpenSendTo.ToLower() -eq 'y') {
            Start-Process explorer $SendToPath
            break
        } elseif ($OpenSendTo -eq '' -or $OpenSendTo.ToLower() -eq 'n') {
            break
        }
    } while ($true)
} else {
    Write-Host "[エラー] ショートカットが作成されませんでした。" -ForegroundColor Red
    Write-Host "手動でインストールを行ってください。" -ForegroundColor Yellow
}

Write-Host
Read-Host "Enterキーを押して終了..."