# Script to add config.js to all HTML files
# This script finds all HTML files, checks if they load jQuery but don't have config.js,
# and adds config.js right after jQuery

$rootPath = Split-Path -Parent $PSScriptRoot
$htmlFiles = Get-ChildItem -Path $rootPath -Filter "*.html" -Recurse -File

$updatedCount = 0
$skippedCount = 0
$alreadyHasConfigCount = 0

foreach ($file in $htmlFiles) {
    # Skip archived folder
    if ($file.FullName -like "*\archived\*") {
        Write-Host "Skipping archived file: $($file.Name)" -ForegroundColor Yellow
        $skippedCount++
        continue
    }
    
    # Skip template-elements folder
    if ($file.FullName -like "*\template-elements\*") {
        Write-Host "Skipping template file: $($file.Name)" -ForegroundColor Yellow
        $skippedCount++
        continue
    }
    
    $content = Get-Content -Path $file.FullName -Raw
    
    # Check if file already has config.js
    if ($content -match "config\.js") {
        Write-Host "Already has config.js: $($file.Name)" -ForegroundColor Green
        $alreadyHasConfigCount++
        continue
    }
    
    # Check if file has jQuery
    if ($content -notmatch "jquery") {
        Write-Host "No jQuery found: $($file.Name)" -ForegroundColor Gray
        $skippedCount++
        continue
    }
    
    # Pattern 1: <script src="../js/jquery-3.2.1.min.js"></script>
    # Add: <script src="../js/config.js"></script> after it
    if ($content -match '(<script src="../js/jquery-3\.2\.1\.min\.js"></script>)(\r?\n)(\s*)(<script src="../js/timber)') {
        $newContent = $content -replace '(<script src="../js/jquery-3\.2\.1\.min\.js"></script>)(\r?\n)(\s*)(<script src="../js/timber)', '$1$2$3<script src="../js/config.js"></script>$2$3$4'
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "Updated (pattern 1): $($file.Name)" -ForegroundColor Cyan
        $updatedCount++
        continue
    }
    
    # Pattern 2: <script src="/js/jquery-3.2.1.min.js"></script>
    # Add: <script src="/js/config.js"></script> after it
    if ($content -match '(<script src="/js/jquery-3\.2\.1\.min\.js"></script>)(\r?\n)(\s*)(<script src="/js/timber)') {
        $newContent = $content -replace '(<script src="/js/jquery-3\.2\.1\.min\.js"></script>)(\r?\n)(\s*)(<script src="/js/timber)', '$1$2$3<script src="/js/config.js"></script>$2$3$4'
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "Updated (pattern 2): $($file.Name)" -ForegroundColor Cyan
        $updatedCount++
        continue
    }
    
    # Pattern 3: <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    # Add: <script src="js/config.js"></script> after it
    if ($content -match '(<script src="https://code\.jquery\.com/jquery-3\.6\.0\.min\.js"></script>)(\r?\n)(\s*)(<script src="js/)') {
        $newContent = $content -replace '(<script src="https://code\.jquery\.com/jquery-3\.6\.0\.min\.js"></script>)(\r?\n)(\s*)(<script src="js/)', '$1$2$3<script src="js/config.js"></script>$2$3$4'
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "Updated (pattern 3): $($file.Name)" -ForegroundColor Cyan
        $updatedCount++
        continue
    }
    
    # Pattern 4: index.html style with multiple script paths
    if ($content -match '(<script src="https://code\.jquery\.com/jquery-3\.6\.0\.min\.js"></script>)(\r?\n)(\s*)(<script src="js/case-studies)') {
        $newContent = $content -replace '(<script src="https://code\.jquery\.com/jquery-3\.6\.0\.min\.js"></script>)(\r?\n)(\s*)(<script src="js/case-studies)', '$1$2$3<script src="js/config.js"></script>$2$3$4'
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "Updated (pattern 4): $($file.Name)" -ForegroundColor Cyan
        $updatedCount++
        continue
    }
    
    Write-Host "No matching pattern: $($file.Name)" -ForegroundColor Magenta
    $skippedCount++
}

Write-Host "`n========== Summary ==========" -ForegroundColor White
Write-Host "Updated: $updatedCount files" -ForegroundColor Cyan
Write-Host "Already had config.js: $alreadyHasConfigCount files" -ForegroundColor Green
Write-Host "Skipped: $skippedCount files" -ForegroundColor Yellow
Write-Host "=============================" -ForegroundColor White
