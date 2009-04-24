howm-mode.vim マニュアル
Last Change: 17-Feb-2004.
Written By: Kouichi NANASHIMA <claymoremine@anet.ne.jp>

= howmって何さ？
  hira さんによって Emacs Lisp で実装されたメモ取り用の環境です．
  あえて分類などはせずに断片的なメモを取って，後で探す時には全文検索で探すとい
  う思想で作られています．
  メモの形式は基本的に plain-text なのですが，メモ間リンクや予定・Todo 抽出な
  どの便利な機能が盛り込まれています．

  詳しくは hira さんのサイトで．
  howm: Hitoride Otegaru Wiki Modoki
  http://howm.sourceforge.jp/index-j.html

= howm-mode.vimって何さ？
  Vim Script で実装された howmです．
  同じ研究室のヤツ（Emacs ユーザ）が howm を使ってるのを見てうらやましくなり，
  howm を Vim Script で実装しちゃいました．

= インストール
  まずは howm_vim.tar.bz2 をどこかに解凍してください．
  例えば /path/to/howm にインストールする場合は以下のような感じ．
  他のところにインストールしたい場合はパスを適当に読み替えてください．

    % mv howm_vim.tar.bz2 /path/to/howm/
    % cd /path/to/howm
    % tar jxvf howm_vim.tar.bz2

  上記のコマンドを実行した後に .vimrc に下記の 1 行を付け加えます．

    set runtimepath+=/path/to/howm/howm_vim

  更に，メモのファイルをためておくディレクトリを設定します．
  例えば，/path/to/memo にためる場合は，そのディレクトリを作ってから
  .vimrc に下記の 1 行を付け加えます．
    
    let g:howm_dir = "/path/to/memo/"

  また，GNU grep と GNU find がインストールされているパスも .vimrc 内で
  指定します．

    let g:howm_grepprg = "/path/to/grep"
    let g:howm_findprg = "/path/to/find"

= 使ってみよう
  - メモを取ってみよう．
    vim を立ち上げて
      ,,c
    の順番でキーを押してみてください．
    新しいバッファが開くと思います．
    だめだった人はインストールできてないです．
    
    howm では行頭から
    = hogehoge
    と書いてあると，それがメモのタイトルになります．
    それより下は好きなように書いて下さい．
    以降 ,,c を押すたびに新しいメモが書けます．

  - メモを探してみよう．
    ,,g の順番でキーを押すと，書いたメモを全文検索できます．
    Vim の下の方に
    howm: Full text search(grep):
    と出てくるはずなので，検索したい語を入力してください．

    うまく検索できれば検索候補の一覧が出ますので，
    その候補の上で p を押すとプレビューできますし，
    リターンキーを押すと，そのファイルを開けます．

  - goto リンクを張ってみよう．
    メモの中に
    >> hogehoge
    のように書いておくと，メモ間リンクになります．
    そのリンクの上でリターンキーを押すと，＞＞ の後に書いた語が検索されます．

  - 予定や Todo を書いてみよう．
    メモの中に以下のように書いておくと，Todo になります．
    [2003-11-10]- だんだんあがってきて，日付をすぎたらだんだん沈む．
    [2003-11-10]+ 日付をすぎたらだんだんあがる．
    [2003-11-10]! 日付の一週間前からだんだんあがって，すぎたらあがりっぱなし．
    ,,t とキーを押すと，Todo 一覧が優先順位順に表示されます．

    メモの中に以下のように書いておくと，予定になります．
    [2003-11-10]@ 予定．
    ,,y とキーを押すと，予定の一覧が日付順に表示されます．

  - 他にも…
    ,,a を押すとメモファイルの一覧．
    検索結果画面で @ を押すとメモの連結．
    予定や Todo の ! やら @ のマーク上でリターンを押すと，
    give up したり処理済みにしたり．
    URL の上でリターンを押すと，ブラウザを起動したり（Chalice 必要）．
    {URL} の上でリターンを押すと，Web 取り込み．

