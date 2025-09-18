# PowerShell script to clean coverage data by removing unwanted files
# Run this after: flutter test --coverage

Write-Host "🧹 Cleaning coverage data..." -ForegroundColor Yellow

$coverageFile = "coverage\lcov.info"
$cleanedFile = "coverage\lcov_cleaned.info"

if (-Not (Test-Path $coverageFile)) {
    Write-Host "❌ Coverage file not found. Run 'flutter test --coverage' first." -ForegroundColor Red
    exit 1
}

# Exact path patterns to exclude (using both \ and / to be safe)
$excludePatterns = @(
    # Generated files
    "lib\generated\*",
    "lib/generated/*",
    "*\.g.dart",
    "*/.g.dart",
    "*\*.g.dart",
    "*//*.g.dart",
    
    # AmplifyWrapper
    "lib\AmplifyWrapper\*",
    "lib/AmplifyWrapper/*",
    
    # Main and config files
    "lib\main.dart",
    "lib/main.dart",
    "*amplify_outputs.dart",
    "*firebase_options.dart",
    
    # UI/Views (if you want to exclude)
    "lib\Views\*",
    "lib/Views/*",
    "lib\navigation\*",
    "lib/navigation/*",
    
    # Localization
    "lib\l10n\*",
    "lib/l10n/*",
    
    # Test setup
    "*test_setup.dart",
    
    # Specific providers (if you want to exclude)
    "*auth_state_provider.dart",
    "*app_lifecycle_provider.dart", 
    "*localization_provider.dart",
    "*theme_provider.dart",
    "*user_provider.dart",
    "*chat_provider.dart"
)

Write-Host "📊 Original coverage file size: $((Get-Item $coverageFile).Length) bytes"

# Read the coverage file and filter out excluded patterns
$content = Get-Content $coverageFile
$filteredContent = @()
$skipNext = $false
$excludedCount = 0

foreach ($line in $content) {
    if ($line -match "^SF:(.+)") {
        $filePath = $matches[1]
        $shouldExclude = $false
        $matchedPattern = ""
        
        foreach ($pattern in $excludePatterns) {
            # Simple wildcard matching - convert * to regex .*
            $regexPattern = "^" + ($pattern -replace "\*", ".*" -replace "\\", "\\") + "$"
            if ($filePath -match $regexPattern) {
                $shouldExclude = $true
                $matchedPattern = $pattern
                break
            }
            
            # Also try with simple contains for robustness
            if ($filePath -like "*$($pattern.Replace('*', ''))*") {
                $shouldExclude = $true
                $matchedPattern = $pattern
                break
            }
        }
        
        if ($shouldExclude) {
            $skipNext = $true
            $excludedCount++
            Write-Host "🚫 Excluding: $filePath (matched: $matchedPattern)" -ForegroundColor Gray
            continue
        } else {
            $skipNext = $false
        }
    }
    
    if (-not $skipNext) {
        $filteredContent += $line
    } elseif ($line -eq "end_of_record") {
        $skipNext = $false
    }
}

# Write cleaned content
$filteredContent | Out-File -FilePath $cleanedFile -Encoding UTF8

# Replace original with cleaned version
Move-Item $cleanedFile $coverageFile -Force

Write-Host "✅ Coverage cleaned! New size: $((Get-Item $coverageFile).Length) bytes" -ForegroundColor Green
Write-Host "📁 Coverage report: $coverageFile" -ForegroundColor Cyan

# Show summary
$totalFiles = ($content | Where-Object { $_ -match "^SF:" }).Count
$remainingFiles = ($filteredContent | Where-Object { $_ -match "^SF:" }).Count

Write-Host "📈 Coverage Summary:" -ForegroundColor White
Write-Host "   • Total files: $totalFiles" -ForegroundColor White
Write-Host "   • Included: $remainingFiles" -ForegroundColor Green
Write-Host "   • Excluded: $excludedCount" -ForegroundColor Gray