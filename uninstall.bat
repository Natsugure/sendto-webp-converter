@echo off
setlocal

set "DIR=%appdata%\Microsoft\Windows\SendTo"
set "FILE=WebPに変換.lnk"
set "FULLPATH=%DIR%\%FILE%"
set "PROJECT_DIR=%~dp0"

echo ===========================================
echo SendTo WebP Converter アンインストーラー
echo ===========================================
echo.

echo %FULLPATH% を削除します。
echo.

if exist "%FULLPATH%" (
    echo ファイルが見つかりました。削除を実行します...
    del "%FULLPATH%"
    if errorlevel 1 (
        echo エラー: ファイルの削除に失敗しました
        pause
        exit /b 1
    ) else (
        echo 「送る」のショートカットの削除に成功しました。
    )
) else (
    echo ファイルが見つかりません: %FULLPATH%
)

echo.
echo ========================================
echo スクリプト全体の削除について
echo ========================================
echo.
echo スクリプトフォルダを完全に削除するには、
echo このアンインストーラー終了後に、以下のフォルダを手動でゴミ箱に移動してください：
echo.
echo %PROJECT_DIR%
echo.
pause
endlocal