= 書式変更について
  2003-11-16 版から本家の書式変更に追従して，
  予定・Todo の書き方やらリンクの書き方やらが変わりました．

  もしも移行せずに以前のまま使いたい場合には，
  以下の行を .vimrc にでも追加してください．
  （ただし，旧書式関係のコードは今後メンテナンスしなくなります．
    バグ報告があれば対応するかもしれませんが，
    対応の優先順位は低いと思ってください．）

  let g:howm_reminder_old_format = 1
  let g:howm_filename = '%Y_%m_%d.howm'
  let g:howm_date_pattern = '%Y/%m/%d'
  let g:howm_glink_pattern='>>'
  let g:howm_clink_pattern='<<'

  移行の方法については本家の readme を参照してください．

  以下，本家の readme より抜粋．
  > ・ 旧版からの移行 (必ずバックアップをとってから!)
  >     □ v1.0.x からの移行例
  >         ☆ 新体制に移行する場合
  >             ○ リマインダの書式変更
  >
  >                @[2003/09/25]! → [2003/09/25]!
  >                @[2003/09/25]  → [2003/09/25]-
  >                [2003/09/25]!  → [2003/09/25]:!
  >                [2003/09/25]   → [2003/09/25]
  >
  >                 ■ メモディレクトリに cd して,
  >
  >                    find . -name '*.howm' -print | xargs -n 1 ruby -p -i.bak -e '$_.gsub!(%r~(@?)(\[[0-9]+/[0-9]+/[0-9]+\])([-+@!.]?)~){|s| if ($1 == %~~ && $3 == %~~); s; else; $2 + ($1 == %~@~ ? %~~ : %~:~) + ($3 == %~~ ? %~-~ : $3); end}'
  >
  >                 ■ 確認後, *.bak を捨てる
  >             ○ 日付の書式変更
  >
  >                [2003/10/21] → [2003-10-21]
  >
  >                 ■ メモディレクトリに cd して,
  >
  >                    find . -name '*.howm' -print | xargs -n 1 ruby -p -i.bak -e '$_.gsub!(%r!(\D)(\d{4}/\d{2}/\d{2})(\D)!){|s| $1 + ($2.tr "/", "-") + $3}'
  >
  >                 ■ 確認後, *.bak を捨てる
  >             ○ リンクの書式変更 (<<, >> を <<<, >>> に)
  >                 ■ メモディレクトリに cd して,
  >
  >                    find . -name '*.howm' -print | xargs -n 1 ruby -p -i.bak -e '$_.sub!(/(<<|>>).*/){|s| $1[0,1] + s}'
  >
  >                 ■ 確認後, *.bak を捨てる
  >             ○ やりたければ, メモを改名してもよい
  >
  >                2003_10_18.howm → 2003-10-18-000000.howm
  >
  >                 ■ メモディレクトリに cd して,
  >
  >                    find . -name '*.howm' -print | ruby -ne '$_.chop!; d = File::dirname $_; f = File::basename($_).tr("_", "-").sub(/[.][^.]+$/){|s| "-000000" + s}; puts %~mv #$_ #{File::expand_path f, d}~' > ~/howm_kuzu
  >
  >                 ■ ~/howm_kuzu の内容を確認し, 問題なければ
  >
  >                    cat ~/howm_kuzu | /bin/sh
  >
  >             ○ 更新順と名前順が一致するよう, タイムスタンプをでっちあげ
  >                 ■ メモディレクトリに cd して,
  >                     ★ GNU touch の場合
  >
  >                        find . -name '*.howm' -print | sort -r | ruby -ne 'puts %~touch -d "#{ARGF.lineno} min ago" #$_~' > ~/howm_kuzu
  >
  >                     ★ それ以外の場合
  >
  >                        find . -name '*.howm' -print | sort | ruby -ne '$_.chop!; puts %~sleep 1; touch #$_~' > ~/howm_kuzu
  >
  >                 ■ ~/howm_kuzu の内容を確認し, 問題なければ
  >
  >                    cat ~/howm_kuzu | /bin/sh
  http://howm.sourceforge.jp/OLD.rd

= トラブルシューティング
  - ,,c で新しいメモが書けない．
    :set runtimepath
    とコマンドを実行して，howm-mode.vim をインストールしたディレクトリが
    runtimepath に含まれているかどうか確かめて下さい．

  - メモがセーブできない．
    :echo expand(howm_dir)
    とコマンドを実行して，スペースが含まれてないことを確認してください．
    スペースが含まれている場合は
    :let howm_dir="/path/to/howm/"
    などと実行してスペースの含まれてないパスを
    指定してください（/path/to/howm/ は任意のパス）．
    それでもダメな場合は
    :echo isdirectory(expand(howm_dir))
    とコマンドを実行して 1 と表示されることを確認してください．
    もしも 0 と表示されたら howm_dir を設定しなおすか，
    howm_dir で設定しているディレクトリを作ってください．
    それでもダメな場合は
    :echo filewritable(expand(howm_dir))
    とコマンドを実行して 2 と表示されることを確認してください．
    もしも 0 と表示されたら howm_dir を設定しなおすか，
    howm_dir で設定しているディレクトリに書き込めるように
    権限を設定しなおしてください．

  - 全文検索ができない．
    :let howm_grepprg
    とコマンドを実行して，grep がインストールされているパスが指定されているこ
    とを確かめてください．
    もしわからなければ，.vimrc に
    let g:howm_grepprg=""
    と書いて Vim を立ち上げ直せば，ひとまず検索はできます．
    ただし，検索に時間がかかると思います．

= おねがい
  このスクリプトに関する要望・質問は以下のメールアドレスに送ってください．
  （すぐ対応できるかどうかわかりませんが．）
  claymoremine@anet.ne.jp

= 参考
  - howm: Hitoride Otegaru Wiki Modoki（本家）
    http://howm.sourceforge.jp/index-j.html
    だいたい使い方は同じなので，ここのチュートリアルが参考になります．
    （メニューとか come-from リンクは Vim 版ではまだ使えませんが．）
    むしろこれ読むより hira さんのチュートリアル読んだ方がわかりやすいです．
    http://howm.sourceforge.jp/TUTORIAL.ja.rd
  - howm-mode.vim（このスクリプトの配布元）
    http://sworddancer.funkyboy.jp/howm_vim/
  - 香り屋（Chalice 配布元）
    http://www.kaoriya.net/

vim:set ts=2 sts=2 sw=2 tw=78:
