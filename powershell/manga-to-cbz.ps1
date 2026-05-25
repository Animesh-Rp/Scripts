# Set UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Set base folders
$SOURCE_ROOT = $PSScriptRoot
$PANELS_ROOT = Join-Path $SOURCE_ROOT "..\Panels"

# Path to 7z.exe
$zipper = "C:\Program Files\7-Zip\7z.exe"

Write-Host "Starting CBZ generation for all manga in: $SOURCE_ROOT"
Write-Host "Output will go to: $PANELS_ROOT"
Write-Host ""

# Get all manga folders
$mangaFolders = Get-ChildItem -Path $SOURCE_ROOT -Directory

foreach ($manga in $mangaFolders) {
    $mangaName = $manga.Name
    $outputFolder = Join-Path $PANELS_ROOT $mangaName
    
    Write-Host ""
    Write-Host "==== Processing `"$mangaName`" ===="
    
    # Create output folder if it doesn't exist
    if (-not (Test-Path -LiteralPath $outputFolder)) {
        Write-Host "Creating folder: $outputFolder"
        New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null
    }
    
    # Loop through each chapter folder
    $chapters = Get-ChildItem -Path $manga.FullName -Directory
    
    foreach ($chapter in $chapters) {
        $chapterName = $chapter.Name
        $cbzFile = Join-Path $outputFolder "$chapterName.cbz"
        
        if (Test-Path -LiteralPath $cbzFile) {
            Write-Host "Skipping `"$chapterName`" - CBZ already exists."
        }
        else {
            Write-Host "Zipping `"$chapterName`" into $cbzFile"
            
            Push-Location -LiteralPath $chapter.FullName
            & $zipper a -tzip -r $cbzFile * | Out-Null
            Pop-Location
            
            Write-Host "Done: $chapterName.cbz"
        }
    }
}

Write-Host ""
Write-Host "All manga processed. CBZ files stored in Panels folder."
Pause
