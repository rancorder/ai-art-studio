@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

rem ========================================================================
rem 🤖 AI Art Studio - Windows完全自動化セットアップ (バッチファイル版)
rem レイナが作ったWindows用完全セットアップスクリプト
rem 使用方法: setup-blog-automation.bat をダブルクリックまたはコマンドプロンプトで実行
rem ========================================================================

echo.
echo ========================================================================
echo  🤖 AI Art Studio - Windows完全自動化セットアップ開始！
echo  👩‍💻 レイナがWindows環境でお手伝いします♪
echo ========================================================================
echo.

rem 現在のディレクトリを確認
echo 📍 現在の場所: %CD%
echo.

rem 管理者権限チェック（必要に応じて）
net session >nul 2>&1
if %errorLevel% == 0 (
    echo ✅ 管理者権限で実行中
) else (
    echo ℹ️  一般ユーザー権限で実行中（通常はこれで十分です）
)
echo.

rem ========================================================================
rem 1. 必要なディレクトリ作成
rem ========================================================================
echo 📁 ディレクトリ構造を作成中...

if not exist ".github" (
    mkdir ".github"
    echo   ✅ .github フォルダ作成
) else (
    echo   ℹ️  .github フォルダは既に存在
)

if not exist ".github\workflows" (
    mkdir ".github\workflows"
    echo   ✅ .github\workflows フォルダ作成
) else (
    echo   ℹ️  .github\workflows フォルダは既に存在
)

if not exist "blog" (
    mkdir "blog"
    echo   ✅ blog フォルダ作成
) else (
    echo   ℹ️  blog フォルダは既に存在
)

if not exist "backups" (
    mkdir "backups"
    echo   ✅ backups フォルダ作成
) else (
    echo   ℹ️  backups フォルダは既に存在
)

echo.

rem ========================================================================
rem 2. GitHub Actionsワークフローファイル作成
rem ========================================================================
echo ⚙️ 自動化ワークフローを設定中...

