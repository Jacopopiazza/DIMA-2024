@echo off
REM Combined script: Run tests with coverage and clean the results

REM Ensure we run from the app root (one level up from this script's folder)
pushd "%~dp0.."

echo 🧪 Running Flutter tests with coverage...
flutter test --coverage

if %errorlevel% neq 0 (
    echo ❌ Tests failed with exit code %errorlevel%
    pause
    popd
    exit /b %errorlevel%
)

echo ✅ Tests completed successfully!

REM Check if PowerShell is available and run cleaning script
where powershell >nul 2>&1
if %errorlevel% equ 0 (
    echo 🧹 Cleaning coverage data...
    if exist "scripts\clean-coverage-fixed.ps1" (
        powershell -ExecutionPolicy Bypass -File "scripts\clean-coverage-fixed.ps1"
    ) else (
        echo ❌ Cleaner script not found at "%CD%\scripts\clean-coverage-fixed.ps1"
    )
) else (
    echo ⚠️  PowerShell not found. Coverage not cleaned.
    echo 💡 Manually add "// coverage:ignore-file" to files you want to exclude.
)

echo.
echo 🎉 Done! Coverage report available at: coverage\lcov.info
popd
pause