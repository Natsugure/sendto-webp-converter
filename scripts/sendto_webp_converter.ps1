Add-Type -AssemblyName System.Windows.Forms

$supportedExtensions = @(".jpg", ".jpeg", ".png", ".tiff", ".tif")

$ErrorFileName = @()
$ProcessedCount = 0

foreach ($FilePath in $Args) {
    if ((Get-Item $FilePath).PSIsContainer) {
        $WarningMsg = "ディレクトリはスキップされました:`n$FilePath`n`nファイルのみを選択してください。"
        [System.Windows.Forms.MessageBox]::Show($WarningMsg, "警告", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        continue
    }

    $FileItem = Get-Item $FilePath
    $Extension = $FileItem.Extension.ToLower()

    if ($supportedExtensions.Contains($Extension)) {
        $OutputDir = Join-Path $FileItem.DirectoryName "webp_output"
        
        # webp_outputフォルダが存在しない場合は作成
        if (-not (Test-Path $OutputDir)) {
            try {
                New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
                Write-Output "Created output directory: $OutputDir"
            } catch {
                Write-Output "Error: webp_outputフォルダの作成に失敗しました"
                Write-Output "パス: $OutputDir"
                Write-Output "詳細: $($_.Exception.Message)"
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
            
            Write-Output "Error: ファイルの変換中にエラーが発生しました"
            Write-Output "ファイル: $($FileItem.Name)"
            Write-Output "エラータイプ: $ErrorType"
            Write-Output "エラーカテゴリ: $ErrorCategory"
            Write-Output "詳細: $ErrorDetails"
            
            $ErrorFileName += $FileItem.Name
        }
        
    } else {
        Write-Output "Unsupported: サポートされていないファイル形式です"
        Write-Output "ファイル: $($FileItem.Name)"
        Write-Output "拡張子: $Extension"
        Write-Output "対応形式: .jpg, .jpeg, .png"
        $ErrorFileName += $FileItem.Name
    }
    
    Write-Output "----------------"
}

if ($ErrorFileName.Count -gt 0) {
    $PartialMsg = "処理が完了しましたが、変換に失敗したファイルがあります。`n`n成功: $ProcessedCount ファイル`n失敗またはスキップ: $($ErrorFileName.Count) ファイル`n`n問題のあったファイル:`n$($ErrorFileName -join "`n")"
    [System.Windows.Forms.MessageBox]::Show($PartialMsg, "Webp変換部分完了", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
} else {
    $CompletedMsg = "すべての変換が完了しました。`n`n変換されたファイル数: $ProcessedCount"
    [System.Windows.Forms.MessageBox]::Show($CompletedMsg, "Webp変換完了", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}