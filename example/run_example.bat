@echo off
echo StackBoardPlus Example Runner
echo ========================

echo.
echo Checking Flutter installation...
flutter doctor --version

echo.
echo Getting dependencies...
flutter pub get

echo.
echo Available commands:
echo 1. Run on connected device: flutter run
echo 2. Run on web: flutter run -d chrome
echo 3. Run on Windows: flutter run -d windows
echo 4. Build for web: flutter build web
echo 5. Build for Windows: flutter build windows

echo.
set /p choice="Enter command number (1-5) or 'custom' for custom command: "

if "%choice%"=="1" (
    echo Running on connected device...
    flutter run
) else if "%choice%"=="2" (
    echo Running on web...
    flutter run -d chrome
) else if "%choice%"=="3" (
    echo Running on Windows...
    flutter run -d windows
) else if "%choice%"=="4" (
    echo Building for web...
    flutter build web
) else if "%choice%"=="5" (
    echo Building for Windows...
    flutter build windows
) else if "%choice%"=="custom" (
    set /p custom_cmd="Enter custom Flutter command: "
    flutter %custom_cmd%
) else (
    echo Invalid choice. Running default: flutter run
    flutter run
)

pause
