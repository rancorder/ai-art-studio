@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo ========================================================================
echo  🚀 5分でできる！GitHub連携クイックセットアップ - by レイナ
echo ========================================================================
echo.

echo 📍 現在の場所: %CD%
echo.

rem Step 1: Git確認
echo 🔍 Step 1: Git確認中...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Gitがインストールされていません
    echo 📥 まず Git をインストールしてください: https://git-scm.com/download/win
    pause
    exit /b 1
)
echo ✅ Git利用可能

rem Step 2: ユーザー設定確認
echo.
echo 🔍 Step 2: ユーザー設定確認中...
for /f "tokens=*" %%i in ('git config user.name 2^>nul') do set git_name=%%i
for /f "tokens=*" %%i in ('git config user.email 2^>nul') do set git_email=%%i

if "!git_name!"=="" (
    set /p user_name="👤 あなたの名前を入力: "
    git config --global user.name "!user_name!"
) else (
    echo ✅ ユーザー名: !git_name!
)

if "!git_email!"=="" (
    set /p user_email="📧 メールアドレスを入力: "
    git config --global user.email "!user_email!"
) else (
    echo ✅ メールアドレス: !git_email!
)

rem Step 3: Gitリポジトリ初期化
echo.
echo 🔍 Step 3: Gitリポジトリ初期化中...
if exist ".git" (
    echo ✅ 既にGitリポジトリです
) else (
    git init
    echo ✅ Gitリポジトリを初期化しました
)

rem Step 4: 初回コミット
echo.
echo 🔍 Step 4: ファイルをコミット中...
git add .
git commit -m "🚀 Initial commit: AI Art Studio setup"
if %errorlevel% equ 0 (
    echo ✅ 初回コミット完了
) else (
    echo ℹ️  コミット済みまたは変更なし
)

rem Step 5: GitHub設定説明
echo.
echo 🔍 Step 5: GitHub連携設定
echo.
echo 📋 次の手順でGitHubにリポジトリを作成してください:
echo.
echo 1. ブラウザでGitHubを開きます...
timeout /t 2 /nobreak >nul
start https://github.com/new
echo.
echo 2. 以下の設定で新しいリポジトリを作成:
echo    📝 Repository name: ai-art-studio
echo    🌐 Public (推奨)
echo    ❌ README, .gitignore, license は追加しない
echo    ✅ "Create repository" をクリック
echo.

rem Step 6: リモートリポジトリ追加
echo 📋 GitHubでリポジトリを作成しましたか？
set /p github_done="作成完了なら y を入力 [y]: "
if "!github_done!"=="" set github_done=y

if /i "!github_done!"=="y" (
    echo.
    echo 🔗 Step 6: リモートリポジトリ設定
    echo.
    set /p github_username="GitHubユーザー名を入力: "
    set /p repo_name="リポジトリ名を入力 [ai-art-studio]: "
    if "!repo_name!"=="" set repo_name=ai-art-studio
    
    echo.
    echo 🔗 リモートリポジトリを追加中...
    git remote add origin https://github.com/!github_username!/!repo_name!.git
    
    echo 🚀 GitHubにプッシュ中...
    git branch -M main
    git push -u origin main
    
    if !errorlevel! equ 0 (
        echo.
        echo ========================================================================
        echo  🎉 GitHub連携完了！
        echo ========================================================================
        echo.
        echo ✅ 完了した項目:
        echo   📁 Gitリポジトリ初期化
        echo   👤 ユーザー情報設定
        echo   💾 初回コミット作成
        echo   🔗 GitHub連携設定
        echo   🚀 ファイルアップロード完了
        echo.
        echo 🌐 あなたのリポジトリ:
        echo    https://github.com/!github_username!/!repo_name!
        echo.
        echo 🎯 次のステップ:
        echo   1. check-permissions.bat で権限設定確認
        echo   2. one-click-blog.bat で記事作成テスト
        echo   3. blog-dashboard.bat で管理開始
        echo.
        echo 💡 記事を投稿すると2-3分で自動更新されます！
        
    ) else (
        echo.
        echo ❌ プッシュに失敗しました
        echo.
        echo 🔧 可能な原因:
        echo   - GitHubユーザー名/リポジトリ名が間違っている
        echo   - インターネット接続の問題
        echo   - GitHub認証の問題
        echo.
        echo 💡 解決方法:
        echo   1. GitHubの設定を確認
        echo   2. このスクリプトを再実行
        echo   3. または manual-github-setup.bat を実行
    )
) else (
    echo.
    echo 📋 手動設定用のコマンド:
    echo.
    echo git remote add origin https://github.com/[USERNAME]/[REPO_NAME].git
    echo git branch -M main  
    echo git push -u origin main
    echo.
    echo 💡 [USERNAME] と [REPO_NAME] を実際の値に置き換えてください
)

echo.
pause

rem 自動でPermissionチェックを実行
if exist "check-permissions.bat" (
    echo.
    echo 🔍 GitHub Actions権限を確認しますか？ (y/n) [y]
    set /p check_perm=""
    if "!check_perm!"=="" set check_perm=y
    if /i "!check_perm!"=="y" (
        call check-permissions.bat
    )
)