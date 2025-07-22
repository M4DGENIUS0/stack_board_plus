#!/usr/bin/env pwsh

Write-Host "StackBoardPlus Example Runner" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
flutter doctor --version

Write-Host ""
Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "Available commands:" -ForegroundColor Green
Write-Host "1. Run on connected device: flutter run"
Write-Host "2. Run on web: flutter run -d chrome"
Write-Host "3. Run on Windows: flutter run -d windows"
Write-Host "4. Build for web: flutter build web"
Write-Host "5. Build for Windows: flutter build windows"
Write-Host "6. Show connected devices: flutter devices"
Write-Host "7. Run tests: flutter test"

Write-Host ""
$choice = Read-Host "Enter command number (1-7) or 'custom' for custom command"

switch ($choice) {
    "1" {
        Write-Host "Running on connected device..." -ForegroundColor Yellow
        flutter run
    }
    "2" {
        Write-Host "Running on web..." -ForegroundColor Yellow
        flutter run -d chrome
    }
    "3" {
        Write-Host "Running on Windows..." -ForegroundColor Yellow
        flutter run -d windows
    }
    "4" {
        Write-Host "Building for web..." -ForegroundColor Yellow
        flutter build web
    }
    "5" {
        Write-Host "Building for Windows..." -ForegroundColor Yellow
        flutter build windows
    }
    "6" {
        Write-Host "Showing connected devices..." -ForegroundColor Yellow
        flutter devices
    }
    "7" {
        Write-Host "Running tests..." -ForegroundColor Yellow
        flutter test
    }
    "custom" {
        $customCmd = Read-Host "Enter custom Flutter command"
        Write-Host "Running: flutter $customCmd" -ForegroundColor Yellow
        Invoke-Expression "flutter $customCmd"
    }
    default {
        Write-Host "Invalid choice. Running default: flutter run" -ForegroundColor Red
        flutter run
    }
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
