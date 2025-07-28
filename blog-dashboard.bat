@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
cls

:menu
echo.
echo ========================================================================
echo  🎯 AI Art Studio - ブログ管理ダッシュボード - by レイナ
echo ========================================================================
echo.

rem 統計情報表示
set count=0
for %%f in (blog\*.html) do set /a count+=1

echo 📊 現在の状況:
echo   📝 総記事数: !count!
echo   📅 最終更新: %date% %time:~0,5%
echo.

if !count! gtr 0 (
    echo 📑 最新記事 (最新5件):
    set /a display_count=0
    for /f "delims=" %%f in ('dir blog\*.html /b /o:-d 2^>nul') do (
        if !display_count! lss 5 (
            echo   - %%~nf
            set /a display_count+=1
        )
    )
) else (
    echo ⚠️ まだ記事がありません
)

echo.
echo 🎯 何をしますか？
echo.
echo  1. 📝 新しい記事を作成
echo  2. 📊 詳細統計を表示
echo  3. 🔄 Git状態確認・操作
echo  4. 🧪 テスト記事作成
echo  5. 🔍 GitHub Actions状態確認
echo  6. 🌐 サイトをブラウザで開く
echo  7. 🛠️ 設定・メンテナンス
echo  8. ❌ 終了
echo.

set /p menu_choice="番号を選択 (1-8): "

if "!menu_choice!"=="1" goto :create_article
if "!menu_choice!"=="2" goto :detailed_stats
if "!menu_choice!"=="3" goto :git_operations
if "!menu_choice!"=="4" goto :create_test
if "!menu_choice!"=="5" goto :github_status
if "!menu_choice!"=="6" goto :open_site
if "!menu_choice!"=="7" goto :maintenance
if "!menu_choice!"=="8" goto :exit
goto :menu

:create_article
cls
echo 📝 新記事作成モードに移行中...
call one-click-blog.bat
goto :menu

:detailed_stats
cls
echo.
echo 📊 詳細統計 - AI Art Studio
echo ========================================================================
echo.

rem カテゴリ別統計（簡易版）
set ai_count=0
set reina_count=0
set programming_count=0
set business_count=0

for %%f in (blog\*.html) do (
    findstr /i "ai" "%%f" >nul && set /a ai_count+=1
    findstr /i "レイナ" "%%f" >nul && set /a reina_count+=1
    findstr /i "プログラミング" "%%f" >nul && set /a programming_count+=1
    findstr /i "ビジネス" "%%f" >nul && set /a business_count+=1
)

echo 📈 カテゴリ別記事数 (推定):
echo   🤖 AI技術: !ai_count! 記事
echo   👩‍💻 レイナ: !reina_count! 記事  
echo   💻 プログラミング: !programming_count! 記事
echo   📊 ビジネス: !business_count! 記事
echo.

echo 📅 記事作成履歴:
for /f "delims=" %%f in ('dir blog\*.html /b /o:-d 2^>nul') do (
    for %%a in ("blog\%%f") do echo   %%~tf - %%~nf
)

echo.
pause
goto :menu

:git_operations
cls
echo.
echo 🔄 Git操作パネル
echo ========================================================================
echo.

echo 📊 現在のGit状態:
git status --short
echo.

echo 🔄 利用可能な操作:
echo   1. 全ての変更をコミット・プッシュ
echo   2. 特定ファイルのみコミット・プッシュ
echo   3. 最新の変更を取得 (pull)
echo   4. Gitログを表示
echo   5. メニューに戻る

set /p git_op="操作を選択 (1-5): "

if "!git_op!"=="1" (
    set /p commit_msg="コミットメッセージ [Auto update]: "
    if "!commit_msg!"=="" set commit_msg=Auto update
    git add .
    git commit -m "!commit_msg!"
    git push origin main
    echo ✅ 全ての変更をプッシュしました
) else if "!git_op!"=="2" (
    echo 利用可能なファイル:
    dir blog\*.html /b
    echo.
    set /p filename="ファイル名を入力: "
    set /p commit_msg="コミットメッセージ: "
    git add "blog\!filename!"
    git commit -m "!commit_msg!"
    git push origin main
    echo ✅ !filename! をプッシュしました
) else if "!git_op!"=="3" (
    git pull origin main
    echo ✅ 最新の変更を取得しました
) else if "!git_op!"=="4" (
    git log --oneline -10
) else if "!git_op!"=="5" (
    goto :menu
)

