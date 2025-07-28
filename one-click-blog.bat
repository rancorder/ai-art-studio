@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo 🚀 ワンクリック記事作成・投稿ツール - by レイナ
echo.

rem プリセット記事テンプレート選択
echo 📝 記事テンプレートを選択してください:
echo.
echo 1. AI技術記事（ChatGPT、Stable Diffusion等）
echo 2. レイナの開発日記
echo 3. プログラミング技術記事
echo 4. ビジネス・DX記事
echo 5. カスタム記事（自由入力）
echo.
set /p template_choice="番号を選択 (1-5): "

if "!template_choice!"=="1" (
    set category=ai
    set title_prefix=
    set description_template=最新のAI技術について分かりやすく解説します
    set keywords=AI,ChatGPT,Stable Diffusion,技術解説
) else if "!template_choice!"=="2" (
    set category=reina
    set title_prefix=レイナの開発日記 - 
    set description_template=レイナの日々の開発体験や学びを共有します
    set keywords=レイナ,開発日記,体験談,学習
) else if "!template_choice!"=="3" (
    set category=programming
    set title_prefix=
    set description_template=プログラミング技術を実践的に解説します
    set keywords=プログラミング,Python,Java,開発技術
) else if "!template_choice!"=="4" (
    set category=business
    set title_prefix=
    set description_template=ビジネスにおけるAI活用について解説します
    set keywords=ビジネス,DX,AI活用,効率化
) else (
    set category=ai
    set title_prefix=
    set description_template=
    set keywords=AI,技術,ブログ
)

echo.
set /p title="記事タイトルを入力: "
set title=!title_prefix!!title!

if "!description_template!"=="" (
    set /p description="記事の説明を入力: "
) else (
    set /p description="記事の説明 [!description_template!]: "
    if "!description!"=="" set description=!description_template!
)

rem ファイル名生成
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YYYY=!dt:~0,4!" & set "MM=!dt:~4,2!" & set "DD=!dt:~6,2!"
set "HH=!dt:~8,2!" & set "Min=!dt:~10,2!"

rem タイトルをファイル名用に変換
set "clean_title=!title!"
set "clean_title=!clean_title: =-!"
set "clean_title=!clean_title:/=-!"
set "clean_title=!clean_title:\=-!"
set "clean_title=!clean_title::=-!"
set "clean_title=!clean_title:*=-!"
set "clean_title=!clean_title:?=-!"
set "clean_title=!clean_title:"=-!"
set "clean_title=!clean_title:<=-!"
set "clean_title=!clean_title:>=-!"
set "clean_title=!clean_title:|=-!"

set "filename=!clean_title!-!YYYY!!MM!!DD!.html"

echo.
echo 📄 記事作成中...

rem HTMLファイル作成
(
echo ^<!DOCTYPE html^>
echo ^<html lang="ja"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>!title!^</title^>
echo     ^<meta name="description" content="!description!"^>
echo     ^<meta name="keywords" content="!keywords!"^>
echo     ^<style^>
echo         body { font-family: Arial, sans-serif; line-height: 1.6; margin: 40px; }
echo         h1 { color: #333; border-bottom: 3px solid #00f0ff; padding-bottom: 10px; }
echo         h2 { color: #555; border-left: 4px solid #8aff00; padding-left: 15px; }
echo         p { margin-bottom: 15px; }
echo         .author { color: #666; font-style: italic; margin-top: 30px; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<h1^>!title!^</h1^>
echo     
echo     ^<p^>こんにちは！レイナです。^</p^>
echo     
echo     ^<p^>!description!^</p^>
echo     
echo     ^<h2^>はじめに^</h2^>
echo     ^<p^>ここに導入部分を書いてください。^</p^>
echo     
echo     ^<h2^>詳細解説^</h2^>
echo     ^<p^>ここにメインコンテンツを書いてください。^</p^>
echo     
echo     ^<h2^>まとめ^</h2^>
echo     ^<p^>ここにまとめを書いてください。^</p^>
echo     
echo     ^<div class="author"^>
echo         ^<p^>この記事がお役に立てれば幸いです♪^</p^>
echo         ^<p^>👩‍💻 レイナ - AI技術コンサルタント^</p^>
echo     ^</div^>
echo ^</body^>
echo ^</html^>
) > "blog\!filename!"

echo ✅ 記事作成完了: blog\!filename!
echo 📝 タイトル: !title!
echo 📋 説明: !description!
echo 🏷️ カテゴリ: !category!
echo.

rem エディタで開くかの選択
set /p edit_choice="記事を編集しますか？ (y/n) [y]: "
if "!edit_choice!"=="" set edit_choice=y
if /i "!edit_choice!"=="y" (
    if exist "C:\Program Files\Microsoft VS Code\Code.exe" (
        "C:\Program Files\Microsoft VS Code\Code.exe" "blog\!filename!"
    ) else (
        notepad "blog\!filename!"
    )
    echo.
    echo 📝 編集が完了したら任意のキーを押してください...
    pause >nul
)

rem Git操作
echo.
set /p git_choice="Gitにコミット・プッシュしますか？ (y/n) [y]: "
if "!git_choice!"=="" set git_choice=y
if /i "!git_choice!"=="y" (
    git add "blog\!filename!"
    git commit -m "新記事: !title!"
    
    echo 🚀 GitHubにプッシュ中...
    git push origin main
    
    if !errorlevel! equ 0 (
        echo ✅ 記事を正常にプッシュしました！
        echo 📊 GitHub Actionsで自動更新中... (2-3分お待ちください)
        echo 🌐 サイト: https://aistudio.netlify.app/
    ) else (
        echo ❌ プッシュに失敗しました。インターネット接続とGit設定を確認してください。
    )
) else (
    echo ℹ️ 後で手動でコミット・プッシュしてください
)

echo.
pause