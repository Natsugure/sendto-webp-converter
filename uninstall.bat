@echo off
setlocal

set "DIR=%appdata%\Microsoft\Windows\SendTo"
set "FILE=WebP�ɕϊ�.lnk"
set "FULLPATH=%DIR%\%FILE%"
set "PROJECT_DIR=%~dp0"

echo ===========================================
echo SendTo WebP Converter �A���C���X�g�[���[
echo ===========================================
echo.

echo %FULLPATH% ���폜���܂��B
echo.

if exist "%FULLPATH%" (
    echo �t�@�C����������܂����B�폜�����s���܂�...
    del "%FULLPATH%"
    if errorlevel 1 (
        echo �G���[: �t�@�C���̍폜�Ɏ��s���܂���
        pause
        exit /b 1
    ) else (
        echo �u����v�̃V���[�g�J�b�g�̍폜�ɐ������܂����B
    )
) else (
    echo �t�@�C����������܂���: %FULLPATH%
)

echo.
echo ========================================
echo �X�N���v�g�S�̂̍폜�ɂ���
echo ========================================
echo.
echo �X�N���v�g�t�H���_�����S�ɍ폜����ɂ́A
echo ���̃A���C���X�g�[���[�I����ɁA�ȉ��̃t�H���_���蓮�ŃS�~���Ɉړ����Ă��������F
echo.
echo %PROJECT_DIR%
echo.
pause
endlocal