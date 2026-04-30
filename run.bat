@echo off
echo ==========================================
echo   LearnifyX - Starting Examination System
echo ==========================================

echo [1/2] Initializing Database...
node init_db.js

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Database initialization failed. Please check your MySQL connection.
    pause
    exit /b %ERRORLEVEL%
)

echo [2/2] Starting Server...
echo The application will be available at http://localhost:5000
npm run dev

pause