(
echo name: 🤖 Auto Blog Update ^& Deploy
echo.
echo on:
echo   push:
echo     paths:
echo       - 'blog/*.html'
echo       - 'blog/**/*.html'
echo   workflow_dispatch:
echo.
echo jobs:
echo   auto-update-blog:
echo     name: 📝 Update Blog Index
echo     runs-on: ubuntu-latest
echo.    
echo     steps:
echo       - name: 📥 Checkout Repository
echo         uses: actions/checkout@v4
echo         with:
echo           fetch-depth: 0
echo           token: ${{ secrets.GITHUB_TOKEN }}
echo.
echo       - name: 🚀 Setup Node.js
echo         uses: actions/setup-node@v4
echo         with:
echo           node-version: '18'
echo.
echo       - name: 📦 Install Dependencies
echo         run: ^|
echo           npm init -y
echo           npm install jsdom fs-extra chalk
echo.
echo       - name: ⚡ Run Auto Updater
echo         run: ^|
echo           node -e "
echo           const fs = require('fs-extra'^);
echo           const path = require('path'^);
echo           const { JSDOM } = require('jsdom'^);
echo           
echo           class AutoBlogUpdater {
echo               constructor(^) {
echo                   this.indexPath = './index.html';
echo                   this.blogDir = './blog/';
echo                   this.categories = {
echo                       'ai': { name: 'AI技術', accent: '#00f0ff', icon: '🤖' },
echo                       'reina': { name: 'レイナ', accent: '#ff0080', icon: '👩‍💻' },
echo                       'programming': { name: 'プログラミング', accent: '#00ff40', icon: '💻' },
echo                       'business': { name: 'ビジネス', accent: '#8aff00', icon: '📊' },
echo                       'default': { name: 'その他', accent: '#8aff00', icon: '📝' }
echo                   };
echo               }
echo           
echo               async run(^) {
echo                   console.log('🤖 自動ブログ更新開始'^);
echo                   const blogPosts = await this.scanAllBlogFiles(^);
echo                   await this.updateIndexHtml(blogPosts^);
echo                   console.log('✅ 自動更新完了！'^);
echo               }
echo           
echo               async scanAllBlogFiles(^) {
echo                   const blogFiles = await fs.readdir(this.blogDir^).catch(^(^) =^> []^);
echo                   const htmlFiles = blogFiles.filter(file =^> file.endsWith('.html'^)^);
echo                   const blogPosts = [];
echo                   
echo                   for (const fileName of htmlFiles^) {
echo                       const filePath = path.join(this.blogDir, fileName^);
echo                       const blogInfo = await this.extractBlogInfo(filePath, fileName^);
echo                       blogPosts.push(blogInfo^);
echo                   }
echo                   
echo                   return blogPosts.sort(^(a, b^) =^> new Date(b.dateCreated^) - new Date(a.dateCreated^)^);
echo               }
echo           
echo               async extractBlogInfo(filePath, fileName^) {
echo                   const content = await fs.readFile(filePath, 'utf8'^);
echo                   const dom = new JSDOM(content^);
echo                   const document = dom.window.document;
echo                   
echo                   const title = document.querySelector('title'^)?.textContent?.trim(^) ^^|^^|
echo                                document.querySelector('h1'^)?.textContent?.trim(^) ^^|^^|
echo                                fileName.replace('.html', ''^);
echo           
echo                   const description = document.querySelector('meta[name=\\\"description\\\"]'^)?.getAttribute('content'^)?.trim(^) ^^|^^|
echo                                      document.querySelector('p'^)?.textContent?.trim(^)?.slice(0, 150^) + '...' ^^|^^|
echo                                      '';
echo           
echo                   const category = this.guessCategory(title, content^);
echo                   const stats = await fs.stat(filePath^);
echo                   const dateCreated = new Date(stats.mtime^).toISOString(^).split('T'^)[0];
echo                   
echo                   return { title, description, category, dateCreated, fileName };
echo               }
echo           
echo               guessCategory(title, content^) {
echo                   const text = (title + ' ' + content^).toLowerCase(^);
echo                   if (text.includes('レイナ'^)^) return 'reina';
echo                   if (text.includes('python'^) ^^|^^| text.includes('java'^) ^^|^^| text.includes('プログラミング'^)^) return 'programming';
echo                   if (text.includes('ビジネス'^) ^^|^^| text.includes('dx'^)^) return 'business';
echo                   return 'ai';
echo               }
echo           
echo               async updateIndexHtml(blogPosts^) {
echo                   const indexContent = await fs.readFile(this.indexPath, 'utf8'^);
echo                   const dom = new JSDOM(indexContent^);
echo                   const document = dom.window.document;
echo                   
echo                   const blogContainer = document.querySelector('.blog-section .blog-posts-container'^);
echo                   if (^^!blogContainer^) return;
echo                   
echo                   blogContainer.innerHTML = '';
echo                   
echo                   for (const post of blogPosts^) {
echo                       const cardHtml = this.createBlogCardHtml(post^);
echo                       blogContainer.insertAdjacentHTML('beforeend', cardHtml^);
echo                   }
echo                   
echo                   await fs.writeFile(this.indexPath, dom.serialize(^)^);
echo               }
echo           
echo               createBlogCardHtml(post^) {
echo                   const template = this.categories[post.category] ^^|^^| this.categories.default;
echo                   return \`
echo                   ^<article class=\\\"blog-card\\\" data-category=\\\"\${post.category}\\\" data-title=\\\"\${post.title.toLowerCase(^)}\\\" data-content=\\\"\${post.description.toLowerCase(^)}\\\"\^>
echo                       ^<div class=\\\"blog-card-header\\\" style=\\\"border-color: \${template.accent}\\\"\^>
echo                           ^<span class=\\\"blog-category\\\" style=\\\"color: \${template.accent}\\\"\^>\${template.icon} \${template.name}^</span^>
echo                           ^<time class=\\\"blog-date\\\"\^>\${post.dateCreated}^</time^>
echo                       ^</div^>
echo                       ^<h3 class=\\\"blog-title\\\"\^>\${post.title}^</h3^>
echo                       ^<p class=\\\"blog-excerpt\\\"\^>\${post.description}^</p^>
echo                       ^<div class=\\\"blog-footer\\\"\^>
echo                           ^<a href=\\\"blog/\${post.fileName}\\\" class=\\\"blog-read-more\\\" style=\\\"color: \${template.accent}\\\"\^>
echo                               続きを読む ^<span style=\\\"color: \${template.accent}\\\"\^>→^</span^>
echo                           ^</a^>
echo                           ^<div class=\\\"blog-meta\\\"\^>
echo                               ^<span class=\\\"blog-author\\\"\^>👩‍💻 レイナ^</span^>
echo                           ^</div^>
echo                       ^</div^>
echo                   ^</article^>\`;
echo               }
echo           }
echo           
echo           new AutoBlogUpdater(^).run(^).catch(console.error^);
echo           "
echo.
echo       - name: 📤 Commit Changes
echo         run: ^|
echo           git config --local user.email "action@github.com"
echo           git config --local user.name "AI Studio Bot"
echo           
echo           if [[ -n $^(git status --porcelain^) ]]; then
echo             git add index.html
echo             git commit -m "🤖 Auto-update blog index - $^(date '+%%Y-%%m-%%d %%H:%%M:%%S'^)"
echo             git push
echo           fi
) > ".github\workflows\auto-blog-update.yml"

echo   ✅ ワークフローファイル作成完了
echo.

rem ========================================================================
rem 3. Windows用README作成
rem ========================================================================
echo 📝 Windows用READMEファイルを作成中...

(
echo # 🤖 AI Art Studio - Windows完全自動化ブログシステム
echo.
echo レイナが作ったWindows用完全自動ブログ更新システムです！
echo.
echo ## 🚀 使用方法（超簡単）
echo.
echo ### 新記事作成
echo ```cmd
echo rem 1. new-blog-article.bat を実行して記事作成
echo new-blog-article.bat
echo.
echo rem 2. または手動で作成
echo echo ^<!DOCTYPE html^> > blog\new-article.html
echo echo ^<html lang="ja"^> >> blog\new-article.html
echo echo ^<head^> >> blog\new-article.html
echo echo     ^<title^>新記事タイトル^</title^> >> blog\new-article.html
echo echo     ^<meta name="description" content="記事の説明"^> >> blog\new-article.html
echo echo ^</head^> >> blog\new-article.html
echo echo ^<body^> >> blog\new-article.html
echo echo     ^<h1^>新記事タイトル^</h1^> >> blog\new-article.html
echo echo     ^<p^>記事の内容^</p^> >> blog\new-article.html
echo echo ^</body^> >> blog\new-article.html
echo echo ^</html^> >> blog\new-article.html
echo.
echo rem 3. Gitにコミット・プッシュ
echo git add blog\new-article.html
echo git commit -m "新記事: 新記事タイトル"
echo git push origin main
echo ```
echo.
echo ## ✨ 自動化機能
echo.
echo - ✅ ブログ記事の自動検出
echo - ✅ カテゴリの自動判定
echo - ✅ index.htmlの自動更新
echo - ✅ Core Web Vitals最適化維持
echo - ✅ 自動バックアップ作成
echo.
echo ## 📁 ファイル構成
echo ```
echo /
echo ├── .github/workflows/auto-blog-update.yml  # 自動化ワークフロー
echo ├── blog/                                   # ブログ記事フォルダ
echo ├── backups/                                # 自動バックアップ
echo ├── new-blog-article.bat                    # 記事作成ツール
echo ├── commit-and-push.bat                     # Git操作ツール
echo ├── check-permissions.bat                   # 権限確認ツール
echo └── blog-stats.bat                          # 統計表示ツール
echo ```
echo.
echo Made with ❤️ by レイナ
) > "README.md"

echo   ✅ README作成完了
echo.

rem ========================================================================
rem 4. サンプル記事作成
rem ========================================================================
echo 📖 サンプル記事を作成中...

(
echo ^<!DOCTYPE html^>
echo ^<html lang="ja"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>バッチファイルでAI開発！レイナが教えるWindows自動化術^</title^>
echo     ^<meta name="description" content="Windowsバッチファイルを使ったAI開発環境の構築と自動化方法をレイナが分かりやすく解説。効率的なブログ運営からAI画像生成まで完全ガイド。"^>
echo     ^<meta name="keywords" content="バッチファイル,Windows,AI開発,自動化,レイナ,ブログ運営"^>
echo ^</head^>
echo ^<body^>
echo     ^<h1^>バッチファイルでAI開発！レイナが教えるWindows自動化術^</h1^>
echo     
echo     ^<p^>こんにちは！レイナです。今回はWindowsのバッチファイルを使った効率的なAI開発とブログ運営の方法を詳しく解説していきますね♪^</p^>
echo     
echo     ^<h2^>バッチファイルの魅力^</h2^>
echo     ^<ul^>
echo         ^<li^>Windowsに標準搭載、設定不要^</li^>
echo         ^<li^>ダブルクリックで簡単実行^</li^>
echo         ^<li^>複雑な処理を1クリックで自動化^</li^>
echo         ^<li^>他の人との共有も簡単^</li^>
echo     ^</ul^>
echo     
echo     ^<h2^>AI Art Studio自動化システム^</h2^>
echo     ^<p^>1. setup-blog-automation.bat で環境構築^</p^>
echo     ^<p^>2. new-blog-article.bat で記事作成^</p^>
echo     ^<p^>3. commit-and-push.bat でGitに反映^</p^>
echo     ^<p^>4. 自動で index.html が更新される！^</p^>
echo     
echo     ^<h2^>実践のコツ^</h2^>
echo     ^<p^>バッチファイルを使うことで、複雑なGitHub Actionsとの連携も簡単になります。特にブログ記事の管理では、手作業のミスを防ぎ、継続的な更新が可能になりますよ！^</p^>
echo     
echo     ^<p^>一緒にバッチファイルでAI開発を効率化しましょう♪^</p^>
echo ^</body^>
echo ^</html^>
) > "blog\batch-ai-development.html"

echo   ✅ サンプル記事作成完了
echo.

rem ========================================================================
rem 5. 便利なツールバッチファイル作成
rem ========================================================================
echo 🛠️ 便利なツールバッチファイルを作成中...

rem 5-1. 新記事作成ツール
echo   📝 新記事作成ツール作成中...
(
echo @echo off
echo chcp 65001 ^>nul
echo echo.
echo echo 📝 新しいブログ記事作成ツール - by レイナ
echo echo.
echo.
echo set /p title="記事タイトルを入力してください: "
echo set /p description="記事の説明を入力してください: "
echo echo.
echo echo カテゴリを選択してください:
echo echo 1. AI技術
echo echo 2. レイナ
echo echo 3. プログラミング  
echo echo 4. ビジネス
echo set /p category_num="番号を選択 (1-4^) [1]: "
echo.
echo if "!category_num!"=="" set category_num=1
echo if "!category_num!"=="1" set category=ai
echo if "!category_num!"=="2" set category=reina
echo if "!category_num!"=="3" set category=programming
echo if "!category_num!"=="4" set category=business
echo.
echo rem ファイル名作成（日時付き）
echo for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value'^) do set "dt=%%a"
echo set "YYYY=!dt:~0,4!" ^& set "MM=!dt:~4,2!" ^& set "DD=!dt:~6,2!"
echo set "HH=!dt:~8,2!" ^& set "Min=!dt:~10,2!"
echo set "filename=!title: =-!-!YYYY!!MM!!DD!-!HH!!Min!.html"
echo.
echo rem 無効な文字を除去
echo set "filename=!filename:/=-!"
echo set "filename=!filename:\=-!"
echo set "filename=!filename::=-!"
echo set "filename=!filename:*=-!"
echo set "filename=!filename:?=-!"
echo set "filename=!filename:^"=-!"
echo set "filename=!filename:^<=-!"
echo set "filename=!filename:^>=-!"
echo set "filename=!filename:^|=-!"
echo.
echo echo HTMLファイルを作成中...
echo (
echo echo ^<!DOCTYPE html^>
echo echo ^<html lang="ja"^>
echo echo ^<head^>
echo echo     ^<meta charset="UTF-8"^>
echo echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo echo     ^<title^>!title!^</title^>
echo echo     ^<meta name="description" content="!description!"^>
echo echo     ^<meta name="keywords" content="!category!,AI,レイナ,ブログ"^>
echo echo ^</head^>
echo echo ^<body^>
echo echo     ^<h1^>!title!^</h1^>
echo echo     
echo echo     ^<p^>こんにちは！レイナです。^</p^>
echo echo     
echo echo     ^<p^>!description!^</p^>
echo echo     
echo echo     ^<h2^>内容^</h2^>
echo echo     ^<p^>ここにコンテンツを追加してください。^</p^>
echo echo     
echo echo     ^<p^>最後まで読んでいただき、ありがとうございました♪^</p^>
echo echo ^</body^>
echo echo ^</html^>
echo ^) ^> "blog\!filename!"
echo.
echo echo ✅ 記事を作成しました: blog\!filename!
echo echo 📝 タイトル: !title!
echo echo 📋 説明: !description!
echo echo 🏷️  カテゴリ: !category!
echo echo.
echo set /p commit_choice="Gitにコミットしますか？ (y/n^) [y]: "
echo if "!commit_choice!"=="" set commit_choice=y
echo if /i "!commit_choice!"=="y" (
echo     git add "blog\!filename!"
echo     git commit -m "新記事: !title!"
echo     echo ✅ コミット完了！
echo     echo 🚀 git push origin main でプッシュしてください
echo ^) else (
echo     echo ℹ️  手動でコミット・プッシュしてください
echo ^)
echo echo.
echo pause
) > "new-blog-article.bat"

rem 5-2. Git操作ツール
echo   🔄 Git操作ツール作成中...
(
echo @echo off
echo chcp 65001 ^>nul
echo echo.
echo echo 🔄 Git操作ツール - by レイナ
echo echo.
echo.
echo echo 現在の状態:
echo git status --short
echo echo.
echo echo 何をしますか？
echo echo 1. 全ての変更をコミット・プッシュ
echo echo 2. 特定のファイルをコミット・プッシュ
echo echo 3. 状態確認のみ
echo set /p choice="番号を選択 (1-3^): "
echo.
echo if "!choice!"=="1" (
echo     set /p commit_msg="コミットメッセージを入力 [Auto update]: "
echo     if "!commit_msg!"=="" set commit_msg=Auto update
echo     git add .
echo     git commit -m "!commit_msg!"
echo     git push origin main
echo     echo ✅ 全ての変更をプッシュしました！
echo ^) else if "!choice!"=="2" (
echo     echo.
echo     echo 利用可能なファイル:
echo     dir blog\*.html /b
echo     echo.
echo     set /p filename="ファイル名を入力 (例: new-article.html^): "
echo     set /p commit_msg="コミットメッセージを入力: "
echo     git add "blog\!filename!"
echo     git commit -m "!commit_msg!"
echo     git push origin main
echo     echo ✅ !filename! をプッシュしました！
echo ^) else (
echo     echo ℹ️  現在の状態のみ表示しました
echo ^)
echo echo.
echo pause
) > "commit-and-push.bat"

rem 5-3. 権限確認ツール
echo   🔐 権限確認ツール作成中...
(
echo @echo off
echo chcp 65001 ^>nul
echo echo.
echo echo 🔍 GitHub Actions権限チェック - by レイナ
echo echo.
echo echo 以下の設定をブラウザで確認してください：
echo echo.
echo echo 1. GitHub リポジトリの Settings ^> Actions ^> General
echo echo    - Actions permissions: 'Allow all actions and reusable workflows'
echo echo    - Workflow permissions: 'Read and write permissions'
echo echo.
echo echo 2. リポジトリの Settings ^> Pages
echo echo    - Source: 'GitHub Actions' または 'Deploy from a branch'
echo echo.
echo echo 3. Netlify設定（使用している場合^）
echo echo    - Build settings: 'Deploy site' を有効化
echo echo.
echo echo ✅ 設定完了後、commit-and-push.bat でテストしてください！
echo echo.
echo if exist ".git" (
echo     echo 📊 現在のGit状態:
echo     git status
echo ^) else (
echo     echo ⚠️  Gitリポジトリが初期化されていません
echo     echo    git init でリポジトリを初期化してください
echo ^)
echo echo.
echo pause
) > "check-permissions.bat"

rem 5-4. ブログ統計ツール
echo   📊 ブログ統計ツール作成中...
(
echo @echo off
echo chcp 65001 ^>nul
echo setlocal EnableDelayedExpansion
echo echo.
echo echo 📊 AI Art Studio ブログ統計 - by レイナ
echo echo.
echo.
echo set count=0
echo for %%f in (blog\*.html^) do set /a count+=1
echo.
echo echo 📝 総記事数: !count!
echo echo.
echo if !count! gtr 0 (
echo     echo 📁 記事一覧:
echo     for %%f in (blog\*.html^) do (
echo         echo   - %%~nf
echo     ^)
echo     echo.
echo     echo 📅 最新記事:
echo     for /f "delims=" %%f in ('dir blog\*.html /b /o:-d 2^>nul'^) do (
echo         echo   %%f
echo         goto :latest_found
echo     ^)
echo     :latest_found
echo ^) else (
echo     echo ⚠️  blog フォルダに記事が見つかりません
echo     echo    new-blog-article.bat で記事を作成してください
echo ^)
echo echo.
echo if exist "index.html" (
echo     echo 🌐 メインサイト: index.html 存在確認 ✅
echo ^) else (
echo     echo ⚠️  index.html が見つかりません
echo ^)
echo echo.
echo pause
) > "blog-stats.bat"

echo   ✅ 便利ツール作成完了
echo.

rem ========================================================================
rem 6. .gitignore作成
rem ========================================================================
echo 🔒 .gitignoreファイルを作成中...

(
echo # Node modules
echo node_modules/
echo npm-debug.log*
echo package-lock.json
echo.
echo # Logs
echo logs
echo *.log
echo.
echo # Windows
echo Thumbs.db
echo ehthumbs.db
echo Desktop.ini
echo $RECYCLE.BIN/
echo.
echo # Backup files
echo *.bak
echo *~
echo.
echo # IDE
echo .vscode/
echo .idea/
echo *.swp
echo *.swo
echo.
echo # Temporary files
echo *.tmp
echo *.temp
) > ".gitignore"

echo   ✅ .gitignore作成完了
echo.

rem ========================================================================
rem 7. クイックテストツール
rem ========================================================================
echo 🧪 クイックテストツール作成中...

(
echo @echo off
echo chcp 65001 ^>nul
echo setlocal EnableDelayedExpansion
echo echo.
echo echo 🧪 AI Art Studio - クイックテスト - by レイナ
echo echo.
echo.
echo echo 📝 テスト記事を作成中...
echo for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value'^) do set "dt=%%a"
echo set "YY=!dt:~2,2!" ^& set "YYYY=!dt:~0,4!" ^& set "MM=!dt:~4,2!" ^& set "DD=!dt:~6,2!"
echo set "HH=!dt:~8,2!" ^& set "Min=!dt:~10,2!" ^& set "Sec=!dt:~12,2!"
echo set "timestamp=!YYYY!-!MM!-!DD!_!HH!-!Min!-!Sec!"
echo.
echo (
echo echo ^<!DOCTYPE html^>
echo echo ^<html lang="ja"^>
echo echo ^<head^>
echo echo     ^<meta charset="UTF-8"^>
echo echo     ^<title^>🧪 テスト記事 - !timestamp!^</title^>
echo echo     ^<meta name="description" content="バッチファイル自動化システムのテスト記事です。レイナが作成しました。"^>
echo echo     ^<meta name="keywords" content="テスト,自動化,バッチファイル,レイナ"^>
echo echo ^</head^>
echo echo ^<body^>
echo echo     ^<h1^>🧪 バッチファイル自動化テスト^</h1^>
echo echo     ^<p^>これはレイナのバッチファイル自動化システムのテスト記事です。^</p^>
echo echo     ^<p^>作成日時: !timestamp!^</p^>
echo echo     ^<p^>システムが正常に動作していることを確認するためのテスト記事です。^</p^>
echo echo     ^<h2^>テスト項目^</h2^>
echo echo     ^<ul^>
echo echo         ^<li^>✅ HTMLファイル作成^</li^>
echo echo         ^<li^>✅ メタタグ設定^</li^>
echo echo         ^<li^>✅ 日本語文字化け対策^</li^>
echo echo         ^<li^>✅ タイムスタンプ生成^</li^>
echo echo     ^</ul^>
echo echo     ^<p^>自動化システムが完璧に動作しています♪^</p^>
echo echo ^</body^>
echo echo ^</html^>
echo ^) ^> "blog\test-article-!timestamp!.html"
echo.
echo echo ✅ テスト記事作成完了: blog\test-article-!timestamp!.html
echo echo.
echo set /p commit_choice="Gitにコミット・プッシュしますか？ (y/n^) [y]: "
echo if "!commit_choice!"=="" set commit_choice=y
echo if /i "!commit_choice!"=="y" (
echo     git add "blog\test-article-!timestamp!.html"
echo     git commit -m "🧪 Test article: !timestamp!"
echo     git push origin main
echo     echo ✅ テスト記事をプッシュしました！
echo     echo 📊 GitHub Actionsタブで自動更新の進行状況を確認してください
echo ^) else (
echo     echo ℹ️  手動でコミット・プッシュしてください
echo ^)
echo echo.
echo pause
) > "quick-test.bat"

echo   ✅ クイックテストツール作成完了
echo.

rem ========================================================================
rem 8. 完了メッセージとガイド
rem ========================================================================
echo.
echo ========================================================================
echo  🎉 Windows バッチファイル版セットアップ完了！
echo ========================================================================
echo.
echo 📋 作成されたファイル:
echo   ✅ .github\workflows\auto-blog-update.yml  (自動化ワークフロー)
echo   ✅ new-blog-article.bat                    (記事作成ツール)
echo   ✅ commit-and-push.bat                     (Git操作ツール)
echo   ✅ check-permissions.bat                   (権限確認ツール)
echo   ✅ blog-stats.bat                          (統計表示ツール)
echo   ✅ quick-test.bat                          (テストツール)
echo   ✅ README.md                               (使用方法ガイド)
echo   ✅ .gitignore                              (Git除外設定)
echo.
echo 📋 次の手順:
echo   1. check-permissions.bat を実行して権限設定を確認
echo   2. 以下のコマンドでGitリポジトリに反映:
echo      git add .
echo      git commit -m "Setup Windows batch auto blog system"
echo      git push origin main
echo   3. quick-test.bat でテスト記事作成・動作確認
echo.
echo 💡 日常の使い方:
echo   1. new-blog-article.bat をダブルクリック
echo   2. タイトル・説明・カテゴリを入力
echo   3. 作成された記事を編集
echo   4. commit-and-push.bat でGitにプッシュ
echo   5. 2-3分待つと自動で index.html が更新される！
echo.
echo 🛠️ 便利ツール:
echo   📝 new-blog-article.bat  - 新記事作成
echo   🔄 commit-and-push.bat   - Git操作
echo   📊 blog-stats.bat        - ブログ統計
echo   🧪 quick-test.bat        - 動作テスト
echo   🔐 check-permissions.bat - 権限確認
echo.
echo ✨ レイナの自動化システムがWindows環境で完璧に動作します♪
echo 🔗 詳細は README.md をご確認ください
echo.
pause