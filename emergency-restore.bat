@echo off
chcp 65001 >nul
echo.
echo 🚨 緊急復旧ツール - by レイナ
echo.

echo ⚠️ このツールは問題が発生した場合の緊急復旧用です
echo.
echo 🔍 問題の種類を選択してください:
echo   1. index.htmlが壊れた
echo   2. ブログ記事が消えた
echo   3. Git履歴を巻き戻したい
echo   4. GitHub Actions設定をリセット
echo   5. 全体的な問題診断

set /p emergency_type="番号を選択 (1-5): "

if "!emergency_type!"=="1" (
    echo 📄 index.htmlバックアップから復旧中...
    if exist "backups\*.html" (
        for /f "delims=" %%f in ('dir backups\*.html /b /o:-d') do (
            copy "backups\%%f" "index.html"
            echo ✅ !%%f! から復旧しました
            goto :restore_complete
        )
    ) else (
        echo ❌ バックアップファイルが見つかりません
    )
) else if "!emergency_type!"=="2" (
    echo 📁 ブログ記事チェック中...
    git log --oneline --name-only | findstr blog
) else if "!emergency_type!"=="3" (
    echo 🔄 Git履歴表示:
    git log --oneline -10
    echo.
    set /p commit_hash="戻したいコミットハッシュを入力: "
    git reset --hard !commit_hash!
    echo ✅ !commit_hash! に復旧しました
) else if "!emergency_type!"=="4" (
    echo 🔧 GitHub Actions設定をリセット中...
    del ".github\workflows\auto-blog-update.yml"
    call setup-blog-automation.bat
) else if "!emergency_type!"=="5" (
    echo 🔍 システム診断中...
    echo.
    echo Git状態:
    git status
    echo.
    echo ファイル構造:
    dir /b
    echo.
    echo GitHub Actions ワークフロー:
    if exist ".github\workflows\auto-blog-update.yml" (
        echo ✅ ワークフローファイル存在
    ) else (
        echo ❌ ワークフローファイル不在
    )
)

:restore_complete
echo.
pause