echo.
pause
goto :menu

:create_test
cls
echo 🧪 テスト記事作成中...

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "timestamp=%dt:~0,4%-%dt:~4,2%-%dt:~6,2%_%dt:~8,2%-%dt:~10,2%-%dt:~12,2%"

(
echo ^<!DOCTYPE html^>
echo ^<html lang="ja"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<title^>🧪 システムテスト - !timestamp!^</title^>
echo     ^<meta name="description" content="自動化システムの動作テスト記事です。"^>
echo ^</head^>
echo ^<body^>
echo     ^<h1^>🧪 システムテスト記事^</h1^>
echo     ^<p^>作成日時: !timestamp!^</p^>
echo     ^<p^>自動化システムが正常に動作することを確認するテスト記事です。^</p^>
echo     ^<p^>✅ バッチファイル動作確認^</p^>
echo     ^<p^>✅ Git操作確認^</p^>
echo     ^<p^>✅ GitHub Actions連携確認^</p^>
echo ^</body^>
echo ^</html^>
) > "blog\test-!timestamp!.html"

git add "blog\test-!timestamp!.html"
git commit -m "🧪 Test: !timestamp!"
git push origin main

echo ✅ テスト記事をプッシュしました
echo 📊 GitHub Actionsで自動処理中...
pause
goto :menu

:github_status
cls
echo.
echo 🔍 GitHub Actions状態確認
echo ========================================================================
echo.
echo 💡 以下のURLでGitHub Actionsの状態を確認できます:
echo.
echo 🔗 https://github.com/[YOUR_USERNAME]/[YOUR_REPO]/actions
echo.
echo 📊 最新のWorkflow実行状況:
echo   - ✅ 成功: 自動更新完了
echo   - 🔄 実行中: 処理中 (2-3分待機)
echo   - ❌ 失敗: ログで詳細確認
echo.
echo ブラウザでGitHubを開きますか？ (y/n)
set /p open_github=""
if /i "!open_github!"=="y" (
    start https://github.com
)
pause
goto :menu

:open_site
start https://aistudio.netlify.app/
echo 🌐 サイトをブラウザで開きました
pause
goto :menu

:maintenance
cls
echo.
echo 🛠️ 設定・メンテナンス
echo ========================================================================
echo.
echo   1. 🧹 バックアップクリーンアップ
echo   2. 🔧 Git設定確認
echo   3. 📁 フォルダ構造確認
echo   4. 🔍 権限設定確認
echo   5. メニューに戻る

set /p maint_choice="操作を選択 (1-5): "

if "!maint_choice!"=="1" (
    echo バックアップフォルダをクリーンアップ中...
    if exist "backups" (
        echo backups フォルダの内容:
        dir backups /b
        echo.
        set /p clean_backup="古いバックアップを削除しますか？ (y/n): "
        if /i "!clean_backup!"=="y" (
            del backups\*.html /q
            echo ✅ バックアップをクリーンアップしました
        )
    ) else (
        echo backups フォルダが存在しません
    )
) else if "!maint_choice!"=="2" (
    echo 📊 Git設定:
    git config --list | findstr user
    echo.
    echo Git履歴:
    git log --oneline -5
) else if "!maint_choice!"=="3" (
    echo 📁 フォルダ構造:
    tree /f
) else if "!maint_choice!"=="4" (
    call check-permissions.bat
) else if "!maint_choice!"=="5" (
    goto :menu
)

echo.
pause
goto :menu

:exit
echo.
echo 👋 レイナの自動化システムをご利用いただき、ありがとうございました！
echo ✨ 素晴らしいブログライフを♪
echo.
pause
exit /b