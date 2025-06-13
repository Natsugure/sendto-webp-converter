Add-Type -AssemblyName System.Windows.Forms

$supportedExtensions = @(".jpg", ".jpeg", ".png", ".tiff", ".tif")

$ErrorFileName = @()
$ProcessedCount = 0

foreach ($FilePath in $Args) {
    if ((Get-Item $FilePath).PSIsContainer) {
        $WarningMsg = "�f�B���N�g���̓X�L�b�v����܂���:`n$FilePath`n`n�t�@�C���݂̂�I�����Ă��������B"
        [System.Windows.Forms.MessageBox]::Show($WarningMsg, "�x��", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        continue
    }

    $FileItem = Get-Item $FilePath
    $Extension = $FileItem.Extension.ToLower()

    if ($supportedExtensions.Contains($Extension)) {
        $OutputDir = Join-Path $FileItem.DirectoryName "webp_output"
        
        # webp_output�t�H���_�����݂��Ȃ��ꍇ�͍쐬
        if (-not (Test-Path $OutputDir)) {
            try {
                New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
                Write-Output "Created output directory: $OutputDir"
            } catch {
                Write-Output "Error: webp_output�t�H���_�̍쐬�Ɏ��s���܂���"
                Write-Output "�p�X: $OutputDir"
                Write-Output "�ڍ�: $($_.Exception.Message)"
                $ErrorFileName += $FileItem.Name
                continue
            }
        }
        
        $GenerateFileName = Join-Path $OutputDir "$($FileItem.BaseName).webp"
        
        Write-Output "Converting: $($FileItem.Name)"
        Write-Output "Output to: $GenerateFileName"
        
        try {
            cwebp -preset photo -metadata icc -sharp_yuv -o $GenerateFileName -progress -short $FilePath
            Write-Output "Completed: $($FileItem.Name)"
            $ProcessedCount++
        } catch {
            $ErrorDetails = $_.Exception.Message
            $ErrorCategory = $_.CategoryInfo.Category
            $ErrorType = $_.Exception.GetType().Name
            
            Write-Output "Error: �t�@�C���̕ϊ����ɃG���[���������܂���"
            Write-Output "�t�@�C��: $($FileItem.Name)"
            Write-Output "�G���[�^�C�v: $ErrorType"
            Write-Output "�G���[�J�e�S��: $ErrorCategory"
            Write-Output "�ڍ�: $ErrorDetails"
            
            $ErrorFileName += $FileItem.Name
        }
        
    } else {
        Write-Output "Unsupported: �T�|�[�g����Ă��Ȃ��t�@�C���`���ł�"
        Write-Output "�t�@�C��: $($FileItem.Name)"
        Write-Output "�g���q: $Extension"
        Write-Output "�Ή��`��: .jpg, .jpeg, .png"
        $ErrorFileName += $FileItem.Name
    }
    
    Write-Output "----------------"
}

if ($ErrorFileName.Count -gt 0) {
    $PartialMsg = "�������������܂������A�ϊ��Ɏ��s�����t�@�C��������܂��B`n`n����: $ProcessedCount �t�@�C��`n���s�܂��̓X�L�b�v: $($ErrorFileName.Count) �t�@�C��`n`n���̂������t�@�C��:`n$($ErrorFileName -join "`n")"
    [System.Windows.Forms.MessageBox]::Show($PartialMsg, "Webp�ϊ���������", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
} else {
    $CompletedMsg = "���ׂĂ̕ϊ����������܂����B`n`n�ϊ����ꂽ�t�@�C����: $ProcessedCount"
    [System.Windows.Forms.MessageBox]::Show($CompletedMsg, "Webp�ϊ�����", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}