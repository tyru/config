" vim:set ts=8 sts=2 sw=2 tw=0 fdm=marker:
"
" chalice.vim - 2ch viewer 'Chalice' /
"
" Written By:  MURAOKA Taro <koron@tka.att.ne.jp>

scriptencoding cp932
let s:version = '1.9'

" 使い方
"   chaliceディレクトリを'runtimepath'に通してからVimを起動して:Chaliceを実行
"     :set runtimepath+=$HOME/chalice
"     :Chalice


"------------------------------------------------------------------------------
" RESOLVE DEPENDENCE {{{

" プラグインの無効化フラグ
if exists('plugin_chalice_disable')
  finish
endif
" alice.vimのロードを確実にする
if !exists('*AL_version')
  runtime! plugin/alice.vim
endif
" cacheman.vimのロードを確実なものにする
if !exists('g:version_cacheman')
  runtime! plugin/cacheman.vim
endif
" datutil.vimのロードを確実なものにする
if !exists('*Dat2Text')
  runtime! plugin/datutil.vim
endif
" dolib.vimのロードを確実なものにする
if !exists('g:version_dolib')
  runtime! plugin/dolib.vim
endif

"}}}

"------------------------------------------------------------------------------
" ユーザが設定可能なグローバル変数 {{{

" ユーザ名/匿名書き時の名前設定
if !exists('g:chalice_username')
  let g:chalice_username = '名無しさん@Vim%Chalice'
endif
if !exists('g:chalice_anonyname')
  let g:chalice_anonyname = ''
endif

" メールアドレス
if !exists('g:chalice_usermail')
  let g:chalice_usermail = ''
endif

" ブックマークデータファイル
if !exists('g:chalice_bookmark')
  let g:chalice_bookmark = ''
endif

" ブックマークのバックアップ作成間隔 (2日, 1時間未満なら無効化)
if !exists('g:chalice_bookmark_backupinterval')
  let g:chalice_bookmark_backupinterval = 172800
endif

" ジャンプ履歴の最大サイズ
if !exists('g:chalice_jumpmax')
  let g:chalice_jumpmax = 100
endif

" リロードタイム
"   g:chalice_reloadinterval_boardlist	板一覧のリロードタイム(1週間)
"   g:chalice_reloadinterval_threadlist	板のリロードタイム(30分間)
"   g:chalice_reloadinterval_thread	スレのリロードタイム(5分間/未使用)
if !exists('g:chalice_reloadinterval_boardlist')
  let g:chalice_reloadinterval_boardlist = 604800
endif
if !exists('g:chalice_reloadinterval_threadlist')
  let g:chalice_reloadinterval_threadlist = 1800
endif
"   g:chalice_reloadinterval_thread	スレのリロードタイム(5分間/未使用)
if !exists('g:chalice_reloadinterval_thread')
  let g:chalice_reloadinterval_thread = 300
endif

" スレ鮮度
"   スレdatの最終更新から設定された時間(2時間)が経過したかを提示する。
"   g:chalice_threadinfo		鮮度表示の有効/無効フラグ
"   g:chalice_threadinfo_expire		鮮度保持期間(1時間)
if !exists('g:chalice_threadinfo')
  let g:chalice_threadinfo = 1
endif
if !exists('g:chalice_threadinfo_expire')
  let g:chalice_threadinfo_expire = 3600
endif

" マルチユーザ設定
if !exists('g:chalice_multiuser')
  let g:chalice_multiuser = has('unix') && !has('macunix') ? 1 : 0
endif

" 外部ブラウザの指定
if !exists('g:chalice_exbrowser')
  let g:chalice_exbrowser = ''
endif

" ユーザファイルの位置設定
if !exists('g:chalice_basedir')
  if g:chalice_multiuser
    if has('win32')
      let g:chalice_basedir = $HOME . '/vimfiles/chalice'
    else
      let g:chalice_basedir = $HOME . '/.vim/chalice'
    endif
  else
    let g:chalice_basedir = substitute(expand('<sfile>:p:h'), '[/\\]plugin$', '', '')
  endif
endif

if !exists('g:chalice_menu_url')
  let g:chalice_menu_url = ''
endif

" PROXYとか書き加えると良いかも
if !exists('g:chalice_curl_options')
  let g:chalice_curl_options= ''
endif

" 書き込み時に特殊な設定をしたい場合
if !exists('g:chalice_curl_writeoptions')
  let g:chalice_curl_writeoptions= ''
endif

" Cookie使う?
if !exists('g:chalice_curl_cookies')
  let g:chalice_curl_cookies = 1
endif

" gzip圧縮使用フラグ
if !exists('g:chalice_gzip')
  let g:chalice_gzip = 1
endif

" 0以上に設定するとデバッグ用にメッセージが多めに入ってる
if !exists('g:chalice_verbose')
  let g:chalice_verbose = 0
endif

" Chalice 起動時に'columns'を変えることができる(-1:無効)
if !exists('g:chalice_columns')
  let g:chalice_columns = -1
endif

" 板一覧のデフォルト幅を設定する
if !exists('g:chalice_boardlist_columns')
  let g:chalice_boardlist_columns = 15
endif

" スレ一覧のデフォルト高を設定する
if !exists('g:chalice_threadlist_lines')
  let g:chalice_threadlist_lines = 10
endif

" 板一覧と栞でfoldに使用する記号を指定する
if !exists('g:chalice_foldmarks')
  let g:chalice_foldmarks = ''
endif

" ステータスラインに項目を追加するための変数
if !exists('g:chalice_statusline')
  let g:chalice_statusline = ''
endif

" (非0の時)'q'によるChalice終了時に意思確認をしない
if !exists('g:chalice_noquery_quit')
  let g:chalice_noquery_quit = 1
endif

" (非0の時)カキコ実行の意思確認をしない
if !exists('g:chalice_noquery_write')
  let g:chalice_noquery_write = 0
endif

" 起動時の状態を設定する(bookmark,offline,nohelp,aa=[no|noanime],novercheck)
if !exists('g:chalice_startupflags')
  let g:chalice_startupflags = ''
endif

" (非0の時)オートプレビュー機能を使用する
if !exists('g:chalice_preview')
  let g:chalice_preview = 1
endif

" 動作時の各種設定(1, above, autoclose, stay)
if !exists('g:chalice_previewflags')
  let g:chalice_previewflags = ''
endif

" redraw! による再描画を抑制する(遅い端末向け)
if !exists('g:chalice_noredraw')
  let g:chalice_noredraw = 0
endif

" 書込み時に実体参照へ変更する文字を指定(amp,nbsp2)
if !exists('g:chalice_writeoptions')
  let g:chalice_writeoptions = 'amp,nbsp2'
endif

" 読み込み時の動作に関するオプション(noenc)
if !exists('g:chalice_readoptions')
  let g:chalice_readoptions = ''
endif

" スレ一覧表示時に更新チェックをするかどうかを指定(0: チェックしない)
if !exists('g:chalice_autonumcheck')
  let g:chalice_autonumcheck = 0
endif

" アニメーション時のウェイト。最適な値はCPUや表示装置に依存
if !exists('g:chalice_animewait')
  let g:chalice_animewait = 200
endif

" 偽装タイトル(お仕事中に使いましょう)
if !exists('g:chalice_titlestring')
  let g:chalice_titlestring = ''
endif

" NGワードの指定パターン("\<NL>"区切りで複数のパターンを指定可能)
if !exists('g:chalice_ngwords')
  let g:chalice_ngwords = ''
endif

" NGワード適用時の表示ラベル
if !exists('g:chalice_localabone')
  let g:chalice_localabone = 'ローカルあぼーん'
endif

" 2ch認証用ID
if !exists('g:chalice_loginid')
  let g:chalice_loginid = ''
endif

" 2ch認証用ID
if !exists('g:chalice_password')
  let g:chalice_password = ''
endif

" フォーマットキャッシュの有効日数
if !exists('g:chalice_formatedcache_expire') || g:chalice_formatedcache_expire + 0 < 1
  let g:chalice_formatedcache_expire = 14
endif

" 巡回の停止カテゴリ名
if !exists('g:chalice_cruise_endmark')
  let g:chalice_cruise_endmark = '終了'
endif

"}}}

"------------------------------------------------------------------------------
" 仮定数値 {{{
"   将来はグローバルオプション化できそうなの。もしくはユーザが書き換えても良
"   さそうなの。

let s:prefix_board = '  スレ一覧 '
let s:prefix_thread = '  スレッド '
let s:prefix_write = '  書込スレ '
let s:prefix_preview = '  プレビュー '
let s:label_vimtitle = 'Chalice ～2ちゃんねる閲覧プラグイン～'
let s:label_boardlist = '板一覧'
let s:label_newthread = '[新スレ]'
let s:label_bookmark = '  スレの栞'
let s:label_offlinemode = 'オフラインモード'
let s:label_wastetime = '利用時間'
let s:label_wastetime_sum = '無駄時間合計'
let s:label_board = '[板]'
let s:label_board_escaped = escape(s:label_board, '[]')
let s:label_localabone = 'Chalice,aboned,ローカルあぼーん'
" メッセージ
let s:choice_yn = "&Yes\n&No"
let s:choice_ync = "&Yes\n&No\n&Cancel"
let s:choice_rac = "&Replace\n&Append\n&Cancel"
let s:msg_confirm_appendwrite_yn = 'バッファの内容が書き込み可能です. 書き込みますか?'
let s:msg_confirm_appendwrite_ync = '本当に書き込みますか?'
let s:msg_confirm_replacebookmark = 'ガイシュツURLです. 置き換えますか?'
let s:msg_confirm_quit = '本当にChaliceを終了しますか?'
let s:msg_prompt_articlenumber = '何番、逝ってよし? '
let s:msg_warn_preview_on = 'プレビュー機能を有効化しました'
let s:msg_warn_preview_off = 'プレビュー機能を解除しました'
let s:msg_warn_netline_on = 'オフラインモードを解除しました'
let s:msg_warn_netline_off = 'オフラインモードに切替えました'
let s:msg_warn_oldthreadlist = 'スレ一覧が古い可能性があります. R で更新します.'
let s:msg_warn_bookmark = '栞は閉じる時に自動的に保存されます.'
let s:msg_warn_bmkcancel = '栞への登録はキャンセルされました.'
let s:msg_warn_dontusetoomuch = '利用し過ぎに注意シル!!'
let s:msg_warn_datdirtoolsuccess = 'DATDIR形式への移行が完了しました.'
let s:msg_warn_boardmoved = '板が移動した可能性があります.'
let s:msg_wait_threadformat = '貴様ら!! スレッド整形中のため、しばらくお待ちください...'
let s:msg_wait_download = 'ダウンロード中...'
let s:msg_wait_login = 'ログイン中...'
let s:msg_error_nocurl = 'Chaliceには正しくインストールされたcURLが必要です.'
let s:msg_error_nogzip = 'Chaliceには正しくインストールされたgzipが必要です.'
let s:msg_error_noconv = 'Chaliceを非CP932環境で利用するには qkc もしくは nkf が必要です.'
let s:msg_error_cantjump = 'カーソルの行にアンカーはありません. 髭氏'
let s:msg_error_invalidanchor = 'アンカーが無効です. 鬱氏'
let s:msg_error_cantpreview = 'DATがローカルにないのでプレビューできません.'
let s:msg_error_appendnothread = 'ゴルァ!! スレッドがないYO!!'
let s:msg_error_creatnoboard = '板を指定しないと糞スレすらも建ちません'
let s:msg_error_writebufhead = '書き込みバッファのヘッダが不正です.'
let s:msg_error_writebufbody = '書き込みメッセージが空です.'
let s:msg_error_writeabort = '書き込みを中止しました.'
let s:msg_error_writecancel = '書き込みをキャンセルします.'
let s:msg_error_writetitle = '新スレにはタイトルが必要です.'
let s:msg_error_writecookie = '書き込もうとしている掲示板の投稿規約を全て承諾する場合にのみ、内容を確認して再度書き込み直してください. 書き込みを行った場合は、自動的にそれらの規約に従うものと見做されます.'
let s:msg_error_writeerror = '書き込みエラーです.'
let s:msg_error_writefalse = '書き込めたようですが注意があります.'
let s:msg_error_writecheck = '書き込めたようですが警告があります.'
let s:msg_error_writehighload = 'サーバ過負荷のため書き込みできません.'
let s:msg_error_writenottrue = '不明な書き込みエラーです.'
let s:msg_error_addnoboardlist = '板一覧から栞へ登録出来ません.'
let s:msg_error_addnothread = 'まだスレを開いていないので登録出来ません.'
let s:msg_error_addnothreadlist = 'スレ一覧から栞へ登録出来ません.'
let s:msg_error_nocachedir = 'キャッシュディレクトリを作成出来ません.'
let s:msg_error_nothread = 'スレッドが存在しないか, 倉庫入り(HTML化)待ちです.'
let s:msg_error_accesshere = '詳細は下記URLに外部ブラウザでアクセスしてみてください.'
let s:msg_error_newversion = 'Chaliceの新しいバージョン・パッチがリリースされています.'
let s:msg_error_doupdate = 'Subversion版を利用している場合はsvn updateで最新版を入手できます.'
let s:msg_error_htmlnotopen = 'スレッドが開かれていません.'
let s:msg_error_htmlnodat = 'スレッドのdatがありません.'
let s:msg_error_nodatdirtool = 'DATDIRへの移行ツールが見つかりません. 確認してください.'
let s:msg_error_datdirtoolfailed = 'DATDIR移行ツールが失敗しました. なんでだろ?'
let s:msg_thread_hasnewarticles = '新しい書き込みがあります.'
let s:msg_thread_nonewarticle = '新たな書き込みはありません'
let s:msg_thread_nonewwait = '数秒後に巡回を続行します. (CTRL-Cで割込終了)'
let s:msg_thread_dead = '倉庫に落ちたかHTML化待ちとオモワレ.'
let s:msg_thread_lost = '倉庫に落ちました.'
let s:msg_thread_unknown = '初めて見るスレです. 更新チェックはできません.'
let s:msg_chalice_quit = 'Chalice ～～～～終了～～～～'
let s:msg_chalice_start = 'Chalice キノーン'
" 1行ヘルプ
let s:msg_help_boardlist = '(板一覧)  <CR>:板決定  j/k:板選択  h/l:カテゴリ閉/開  R:更新'
let s:msg_help_threadlist = '(スレ一覧)  <CR>:スレ決定 j/k:スレ選択  d:dat削除  R:更新'
let s:msg_help_thread = '(スレッド)  i:書込  I:sage書込  a:匿名書込  A:匿名sage  r:更新 =:整形'
let s:msg_help_bookmark = '(スレの栞)  <CR>:URL決定  h/l:閉/開 <C-A>:閉じる  [編集可能]'
let s:msg_help_write = '(書き込み)  <C-CR>:書き込み実行  <C-W>c:閉じる  [編集可能]'
let s:msg_help_rewrite = '書き込みに失敗したと思われる文章を復帰しました.'
"}}}

"------------------------------------------------------------------------------
" 定数値 CONSTANT {{{
"   内部でのみ使用するもの

" デバッグフラグ (DEBUG FLAG)
let s:debug = 0

" 2ch認証のための布石
let s:user_agent_enable = 1
" 2ch依存データ
let s:encoding = 'cp932'
let s:host = 'www.2ch.net'
let s:remote = '2ch.html'
" 2chのメニュー取得用初期データ
let s:menu_host = 'menu.2ch.net'
let s:menu_remotepath = 'bbsmenu.html'
let s:menu_localpath = 'bbsmenu'
" ウィンドウ識別子
let s:buftitle_boardlist  = 'Chalice_2ちゃんねる_板一覧'
let s:buftitle_threadlist = 'Chalice_2ちゃんねる_スレ一覧'
let s:buftitle_thread	  = 'Chalice_2ちゃんねる_スレッド'
let s:buftitle_write	  = 'Chalice_2ちゃんねる_書き込み'
let s:buftitle_preview	  = 'Chalice_2ちゃんねる_プレビュー'
" ブックマーク自動バックアップ間隔の下限
let s:minimum_backupinterval = 3600
let s:bookmark_filename = 'chalice.bmk'
let s:bookmark_backupname = 'bookmark.bmk'
let s:bookmark_backupsuffix = '.chalice_backup'

" スクリプトIDを取得
map <SID>xx <SID>xx
let s:sid = substitute(maparg('<SID>xx'), 'xx$', '', '')
let g:chalice_sid = s:sid
unmap <SID>xx
" スクリプトのディレクトリを取得
let s:scriptdir = expand('<sfile>:p:h')

" バージョンチェック
let s:verchk_verurl = 'http://www.kaoriya.net/update/chalice-version'
let s:verchk_path = substitute(s:scriptdir, 'plugin$', '', '').'VERSION'
let s:verchk_interval = 86400
let s:verchk_url_1 = s:verchk_verurl
let s:verchk_url_2 = 'http://www.kaoriya.net/#CHALICE'

" 起動フラグ
let s:opened = 0
let s:opened_write = 0
let s:dont_download = 0

" 外部コマンド実行ファイル名
let s:cmd_curl = ''
let s:cmd_conv = ''
let s:cmd_gzip = ''

" MATCH PATTERNS
let s:mx_thread_dat = '^[ !\*+x] \(.*\) (\%(\%(\d\+\|???\)/\)\?\(\d\+\)).*\t\+\(\d\+\%(_\d\+\)\?\.\%(dat\|cgi\)\)'
let s:mx_anchor_num = '>>\(\(\d\+\)\%(-\(\d\+\)\)\?\)'
let s:mx_anchor_url = '\(\(h\?ttps\?\|ftp\)://'.g:AL_pattern_class_url.'\+\)'
let s:mx_anchor_www = 'www'.g:AL_pattern_class_url.'\+'
let s:mx_anchor_from = 'From:\s*\([1-9]\d\{,2}\)'
let s:mx_url_parse = 'http://\([^/]\+\)\%(/\([^?#]\+\)\)\?\%(?\([^#]\+\)\)\?\%(#\(.\+\)\)\?'
let s:mx_url_2channel = 'http://\(..\{-\}\)/test/read.cgi\(/[^/]\+\)/\(\d\+\%(_\d\+\)\?\)\(.*\)'
let s:mx_servers_oldkako = '^\(piza\.\|www\.bbspink\|mentai\.2ch\.net/mukashi\|www\.2ch\.net/\%(tako\|kitanet\)\)'
let s:mx_servers_jbbstype = '\%(^jbbs\.shitaraba\.com\|\.\%(machibbs.com$\|machi\.to$\|jbbs\.net\)\)'

let s:mx_servers_shitaraba = '^www\.shitaraba\.com$'
let s:mx_servers_machibbs = '\.\%(machibbs\.com\|machi\.to\)$'
let s:mx_servers_euc = '\%(jbbs\.net\|shitaraba\.com\)'
let s:mx_html2dat_jbbs = '\m^<dt>\d\+\s*名前：\%(<a href="mailto:\([^"]*\)">\)\?\(.\{-\}\)\%(</a>\)\?\s*投稿日：\s*\(.*\)\s*<br>\s*<dd>'
let s:mx_html2dat_2ch = '\m^<dt>\d\+\s*：\%(<a href="mailto:\([^"]*\)">\)\?\(.\{-\}\)\%(</a>\)\?\s*：\s*\(.*\)\s*<dd>'

"}}}

"------------------------------------------------------------------------------
" AUTO COMMANDS {{{
" オートコマンドの設定

let s:autocmd_installed = 0

function! s:AutocmdInstall()
  if s:autocmd_installed != 0
    return
  else
    let s:autocmd_installed = 1
  endif
  augroup Chalice
    autocmd!
    execute "autocmd BufWriteCmd " . s:buftitle_write . " call <SID>DoWriteBuffer('')"
    execute "autocmd BufDelete " . s:buftitle_write . " call <SID>OnCloseWriteBuffer()"
    execute "autocmd BufEnter " . s:buftitle_boardlist . " call s:Redraw('force')|call s:EchoH('WarningMsg',s:msg_help_boardlist)|normal! 0"
    execute "autocmd BufEnter " . s:buftitle_threadlist . " call s:Redraw('force')|call s:EchoH('WarningMsg',s:opened_bookmark?s:msg_help_bookmark : s:msg_help_threadlist)"
    execute "autocmd BufEnter " . s:buftitle_thread . " call s:Redraw('force')|call s:EchoH('WarningMsg',s:msg_help_thread)"
    execute "autocmd BufDelete " . s:buftitle_threadlist . " if s:opened_bookmark|call s:CloseBookmark()|endif"
    execute "autocmd CursorHold " . s:buftitle_thread . " call s:OpenPreview_autocmd()"
    execute "autocmd CursorHold " . s:buftitle_preview . " call s:OpenPreview_autocmd()"
  augroup END
endfunction

function! s:AutocmdUninstall()
  let s:autocmd_installed = 0
  augroup Chalice
    autocmd!
  augroup END
endfunction

function! s:OnEnterBoardlist()
  call s:Redraw('force')
  call s:EchoH('WarningMsg', s:msg_help_boardlist)
  normal! 0
endfunction

function! s:OnEnterThreadlist()
  call s:Redraw('force')
  if s:opened_bookmark
    call s:EchoH('WarningMsg', s:msg_help_bookmark)
  else
    call s:EchoH('WarningMsg', s:msg_help_threadlist)
  endif
endfunction

function! s:OnEnterThread()
  call s:Redraw('force')
  call s:EchoH('WarningMsg', s:msg_help_threadlist)
endfunction

"}}}

"------------------------------------------------------------------------------
" GLOBAL FUNCTIONS {{{
" グローバル関数

function! Chalice_GetCacheDir()
  if !exists('s:dir_cache')
    call s:CheckEnvironment()
  endif
  return s:dir_cache
endfunction

function! Chalice_foldmark(id)
  if a:id == 0
    return s:foldmark_0
  elseif a:id == 1
    return s:foldmark_1
endfunction

"}}}

"------------------------------------------------------------------------------
" DEVELOPING FUNCTIONS {{{
" 開発途上関数もしくは未整理

function! s:GetHostEncoding(host)
  if AL_hasflag(g:chalice_readoptions, 'noenc')
    return ''
  else
    if a:host =~# s:mx_servers_euc
      if AL_hasflag(&fileencodings, 'euc-jisx0213')
	return 'euc-jisx0213'
      else
	return 'euc-jp'
      endif
    else
      return 'cp932'
    endif
  endif
endfunction

function! s:DatdirOn()
  let datdirtool = AL_basepath(s:scriptdir).'/tools/datdir/2datdir.vim'
  if !filereadable(datdirtool)
    call AL_echokv('datdirtool', datdirtool)
    call AL_echo(s:msg_error_nodatdirtool, 'ErrorMsg')
    return 0
  endif
  execute 'source '.escape(datdirtool, ' ')
  " 実行結果の検証
  let datd = s:GetPath_Datdir()
  let s:datdir_enabled = isdirectory(datd) && filewritable(datd)
  if s:datdir_enabled
    call AL_echo(s:msg_warn_datdirtoolsuccess, 'WarningMsg')
    if exists(':ChaliceDatdirOn')
      delcommand ChaliceDatdirOn
    endif
  else
    call AL_echo(s:msg_error_datdirtoolfailed, 'ErrorMsg')
  endif
  return s:datdir_enabled
endfunction

function! s:HighlightWholeline(linenr, syngroup)
  call AL_execute('match '.a:syngroup.' /^.*\%'.a:linenr.'l.*$/')
endfunction

function! s:StringFormatTime(seconds)
  let sec  = a:seconds
  let min  = sec / 60
  let hour = min / 60
  let day  = hour / 24
  let sec  = sec % 60
  let min  = min % 60
  let hour = hour % 24
  return AL_string_formatnum(day, 2, '0').':'.AL_string_formatnum(hour, 2, '0').':'.AL_string_formatnum(min, 2, '0').':'.AL_string_formatnum(sec, 2, '0')
endfunction

" 起動AA表示
function! s:StartupAA(filename, wait)
  if !filereadable(a:filename)
    return 0
  endif
  " バッファにAAを読み込む
  call s:GoBuf_Thread()
  if line('$') > 1
    call append('$', '')
  endif
  normal! G
  let oldline = line('.')
  silent! execute 'read '.a:filename
  let insrange = line("'[").','.line("']")
  silent! execute insrange.'s/%VERID%/'.s:version.'/g'
  " アニメーション
  if a:wait >= 0
    " 初期化
    let spnum = 70
    let spstr = AL_string_multiplication(' ', spnum)
    let save_hlsearch = &hlsearch
    let save_wrap = &wrap
    set nohlsearch
    set nowrap
    silent! execute insrange.'s/^/'.spstr.'/'
    call AL_del_lastsearch()
    redraw
    " アニメーションループ
    let i = 0
    while i < spnum
      silent! execute insrange.'s/^ //'
      redraw
      let wait = a:wait
      while wait > 0
	let wait = wait - 1
      endwhile
      let i = i + 1
    endwhile
    " 後片付け
    call AL_del_lastsearch()
    let @/ = ''
    let &hlsearch = save_hlsearch
    let &wrap = save_wrap
  endif
  execute oldline
  return 1
endfunction

function! s:AdjustWindowSizeDefault()
  call s:AdjustWindowSize(g:chalice_boardlist_columns, g:chalice_threadlist_lines)
endfunction

function! s:AdjustWindowSize(dirwidth, listheight)
  let winnum = winnr()
  if s:GoBuf_BoardList() >= 0
    execute a:dirwidth.' wincmd |'
  endif
  if s:GoBuf_ThreadList() >= 0
    execute a:listheight.' wincmd _'
  endif
  execute winnum.' wincmd w'
endfunction

function! s:CheckNewVersion(verurl, verpath, vercache, ...)
  if !filereadable(a:verpath)
    return 0
  endif
  let interval = a:0 > 0 ? a:1 : 0

  " バージョン情報ダウンロード
  if !filereadable(a:vercache) || localtime() - getftime(a:vercache) > interval
    let mx = '^http://\(.*\)/\([^/]*\)$'
    let host  = AL_sscan(a:verurl, mx, '\1')
    let rpath = AL_sscan(a:verurl, mx, '\2')
    call s:HttpDownload(host, rpath, a:vercache, '')
  endif
  if !filereadable(a:vercache)
    return 0
  endif

  " 各バージョン番号をファイルから読み取る
  call AL_execute('vertical 1sview ++enc= '.escape(a:verpath, ' '))
  setlocal bufhidden=delete
  let s:version = getline(1)
  call AL_execute('view '.escape(a:vercache, ' '))
  setlocal bufhidden=delete
  let vernew = getline(1)
  silent! bwipeout!

  return AL_compareversion(s:version, vernew) > 0 ? 1 : 0
endfunction

function! s:CheckThreadUpdate(flags)
  if AL_hasflag(a:flags, 'write')
    if exists('b:url')
      call s:HasNewArticle(b:url)
    endif
    call s:GoBuf_Write()
  endif
endfunction

function! s:NextLine()
  if AL_islastline()
    normal! gg
  else
    normal! j
  endif
endfunction

function! s:ViewCursorLine()
  if foldclosed(line('.')) > 0
    normal! zv
  endif
endfunction

"
" 巡回っぽいことをする
"
function! s:Cruise(flags)
  if AL_hasflag(a:flags, 'thread')
    " スレッドでの巡回
    if AL_islastline() && s:opened_bookmark
      call s:GoBuf_ThreadList()
      call s:ViewCursorLine()
      call s:NextLine()
      call s:Cruise(AL_delflag(AL_addflag(a:flags, 'bookmark'), 'thread'))
    else
      call AL_execute("normal! \<C-F>")
    endif
  elseif AL_hasflag(a:flags, 'bookmark')
    while s:opened_bookmark
      " ブックマークでの巡回
      call s:ViewCursorLine()
      let curline = getline('.')
      if !s:ParseURL(matchstr(curline, s:mx_anchor_url))
	if exists('g:chalice_cruise_endmark') && g:chalice_cruise_endmark.'X' !=# 'X' && curline =~# '\m^\s*'.Chalice_foldmark(0).'\s*'.g:chalice_cruise_endmark.'$'
	  break
	else
	  call s:NextLine()
	endif
      else
	" エントリーがスレッドなら新着チェック
	normal! z.
	" Hotlink表示
	call s:HighlightWholeline(line('.'), 'DiffAdd')
	" スレ読み込み。ifmodifiedが肝。
	let retval = s:UpdateThread('', s:parseurl_host, s:parseurl_board, s:parseurl_dat, 'continue,ifmodified')
	call s:GoBuf_ThreadList()
	if retval > 0
	  " 更新があった場合
	  call s:HighlightWholeline(line('.'), 'DiffChange')
	  call s:GoBuf_Thread()
	  call s:AddHistoryJump(s:ScreenLine(), line('.'))
	  while getchar(0) != 0
	  endwhile
	  call AL_echo(s:msg_thread_hasnewarticles, 'WarningMsg')
	else
	  " 無かった場合
	  call s:HighlightWholeline(line('.'), 'Constant')
	  call s:NextLine()
	  " エラーメッセージ選択
	  if retval == -3
	    call s:EchoH('Error', s:msg_thread_lost)
	  elseif retval == -2
	    call s:EchoH('Error', s:msg_thread_dead)
	  elseif s:IsBoardMoved(s:parseurl_board, s:parseurl_host)
	    call s:EchoH('Error', s:msg_warn_boardmoved)
	  else
	    if AL_hasflag(a:flags, 'semiauto')
	      call s:EchoH('', s:msg_thread_nonewwait)
	      sleep 5
	      continue
	    else
	      call s:EchoH('', s:msg_thread_nonewarticle)
	    endif
	  endif
	endif
	break
      endif
    endwhile
  endif
endfunction

"
" 透明あぼーんを示すフラグファイルを作成する。透明あぼーん化した日時とスレタ
" イトルを記入。
"
function! s:AboneThreadDat()
  call s:GoBuf_ThreadList()
  " バッファがスレ一覧ではなかった場合、即終了
  if b:host == '' || b:board == ''
    return
  endif

  " カーソルの現在位置からdat名を取得
  let curline = getline('.')
  if curline =~ s:mx_thread_dat
    let title = AL_sscan(curline, s:mx_thread_dat, '\1')
    let dat = AL_sscan(curline, s:mx_thread_dat, '\3')
    let abone = s:GenerateAboneFile(b:host, b:board, dat)
    call AL_mkdir(AL_basepath(abone))
    call AL_execute('redir! >' . abone)
    silent echo strftime("%Y/%m/%d %H:%M:%S " .title)
    silent echo ""
    redir END
    if g:chalice_threadinfo
      call s:FormatThreadInfoWithoutUndo(line('.'), line('.'), 'numcheck')
      call s:WriteFormatedCache_Subject(b:host, b:board)
    endif
  endif
endfunction

"
" スレの.datを削除する。aboneファイルがあった場合にはそちらを優先して削除。
"
function! s:DeleteThreadDat()
  call s:GoBuf_ThreadList()
  " バッファがスレ一覧ではなかった場合、即終了
  if b:host == '' || b:board == ''
    return
  endif

  " カーソルの現在位置からdat名を取得
  let curline = getline('.')
  if curline =~ s:mx_thread_dat
    let dat = AL_sscan(curline, s:mx_thread_dat, '\3')
    " host,board,datからローカルファイル名を生成
    let local = s:GenerateLocalDat(b:host, b:board, dat)
    let abone = s:GenerateAboneFile(b:host, b:board, dat)
    if filereadable(abone)
      " aboneファイルがあれば先に消去
      call delete(abone)
    elseif filereadable(local)
      " datファイルがあれば消去
      call delete(local)
      " フォーマットキャッシュも削除
      if s:fcachedir_enabled
	call CACHEMAN_clear(s:fcachedir, s:GetPath_FormatedCache(b:host, b:board, dat))
      endif
    endif
    " 表示内容を更新
    if g:chalice_threadinfo
      call s:FormatThreadInfoWithoutUndo(line('.'), line('.'), 'numcheck')
      call s:WriteFormatedCache_Subject(b:host, b:board)
    endif
  endif
endfunction

"
" 引数があれば引数の、なければカーソル下のURLを取り出し、スレ更新の有無を
" チェックする。
"
function! s:HasNewArticle(...)
  " 引数もしくは現在行からURLだけを取り出し、host/board/datを抽出
  if a:0 > 0
    let url = a:1
  else
    let url = getline('.')
  endif
  let url = matchstr(url, s:mx_url_2channel)
  if url == ''
    return 0
  endif
  let host = AL_sscan(url, s:mx_url_2channel, '\1')
  let board = AL_sscan(url, s:mx_url_2channel, '\2')
  let dat = AL_sscan(url, s:mx_url_2channel, '\3.dat')

  " 未知のスレ、倉庫落ちしたスレはチェック対象外とする
  let local_dat = s:GenerateLocalDat(host, board, dat)
  let local_kako = s:GenerateLocalKako(host, board, dat)
  if !filereadable(local_dat)
    call s:EchoH('Error', s:msg_thread_unknown)
    return 0
  elseif filereadable(local_kako)
    call s:EchoH('Error', s:msg_thread_lost)
    return 0
  endif

  let remote = s:GenerateRemoteDat(host, board, dat)
  let result = s:HttpDownload(host, remote, local_dat, 'continue,head')

  if result == 206
    call s:EchoH('WarningMsg', s:msg_thread_hasnewarticles)
    return 1
  elseif result == 302
    call s:EchoH('Error', s:msg_thread_dead)
    return 0
  else
    call s:EchoH('', s:msg_thread_nonewarticle)
    return 0
  endif
endfunction

"
" URLをChaliceで開く
"
" Flags:
"   external		強制的に外部ブラウザを使用する
"   noboardcheck	板一覧チェックを行なわない
function! s:HandleURL(url, flag)
  " 通常のURLだった場合、無条件で外部ブラウザに渡している。URLの形をみて2ch
  " ならば内部で開く。
  if a:url !~ '\(https\?\|ftp\)://'.g:AL_pattern_class_url.'\+'
    return 0
  endif
  if AL_hasflag(a:flag, 'external')
    " 強制的に外部ブラウザを使用するように指定された
    call s:OpenURL(a:url)
    return 2
  elseif !s:ParseURL(a:url)
    " Chaliceで取り扱えるURLではない時:
    " 板のURLかどうかを板一覧を利用して判断し、板ならばそれを開く
    let oldbuf = bufname('%')
    call s:GoBuf_BoardList()
    let nr = AL_hasflag(a:flag, 'noboardcheck') ? 0 : search('\V'.escape(a:url, "\\"), 'w')
    if nr != 0
      normal! zO0z.
      execute maparg("<CR>")
      call AL_selectwindow(oldbuf)
    else
      call AL_selectwindow(oldbuf)
      call s:OpenURL(a:url)
    endif
    return 2
  else
    " Chaliceで取り扱えるURLの時

    " ジャンプヒストリを追加する
    if !AL_hasflag(a:flag, '\cnoaddhist')
      call s:AddHistoryJump(s:ScreenLine(), line('.'))
    endif
    " プレビューウィンドウを閉じる
    if !(g:chalice_preview && AL_hasflag(g:chalice_previewflags, '1'))
      call s:ClosePreview()
    endif

    " s:parseurl_host, s:parseurl_board, s:parseurl_dat,
    " s:parseurl_range_start, s:parseurl_range_end, s:parseurl_range_mode,
    " はParseURL()内で設定される暗黙的な戻り値。
    if AL_hasflag(a:flag, 'firstarticle')
      call s:OpenThreadOnlyone(s:parseurl_host, s:parseurl_board, s:parseurl_dat)
    else
      call s:OpenThreadNormal(s:parseurl_host, s:parseurl_board, s:parseurl_dat, s:parseurl_range_start, s:parseurl_range_end, s:parseurl_range_mode)
    endif

    " ヒストリに追加(副作用:スレバッファへ移動)
    if !AL_hasflag(a:flag, '\cnoaddhist')
      call s:AddHistoryJump(s:ScreenLine(), line('.'))
    endif
  endif
  return 1
endfunction

" 指定のスレッドの1だけを開く
"
" Referenced: HandleURL()
function! s:OpenThreadOnlyone(host, board, dat)
  let mx = '\m^http://\([^/]\+\)/\(.\+\)$'
  let url = s:GenerateThreadURL(a:host, a:board, a:dat, 'onlyone')
  let tmpfile = tempname()
  let result = s:HttpDownload(AL_sscan(url, mx, '\1'), AL_sscan(url, mx, '\2'), tmpfile, 'noagent')
  if result == 200
    " 1を整形
    call s:GoBuf_Thread()
    let save_undolevels = &undolevels
    set undolevels=-1
    call AL_buffer_clear()
    call AL_execute('read ++enc='.s:GetHostEncoding(a:host)." ".tmpfile)
    silent! 1 delete _
    " タイトルの取得
    let mx = '<title>\(.*\)<\/title>'
    if search(mx, 'W') > 0
      let title = AL_sscan(getline('.'), mx, '\1')
    else
      let title = 'NOTITLE'
    endif
    " 記事以外の内容を削除
    silent! %substitute/<\/\?dl>/\r/g
    silent! global!/^<dt>1/ delete _
    " HTMLをDATに変換
    let data = substitute(getline(1), '\%(<br>\)\+$', '', 'ie')
    if a:host =~ s:mx_servers_jbbstype
      let data = substitute(data, s:mx_html2dat_jbbs, '\2<>\1<>\3<>', 'ie').'<>'
    else
      let data = substitute(data, s:mx_html2dat_2ch, '\2<>\1<>\3<>', 'ie').'<>'
    endif
    " DATをTXTに整形してバッファへ貼り付け
    silent! normal! 1G"_dd
    call AL_append_multilines(substitute(DatLine2Text(1, data), "\r", "\<NL>", 'ge'))
    silent! normal! 1G"_dd
    " スレのメタ情報を追加
    call append(0, 'Title: '.title)
    call append(1, 'URL: '.s:GenerateThreadURL(a:host, a:board, a:dat, 'raw'))
    call AL_del_lastsearch()
    " スレに必要な変数を設定
    let b:host	= a:host
    let b:board	= a:board
    let b:dat	= a:dat
    let b:title	    = s:prefix_thread . title
    let b:title_raw = title
    let &undolevels = save_undolevels
    " カーソルをURLへ移動
    normal! 2G
  else
    call s:EchoH('Error', s:msg_thread_dead." ".result)
  endif
  call delete(tmpfile)
endfunction

" 指定スレッドを開く
"
" Referenced: HandleURL()
function! s:OpenThreadNormal(host, board, dat, rstart, rend, rmode)
  let curarticle = s:UpdateThread('', a:host, a:board, a:dat, 'continue')

  if a:rmode =~ 'r'
    if a:rmode !~ 'l'
      " 非リストモード
      " 表示範囲後のfolding
      if a:rend != '$'
	let fold_start = s:GetLnum_Article(a:rend + 1)  - 1
	if 0 < fold_start
	  call AL_execute(fold_start . ',$fold')
	endif
      endif
      " 表示範囲前のfolding
      if a:rstart > 1
	let fold_start = s:GetLnum_Article(a:rmode =~ 'n' ? 1 : 2) - 1
	let fold_end = s:GetLnum_Article(a:rstart) - 2
	if 0 < fold_start && fold_start < fold_end
	  call AL_execute(fold_start . ',' . fold_end . 'fold')
	endif
      endif
      call s:GoThread_Article(a:rstart)
    else
      " リストモード('l')
      let fold_start = s:GetLnum_Article(a:rmode =~ 'n' ? 1 : 2) - 1
      let fold_end = s:GetLnum_Article(s:GetThreadLastNumber() - a:rstart + (a:rmode =~ 'n' ? 1 : 2)) - 2
      if 0 < fold_start && fold_start < fold_end
	call AL_execute(fold_start . ',' . fold_end . 'fold')
      endif
      if !s:GoThread_Article(curarticle)
	normal! Gzb
      endif
    endif
  endif
endfunction

function! s:GetThreadLastNumber()
  return getbufvar(s:buftitle_thread, 'chalice_lastnum')
endfunction

"
" URLを外部ブラウザに開かせる
"
function! s:OpenURL(url)
  let retval = AL_open_url(a:url, g:chalice_exbrowser)
  call s:Redraw('force')
  if retval
    let msg =  "Open " . a:url . " with your browser"
    " 開いたURLをDiffChangeでハイライト表示
    execute 'match DiffChange /\V'.escape(a:url, '/').'/'
  else
    let msg = "Chalice:OpenURL is not implemented:" . a:url
  endif
  call s:EchoH('WarningMsg', msg)
  return retval
endfunction

function! s:GetAnchorCurline()
  " カーソル下のリンクを探し出す。なければ後方続いて前方へサーチ
  let mx = "\\%(\\%(".s:mx_anchor_num."\\)\\|\\%(".s:mx_anchor_url."\\)\\|\\%(".s:mx_anchor_www."\\)\\|\\%(".s:mx_anchor_from."\\)\\)"
  let str = AL_matchstr_cursor(mx)
  if str =~ s:mx_anchor_from
    let str = '>>'.AL_sscan(str, s:mx_anchor_from, '\1')
  endif
  return str
endfunction

"
" 書き込み内のリンクを処理
"
function! s:HandleJump(flag)
  "call s:GoBuf_Thread()

  let anchor = s:GetAnchorCurline()

  if anchor =~ s:mx_anchor_num
    let anchor = matchstr(anchor, s:mx_anchor_num)
    " スレの記事番号だった場合
    let num = AL_sscan(anchor, s:mx_anchor_num, '\2')
    if AL_hasflag(a:flag, '\cinternal')
      let oldsc = s:ScreenLine()
      let oldcur = line('.')
      let lnum = s:GoThread_Article(num)
      if lnum > 0
	call AL_execute(lnum . "foldopen!")
	" 参照元をヒストリに入れる
	call s:AddHistoryJump(oldsc, oldcur)
	" 参照先をヒストリに入れる
	call s:AddHistoryJump(s:ScreenLine(), line('.'))
      endif
    elseif AL_hasflag(a:flag, 'external')
      if b:host != '' && b:board != '' && b:dat != ''
	let num = substitute(anchor, s:mx_anchor_num, '\1', '')
	call s:OpenURL(s:GenerateThreadURL(b:host, b:board, b:dat, 'raw') .num.'n')
      endif
    endif
  elseif anchor =~ s:mx_anchor_url
    let url = substitute(matchstr(anchor, s:mx_anchor_url), '^ttp', 'http', '')
    return s:HandleURL(url, a:flag)
  elseif anchor =~ s:mx_anchor_www " http:// 無しURLの処理
    let url = 'http://' . matchstr(anchor, s:mx_anchor_www)
    return s:HandleURL(url, a:flag)
  else
    call s:EchoH('ErrorMsg', s:msg_error_cantjump)
  endif
endfunction

function! s:UpdateThreadInfo(host, board, dat)
  if g:chalice_threadinfo
    call s:GoBuf_ThreadList()
    if !exists('b:host') || !exists('b:board')
      return
    endif
    if b:host . b:board ==# a:host . a:board
      if a:dat != '' && search(a:dat, 'w')
	call s:FormatThreadInfoWithoutUndo(line('.'), line('.'), 'numcheck')
	call s:WriteFormatedCache_Subject(b:host, b:board)
      endif
    endif
    call s:GoBuf_Thread()
  endif
endfunction

function! s:DatDownload_2ch(host, remote, local_dat, flags)
  if 1 && has('byte_offset') && AL_hasflag(a:flags, 'continue') && getfsize(a:local_dat) > 0
    " DATの最後の1行が被るようにダウンロードするために、正確なアドレスを測定
    call AL_execute('1vsplit ++enc= ++bad=keep '.a:local_dat)
    let continue_at = line2byte('$') - 1
    let lastline = line('$')
    silent! bwipeout!
    " 仮ダウンロード実行
    let tmpfile = tempname()
    let retval = s:HttpDownload2(s:GenerateHostPathUri(a:host, a:remote), tmpfile, continue_at, a:local_dat)
    " ダウンロードの結果を検証
    if retval == 304
      call delete(tmpfile)
      return retval
    elseif retval == 206
      " 最後の1行が正しく被っているかチェックする
      "	  被っている→DAT更新
      "	  被ってない→ファイルを消して全取得へ
      call AL_execute('1vsplit ++enc= ++bad=keep '.a:local_dat)
      call AL_execute('$read ++enc= ++bad=keep '.tmpfile)
      call delete(tmpfile)
      if getline(lastline) ==# getline(lastline + 1)
	if line('$') > lastline + 1
	  call AL_execute(lastline." delete _")
	  silent! call AL_write();
	endif
	silent! bwipeout!
	return retval
      else
	call AL_execute(lastline." delete _")
	" DATにあぼーんが生じたと推測
	silent! bwipeout!
	call delete(a:local_dat)
      endif
    elseif retval == 416
      " DATにあぼーんが生じて短くなったと推測
      call delete(a:local_dat)
    endif
    " 仮ダウンロードに使ったファイルを削除
    if getfsize(tmpfile) >= 0
      call delete(tmpfile)
    endif
  endif
  return s:HttpDownload(a:host, a:remote, a:local_dat, a:flags)
endfunction

function! s:DatCatchup_2ch(host, board, dat, flags)
  let local = ''
  let prevsize = 0
  let oldarticle = 0
  " 基本戦略
  "   1. kako_dat_*があれば以下はスルー
  "   2. 無い場合にはdat_*の(差分)取得を試みる
  "   3. HTTP返答コードをチェックし、スレが存命なら以下はスルー
  "   4. 倉庫入りしていたら、kako_dat_*として全体を取得する
  "   5. 倉庫で見つからなければofflawを使用してみる
  "   6. 元のdat_*は放置
  let remote = s:GenerateRemoteDat(a:host, a:board, a:dat)
  let local_dat  = s:GenerateLocalDat(a:host, a:board, a:dat)
  let local_kako = s:GenerateLocalKako(a:host, a:board, a:dat)
  if filereadable(local_kako)
    " 手順1
    let local = local_kako
    let prevsize = getfsize(local_kako)
    let oldarticle = s:CountLines(local_kako)
  elseif filereadable(local_dat) && AL_hasflag(a:flags, 'noforce')
    " noforce指定時はネットアクセスを強制的に行なわない(意味が…変)
    let local = local_dat
    let prevsize = getfsize(local_dat)
    let oldarticle = s:CountLines(local_dat)
  else
    " スレッドの内容をダウンロード
    " ファイルの元のサイズを覚えておく
    if filereadable(local_dat)
      let prevsize = getfsize(local_dat)
      let oldarticle = s:CountLines(local_dat)
    endif
    " 手順2
    let didntexist = filereadable(local_dat) ? 0 : 1
    if didntexist
      call AL_mkdir(AL_basepath(local_dat))
    endif
    let result = s:DatDownload_2ch(a:host, remote, local_dat, a:flags)
    if result < 300 || result == 304 || result == 416
      " 手順3
      let local = local_dat
      " (必要ならば)スレ一覧のスレ情報を更新
      call s:UpdateThreadInfo(a:host, a:board, a:dat)
      " TODO: 416の時は2通りの可能性がある。あぼーん発生で本当に範囲外を指定
      " したのか、Apacheが新しい場合は差分が存在しない時。後者については古い
      " Apacheが200を返すのが間違っている。…本当はあぼーん検出に使いたかっ
      " たのだが、ちょっと無理。
    else
      " HTTPエラー時に、元々なかったファイルが出来ていたらゴミとして消去
      if didntexist && filereadable(local_dat)
	call delete(local_dat)
      endif
      " 手順4
      if !AL_hasflag(a:flags, 'ifmodified')
	let idstr = matchstr(a:dat, '\d\+')
	" 新スレッド(1000000000番以降)は格納場所が微妙に異なる
	let remote = strpart(idstr, 0, 3)
	if strlen(idstr) > 9
	  let remote = remote. strpart(idstr, 3, 1) .'/'. strpart(idstr, 0, 5)
	endif
	let remote = a:board.'/kako/'.remote.'/'.a:dat
	" 旧形式の過去ログサーバではログは圧縮されない
	if a:host.a:board !~ s:mx_servers_oldkako
	  let remote = remote.'.gz'
	  let local_kako = local_kako.'.gz'
	endif
	" 2度目の正直、ダウンロード
	call AL_mkdir(AL_basepath(local_kako))
	let result = s:HttpDownload(a:host, remote, local_kako, '')
	if result == 200 && filereadable(local_kako)
	  if local_kako =~ '\.gz$'
	    call s:Gunzip(local_kako)
	    let local_kako = substitute(local_kako, '\.gz$', '', '')
	  endif
	  let local = local_kako
	else
	  " HTML化待ちと推測される
	  call delete(local_kako)
	  " 手順5
	  " DAT落ち取得試行(要●認証)
	  let local_kako = s:GenerateLocalKako(a:host, a:board, a:dat)
	  if s:GetOfflawDat(a:host, a:board, a:dat, local_kako)
	    let local = local_kako
	  else
	    " offlawが取れなければ既存DAT
	    if filereadable(local_dat)
	      let local = local_dat
	    endif
	  endif
	endif " 手順4
      endif
    endif
  endif
  if local == '' && !AL_hasflag(a:flags, 'ifmodified')
    " エラー: スレ無しかHTML化待ち
    call AL_buffer_clear()
    call setline(1, 'Error: '.s:msg_error_nothread)
    call append('$', 'Error: '.s:msg_error_accesshere)
    call append('$', '')
    call append('$', '  '.s:GenerateThreadURL(a:host, a:board, a:dat))
    let b:host = a:host
    let b:board = a:board
    let b:dat = a:dat
    let b:title = s:prefix_thread
    let b:title_raw = ''
    normal! G^
    return 0
  endif

  let b:datutil_datsize = getfsize(local)
  " 更新が無い場合は即終了
  if AL_hasflag(a:flags, 'ifmodified') && prevsize >= b:datutil_datsize
    if local ==# local_dat
      return -1
    elseif local ==# local_kako
      return -3
    else
      return -2
    endif
  endif

  " 不本意なグローバル(バッファ)変数の使用
  let b:chalice_local = local
  return oldarticle + 1
endfunction

"
" スレッドの更新を行なう
"   ifmodifiedを指定した場合には、スレに更新がなかった際にスレは表示せずに-1
"   を返す。通常はスレの取得した分の先頭記事番号を返す。
"
function! s:UpdateThread(title, host, board, dat, flags)
  call s:GoBuf_Thread()
  if a:title != ''
    " スレのタイトルをバッファ名に設定
    let b:title = s:prefix_thread . a:title
    let b:title_raw = a:title
  endif
  " バッファ変数のhost,board,datを引数から作成(コピーだけどね)
  let host  = a:host  != '' ? a:host  : b:host
  let board = a:board != '' ? a:board : b:board
  let dat   = a:dat   != '' ? a:dat   : b:dat
  if host == '' || board == '' || dat == ''
    " TODO: 何かエラー処理が欲しい
    return -1
  endif

  " datファイルを更新する
  let newarticle = s:DatCatchup(host, board, dat, a:flags)
  " 使用したdatファイル名を取得する
  if exists('b:chalice_local')
    let local = b:chalice_local
    unlet! b:chalice_local
  else
    let local = ''
  endif

  " エラーの場合は終了
  if newarticle <= 0
    return newarticle
  endif

  " スレッドをバッファにロードして整形
  if a:host != '' || a:board != '' || a:dat != ''
    " 開くべきスレ(URL)が異なっているので、バッファ変数へ格納
    let b:host = host
    let b:board = board
    let b:dat = dat
    call s:IsBoardMoved(board, host)
  endif
  " 整形作業
  if AL_hasflag(a:flags, 'ignorecache')
    let title = s:FormatThread(local, 'ignorecache')
  else
    let title = s:FormatThread(local)
  endif
  " 常にdat内のタイトルを使用する
  let b:title = s:prefix_thread . title
  let b:title_raw = title

  if !s:GoThread_Article(newarticle)
    normal! Gzb
  endif
  call s:Redraw('force')
  " 'nostartofline'対策
  normal! 0
  " >>1プレビュー
  if g:chalice_preview && AL_hasflag(g:chalice_previewflags, '1')
    call s:OpenPreview('>>1')
  endif
  return newarticle
endfunction

"
" 板内容を更新する
"
function! s:UpdateBoard(title, host, board, flag)
  call s:CloseBookmark()
  " スレッドリストに移動して 1.板タイトル 2.ホスト 3.板IDを設定する
  call s:GoBuf_ThreadList()
  if a:title != ''
    let b:title = s:prefix_board . a:title
    let b:title_raw = a:title
  else
    let b:title = s:prefix_board . b:title_raw
  endif
  if a:host != ''
    let b:host = a:host
  endif
  if a:board != ''
    let b:board = a:board
  endif
  if b:host == '' || b:board == ''
    " TODO: 何かエラー処理が欲しい
    return
  endif

  " パスを生成してスレ一覧をダウンロード
  let local = s:GenerateLocalSubject(b:host, b:board)
  let remote = s:GenerateRemoteSubject(b:host, b:board)
  if s:fcachedir_enabled
    " DAT整形キャッシュ
    let cacheid = s:GetPath_FormatedCache_Subject(b:host, b:board)
    let fcachedfile = CACHEMAN_update(s:fcachedir, cacheid)
  endif
  let updated = 0
  let isexpired = localtime() - getftime(local) > g:chalice_reloadinterval_threadlist
  if AL_hasflag(a:flag, 'force') || !filereadable(local) || isexpired
    " 強制ネットアクセス→subject.txt読み込み
    call AL_mkdir(AL_basepath(local))
    call s:HttpDownload(b:host, remote, local, '')
    let updated = 1
    " フォーマットキャッシュを削除する
    if s:fcachedir_enabled
      call CACHEMAN_clear(s:fcachedir, cacheid)
    endif
  endif

  " スレ一覧を整形、もしくはキャッシュを読み込む
  let save_undolevels = &undolevels
  set undolevels=-1
  if s:fcachedir_enabled && filereadable(fcachedfile)
    " フォーマットキャッシュを読み込む
    call AL_buffer_clear()
    call AL_execute('read ++enc= ' . escape(fcachedfile, ' '))
    1 delete _
  else
    " スレ一覧をバッファにロードして整形
    call AL_buffer_clear()
    call AL_execute("read " . local)
    call AL_execute("g/^$/delete _") " 空行を削除
    " 整形
    call s:FormatBoard()
    " 整形済みキャッシュに保存する
    if s:fcachedir_enabled
      call AL_write(fcachedfile)
    endif
  endif
  " ローカルあぼーんのスレを削除
  if !AL_hasflag(a:flag, 'showabone')
    call AL_execute('silent! g/^x/delete _')
    call AL_del_lastsearch()
  endif
  " 先頭行へ移動
  silent! normal! gg0
  let &undolevels = save_undolevels

  if !updated
    call s:Redraw('force')
    call s:EchoH('WarningMsg', s:msg_warn_oldthreadlist)
  endif
endfunction

function! s:Reformat(target)
  if a:target ==# 'thread'
    let save_dont_download = s:dont_download
    let s:dont_download = 1
    call s:UpdateThread('', '', '', '', 'ignorecache,force')
    let s:dont_download = save_dont_download
  else
  endif
endfunction

" 指定された板が移転した可能性があるかをチェックする。
"   移転した可能性がある場合は1、なければ0を返す
function! s:IsBoardMoved(board, host)
  let bid = substitute(a:board, '^/', '', '')
  if !exists('s:movechecked_' . bid) || s:movechecked_{bid} == ""
    let curhost = ""
    " 板一覧から該当するURLを探し出して、ホスト部分を取得(curhost)する
    let oldbuf = bufname('%')
    call s:GoBuf_BoardList()
    let mx = '\mhttp://\([^/]*\)' . a:board . '/'
    let nr = search(mx, "w")
    if nr > 0
      let curhost = AL_sscan(getline(nr), mx, '\1')
    endif
    call AL_selectwindow(oldbuf)
    let s:movechecked_{bid} = curhost
  endif
  return a:host != s:movechecked_{bid} ? 1 : 0
endfunction

"}}}

"------------------------------------------------------------------------------
" FIXED FUNCTIONS {{{
" 暫定的に固まった関数群

if has('perl')
  function! s:CountLines_perl(target)
    perl << END_PERL
      my $file = VIM::Eval('a:target');
      open IN, $file;
      binmode IN;
      1 while <IN>;
      VIM::DoCommand('let lines = '.$.);
      close IN;
END_PERL
    return lines
  endfunction
endif

function! s:CountLines(target)
  if filereadable(a:target)
    if has('perl')
      let lines = s:CountLines_perl(a:target)
    else
      call AL_execute('vertical 1sview ++enc= '.a:target)
      let lines = line('$')
      silent! bwipeout!
    endif
  else
    let lines = 0
  endif
  return lines
endfunction

function! s:Gunzip(filename)
  if filereadable(a:filename) && a:filename =~ '\.gz$'
    call s:DoExternalCommand(s:cmd_gzip . ' -d -f ' . AL_quote(a:filename))
    if filereadable(a:filename)
      call rename(a:filename, substitute(a:filename, '\.gz$', '', ''))
    endif
  endif
endfunction

function! s:Redraw(opts)
  if g:chalice_noredraw
    return
  endif
  let cmd = 'redraw'
  if AL_hasflag(a:opts, 'force')
    "let cmd = cmd . '!'
  endif
  if AL_hasflag(a:opts, 'silent')
    let cmd = 'silent! ' . cmd
  endif
  execute cmd
endfunction

" スクリーンに表示されている先頭の行番号を取得する
function! s:ScreenLine()
  let wline = winline() - 1
  silent! normal! H
  let retval = line('.')
  while wline > 0
    call AL_execute('normal! gj')
    let wline = wline - 1
  endwhile
  return retval
endfunction

function! s:ScreenLineJump(scline, curline)
  " 大体の位置までジャンプ
  let curline = a:curline > 0 ? a:curline - 1 : 0
  call AL_execute('normal! ' . (a:scline + curline) . 'G')
  " 目的位置との差を計測
  let offset = a:scline - s:ScreenLine()
  if offset < 0
    call AL_execute('normal! ' . (-offset) . "\<C-Y>")
  elseif offset > 0
    call AL_execute('normal! ' . offset . "\<C-E>")
  endif
  " スクリーン内でのカーソル位置を設定する
  call AL_execute('normal! H')
  while curline > 0
    call AL_execute('normal! gj')
    let curline = curline - 1
  endwhile
endfunction

"
" ハイライトを指定したメッセージ表示
"
function! s:EchoH(hlname, msgstr)
  call AL_echo(a:msgstr, a:hlname)
endfunction

"
" Chalice終了
"
function! s:ChaliceClose(flag)
  if !s:opened
    return
  endif
  " 必要ならば終了の意思を確認する
  if !g:chalice_noquery_quit && !AL_hasflag(a:flag, 'all')
    if confirm(s:msg_confirm_quit, s:choice_yn, 2, "Question") == 2
      return
    endif
  endif

  " 書き込みバッファを強制終了する. 
  " 仕様変更: 書き込めるバッファがあっても無視する
  if s:opened_write
    call s:GoBuf_Write()
    silent! close!
  endif

  " ブックマークが開かれていた場合閉じることで保存する
  if s:opened_bookmark
    call s:CloseBookmark()
  endif

  silent! call s:AutocmdUninstall()
  silent! call s:CommandUnregister()

  " 稼働時間を計算
  let timestr = ''
  if 1
    let wasted = localtime() - s:start_time
    let timestr = s:label_wastetime.' '.s:StringFormatTime(wasted)
    " 累積稼働時間を保存
    if exists('s:wasted_time')
      let s:wasted_time = s:wasted_time + wasted
      let waste_file = s:dir_cache.'WASTED'
      call AL_execute('1vsplit '.waste_file)
      call AL_buffer_clear()
      call setline(1, s:wasted_time)
      call AL_write()
      silent! bwipeout!
      let timestr = timestr.', '.s:label_wastetime_sum.' '.s:StringFormatTime(s:wasted_time)
    endif
  endif

  if AL_hasflag(a:flag, 'all')
    execute "qall!"
  endif
  let s:opened = 0

  " ジャンプ履歴をクリア
  call s:JumplistClear()

  " 認証データをクリア
  call s:ResetSession()

  " 変更したグローバルオプションの復帰
  let &charconvert = s:charconvert
  if g:chalice_columns > 0
    let &columns = s:columns
  endif
  let &equalalways = s:equalalways
  let &foldcolumn = s:foldcolumn
  let &gdefault = s:gdefault
  let &ignorecase = s:ignorecase
  let &lazyredraw = s:lazyredraw
  let &more = s:more
  let &wrapscan = s:wrapscan
  let &winwidth = s:winwidth
  let &winheight = s:winheight
  let &scrolloff = s:scrolloff
  let &statusline = s:statusline
  let &titlestring = s:titlestring

  " Chalice関連のバッファ総てをwipeoutする。
  call AL_execute("bwipeout " . s:buftitle_write)
  silent! new
  silent! only!
  call s:Redraw('silent')

  " 終了メッセージ
  let extramsg = timestr == '' ? '' : ' ('.timestr.')'
  call s:EchoH('WarningMsg', s:msg_chalice_quit.extramsg)
endfunction

function! s:CharConvert()
  if v:charconvert_from == 'cp932' && v:charconvert_to == 'utf-8' && s:cmd_conv != ''
    call s:DoExternalCommand(s:cmd_conv.' '.v:fname_in.'>'.v:fname_out)
    return 0
  elseif v:charconvert_from == 'cp932' && v:charconvert_to == 'euc-jp' && s:cmd_conv != ''
    call s:DoExternalCommand(s:cmd_conv .'<'. v:fname_in .'>'. v:fname_out)
    return 0
  else
    return 1
  endif
endfunction

if s:debug
  function! ChaliceDebug()
    echo "s:sid=".s:sid
    echo "s:cmd_curl=".s:cmd_curl
    echo "s:cmd_conv=".s:cmd_conv
    echo "s:cmd_gzip=".s:cmd_gzip
    if exists('s:dir_cache')
      echo "s:dir_cache=".s:dir_cache
    endif
    echo "g:chalice_bookmark=".g:chalice_bookmark
  endfunction
endif

"
" 動作環境をチェック
"
function! s:CheckEnvironment()
  " MacOSXでは必要ならば/usr/local/binをパスに追加する
  if has('macunix') && $PATH =~# '\m\%(^\|:\)/usr/local/bin/\?\%(:\|$\)' && isdirectory('/usr/local/bin')
    let $PATH = '/usr/local/bin:'.$PATH
  endif

  " cURLのパスを取得
  let s:cmd_curl = AL_hascmd('curl')

  " 非CP932環境ではコンバータを取得する必要がある。
  if &encoding !=# 'cp932' && &encoding !=# 'utf-8'
    if AL_hascmd('qkc') != ''
      let s:cmd_conv = 'qkc -e -u'
    elseif AL_hascmd('nkf') != ''
      let s:cmd_conv = 'nkf -e -x'
    else
      call s:EchoH('ErrorMsg', s:msg_error_noconv)
      return 0
    endif
  elseif &encoding == 'utf-8'
    let s:cmd_conv = 'iconv -c -f cp932 -t utf-8'
  else
    let s:cmd_conv = ''
  endif

  " gzipを探す
  let s:cmd_gzip = AL_hascmd('gzip')
  if s:cmd_gzip == ''
    call s:EchoH('ErrorMsg', s:msg_error_nogzip)
    return 0
  endif

  " ディレクトリ情報構築
  if exists('g:chalice_cachedir') && isdirectory(g:chalice_cachedir)
    let s:dir_cache = substitute(g:chalice_cachedir, '[^\/]$', '&/', '')
  else
    let s:dir_cache = g:chalice_basedir . '/cache/'
  endif
  " cookieファイル設定
  if !exists('g:chalice_cookies')
    let g:chalice_cookies = s:dir_cache . 'cookie'
  endif
  " ブックマーク情報構築
  if g:chalice_bookmark == ''
    let g:chalice_bookmark = g:chalice_basedir . '/' . s:bookmark_filename
  endif
  " 書き込みログファイル情報構築
  let s:chalice_writelogfile = s:dir_cache . 'write.log'

  " キャッシュディレクトリの保証
  if !isdirectory(s:dir_cache)
    call AL_mkdir(s:dir_cache)
    if !isdirectory(s:dir_cache)
      call s:Redraw('force')
      call s:EchoH('ErrorMsg', s:msg_error_nocachedir)
      return 0
    endif
  endif

  " 旧datファイルがなければDATDIRを作成する
  let datfiles = glob(s:dir_cache.'dat_*')
  let datd = s:GetPath_Datdir()
  if AL_countlines(datfiles) == 0 && !isdirectory(datd)
    call AL_mkdir(s:GetPath_Datdir())
  endif
  " DATDIRが有効か調べる
  let s:datdir_enabled = isdirectory(datd) && filewritable(datd)

  " DATDIRが有効ならばフォーマットキャッシュを有効にする
  let s:fcachedir_enabled = 0
  if s:datdir_enabled
    let s:fcachedir = s:dir_cache.'format.d'
    if AL_mkdir(s:fcachedir)
      let s:fcachedir_enabled = 1
      call CACHEMAN_flush(s:fcachedir, g:chalice_formatedcache_expire)
    endif
  endif

  return 1
endfunction

"
" Chaliceヘルプをインストール
"
function! s:HelpInstall(scriptdir)
  " 以前、この関数はpluginの読み込み時に実行されることがあったので、AL_*が使
  " えなかった。現在はそのようなことはなくなったが、その名残でAL_*は使用して
  " いない。

  let basedir = substitute(a:scriptdir, 'plugin$', 'doc', '')
  if has('unix')
    let docdir = $HOME . '/.vim/doc'
    if !isdirectory(docdir)
      call system('mkdir -p ' . docdir)
    endif
  else
    let docdir = basedir
  endif
  let helporig = basedir . '/chalice.txt.cp932'
  let helpfile = docdir . '/chalice.txt'
  let tagsfile = docdir . '/tags'

  " 文字コードのコンバート
  if !filereadable(helpfile) || (filereadable(helporig) && getftime(helporig) > getftime(helpfile))
    silent execute "sview " . helporig
    set fileencoding=japan fileformat=unix
    call AL_write(helpfile)
    silent! bwipeout!
  endif

  " tagsの更新
  if !filereadable(tagsfile) || getftime(helpfile) > getftime(tagsfile)
    silent execute "helptags " . docdir
  endif
endfunction

"
" Chalice開始
"
function! s:ChaliceOpen()
  if s:opened
    return
  endif

  " 動作環境のチェック
  if !s:CheckEnvironment()
    return
  endif

  call s:AutocmdInstall()

  " (必要ならば)ヘルプファイルをインストールする
  if !AL_hasflag(g:chalice_startupflags, 'nohelp')
    silent! call s:HelpInstall(s:scriptdir)
  endif

  " 変更するグローバルオプションの保存
  let s:opened = 1
  let s:charconvert = &charconvert
  let s:columns = &columns
  let s:equalalways = &equalalways
  let s:foldcolumn = &foldcolumn
  let s:gdefault = &gdefault
  let s:ignorecase = &ignorecase
  let s:lazyredraw = &lazyredraw
  let s:more = &more
  let s:wrapscan = &wrapscan
  let s:winwidth = &winwidth
  let s:winheight = &winheight
  let s:scrolloff = &scrolloff
  let s:statusline = &statusline
  let s:titlestring = &titlestring

  " グローバルオプションを変更
  if s:cmd_conv != ''
    let &charconvert = s:sid . 'CharConvert()'
  endif
  if g:chalice_columns > 0
    let &columns = g:chalice_columns
  endif
  " set equalalwaysした瞬間に、高さ調整が行なわれてしまうのでpluginを通じて
  " noequalalwaysにした。
  set noequalalways
  set foldcolumn=0
  set nogdefault
  set ignorecase
  set lazyredraw
  set nomore
  set wrapscan
  set winheight=8
  set winwidth=15
  set scrolloff=0
  let &statusline = '%<%{' . s:sid . 'GetBufferTitle()}%='.g:chalice_statusline.'%{'.s:sid.'GetDatStatus()} %{'.s:sid.'GetStatus_ThreadNum()}'
  " let &titlestring = s:label_vimtitle " UpdateTitleString()参照

  " foldmarksの初期化
  let mx = '^\(.\)\(.\)$'
  let foldmarks = '■□'
  if exists('g:chalice_foldmarks') && g:chalice_foldmarks =~ mx
    let foldmarks = g:chalice_foldmarks
  endif
  let s:foldmark_0 = AL_sscan(foldmarks, mx, '\1')
  let s:foldmark_1 = AL_sscan(foldmarks, mx, '\2')

  " 起動最終準備
  call s:CommandRegister()
  call s:OpenAllChaliceBuffers()
  call s:AdjustWindowSizeDefault()

  " あらゆるネットアクセスの前にオフラインモードフラグを設定
  let s:dont_download = AL_hasflag(g:chalice_startupflags, 'offline') ? 1 : 0

  call s:UpdateBoardList(0)

  " バージョンチェック
  if 1 && !AL_hasflag(g:chalice_startupflags, 'novercheck')
    let ver_cache = s:dir_cache.'VERSION'
    if 0 < s:CheckNewVersion(s:verchk_verurl, s:verchk_path, ver_cache, s:verchk_interval)
      call s:GoBuf_Thread()
      call AL_buffer_clear()
      call setline(1, 'Info: '.s:msg_error_newversion)
      call append('$', 'Info: '.s:msg_error_doupdate)
      call append('$', 'Info: '.s:msg_error_accesshere)
      call append('$', '')
      call append('$', '  '.s:verchk_url_1)
      call append('$', '  '.s:verchk_url_2)
      let b:title = s:prefix_thread
      let b:title_raw = ''
      normal! G^
    endif
  endif

  " 指定された場合は栞を開いておく
  if AL_hasflag(g:chalice_startupflags, 'bookmark')
    silent! call s:OpenBookmark()
  endif

  " 起動AA表示
  let aaflag = AL_getflagparam(g:chalice_startupflags, 'aa')
  if 1 && aaflag !=# 'no'
    let startup = g:chalice_basedir.'/startup.aa'
    if !filereadable(startup)
      let startup = s:scriptdir.'/../startup.aa'
    endif
    call s:StartupAA(startup, aaflag ==# 'noanime' ? -1 : g:chalice_animewait)
  endif

  " 累積稼動時間を表示
  if 1
    let s:start_time = localtime()
    let waste_file = s:dir_cache.'WASTED'
    if filereadable(waste_file)
      call AL_execute('vertical 1sview ++enc= '.waste_file)
      setlocal bufhidden=delete
      let s:wasted_time = getline(1) + 0
      silent! bwipeout!
    else
      let s:wasted_time = 0
    endif
    call s:GoBuf_Thread()
    call append('$', 'Info: '.s:label_wastetime_sum.' '.s:StringFormatTime(s:wasted_time))
    call append('$', 'Info: '.s:msg_warn_dontusetoomuch)
  endif

  " カーソルを初期位置へ移動する
  if AL_hasflag(g:chalice_startupflags, 'bookmark')
    call s:GoBuf_ThreadList()
  else
    call s:GoBuf_BoardList()
  endif

  " 開始メッセージ表示
  call s:UpdateTitleString()
  call s:Redraw('silent')
  call s:EchoH('WarningMsg', s:msg_chalice_start)
endfunction

" タイトル文字列を設定する。現在のChaliceの状態に応じた文字列になる。
function! s:UpdateTitleString()
  if exists('g:chalice_titlestring') && g:chalice_titlestring != ''
    let str = g:chalice_titlestring
  else
    let str = s:label_vimtitle
  endif
  if s:dont_download
    let str = str . ' ' . s:label_offlinemode
  endif
  let &titlestring = str
endfunction

function! s:ToggleNetlineState()
  " オフラインモードをトグルする
  let s:dont_download = s:dont_download ? 0 : 1
  call s:UpdateTitleString()
  call s:EchoH('WarningMsg', s:dont_download ? s:msg_warn_netline_off : s:msg_warn_netline_on)
endfunction

"
" 外部コマンドを実行
"   verboseレベルに応じた方法で実行する。
"
function! s:DoExternalCommand(cmd)
  let extcmd = a:cmd
  if has('win32') && &shell =~ '\ccmd'
    "let extcmd = '"' . extcmd . '"'
    " 何故この処理が必要なのかわからない(思い出せない)。引用符内に&などの特
    " 殊文字があると正しく解釈されない問題があり、それを回避するために暫定的
    " に外すことにする。よってここは意図的に何もしないブロックになる。
  endif
  if g:chalice_verbose < 1
    return system(extcmd)
  elseif g:chalice_verbose < 2
    call AL_execute(':!' . escape(extcmd, '%#'))
  else
    execute ':!' . escape(extcmd, '%#')
  endif
endfunction

"
" 現在のカーソル行のスレッドを開く
"
function! s:OpenThread(...)
  let flag = (a:0 > 0) ? a:1 : 'internal'
  if AL_hasflag(flag, 'firstline')
    " 外部ブラウザにはfirstlineだとかそうじゃないという概念がないから、
    " firstline指定時は暗にinternalとして扱って良い。
    let flag = flag . ',internal'
  endif

  let curline = getline('.')
  let mx2 = '\(http://'.g:AL_pattern_class_url.'\+\)'

  if curline =~ s:mx_thread_dat
    let host = b:host
    let board = b:board
    let title = substitute(curline, s:mx_thread_dat, '\1', '')
    let dat = substitute(curline, s:mx_thread_dat, '\3', '')
    let url = s:GenerateThreadURL(host, board, dat, flag)
  elseif curline =~ mx2
    let url = matchstr(curline, mx2)
  else
    " foldの開閉をトグル
    silent! normal! 0za
    return
  endif

  " URLは抽出できたが[板]がある場合
  if AL_hasflag(flag, 'bookmark') && curline =~ '^\s*'.s:label_board_escaped
    return s:OpenBoard()
  endif

  let retval =  s:HandleURL(url, flag . ',noaddhist')
  if AL_hasflag(flag, 'firstline')
    normal! gg
  endif

  if retval == 1 && !AL_hasflag(flag, 'external')
    call s:AddHistoryJump(s:ScreenLine(), line('.'))
  endif
  " 1のみ表示時にスレ一覧に留まる
  if AL_hasflag(flag, 'firstarticle') && AL_hasflag(g:chalice_previewflags, 'stay')
    call s:GoBuf_ThreadList()
  endif
endfunction

"
" 現在のカーソル行にあるURLを板として開く
"
function! s:OpenBoard(...)
  let board = AL_chomp(getline('.'))
  let mx = '\m^\(.\{-\}\)\s\+\(http://\S*$\)'
  if board !~ mx
    " foldの開閉をトグル
    normal! 0za
    return 0
  endif
  " タイトルとURLを分離抽出
  let title = AL_sscan(board, mx, '\1')
  let title = substitute(title, '^\s*\('.s:label_board_escaped.'\)\?\s*', '', '')
  let url   = AL_sscan(board, mx, '\2')

  let host = AL_sscan(url, s:mx_url_parse, '\1')
  let path = AL_sscan(url, s:mx_url_parse, '\2')
  let path = substitute(path, '/$', '', '')
  "echo "host=".host." path=".path

  if path =~ '/'
    if host =~ s:mx_servers_shitaraba && path =~ '^bbs/'
      let board = substitute(path, '^bbs', '', '')
    else
      " NOTE: 旧仕様対応のためのワークアラウンド
      let mx = '\m^\(.*\)\(/[^/]\+\)$'
      let host  = host.'/'.AL_sscan(path, mx, '\1')
      let board = AL_sscan(path, mx, '\2')
    endif
  else
    let board = '/'.path
  endif
  "echo "title=" . title . " host=" . host . " board=" . board

  if a:0 > 0 && AL_hasflag(a:1, 'external')
    return s:OpenURL(url)
  endif
  if bufname('%') ==# s:buftitle_boardlist
    call s:HighlightWholeline(line('.'), 'DiffChange')
  endif
  if board ==# '' || board ==# '/'
    " NOTE: 板以外のURLを開くための暫定ワークアラウンドなので、もっと良い戦
    " 略に差し替えた方が良い。
    call s:HandleURL(url, 'noboardcheck')
  else
    call s:UpdateBoard(title, host, board, '')
  endif
  return 1
endfunction

"
" 与えられたURLを2chかどうか判断しる!!
"
function! s:ParseURL_is2ch(url)
  " 各種URLパターン
  let mx = '^' . s:mx_url_2channel
  let mx_old = '^\(http://..\{-}/test/read.cgi\)?bbs=\([^&]\+\)&\%(amp\)\?key=\(\d\+\)\(\S\+\)\?'
  let mx_kako = '^\(http://..\{-}\)/\([^/]\+\)/kako/\%(\d\+/\)\{1,2}\(\d\+\)\.\%(html\|dat\%(\.gz\)\?\)'

  " 古い形式のURLは、現在の形式へ正規化する(→url)
  let url = ''
  if a:url =~ mx
    let url = a:url
  elseif a:url =~ mx_old
    let url = substitute(a:url, mx_old, '\=submatch(1)."/".submatch(2)."/".submatch(3).s:ConvertOldRange(submatch(4))', '')
  elseif a:url =~ mx_kako
    let url = AL_sscan(a:url, mx_kako, '\1/test/read.cgi/\2/\3')
  endif

  " 2ch-URLの各構成要素へ分解する
  if url == ''
    return 0
  endif
  let s:parseurl_host = AL_sscan(url, mx, '\1')
  let s:parseurl_board = AL_sscan(url, mx, '\2')
  let s:parseurl_dat = AL_sscan(url, mx, '\3') . '.dat'

  " 表示範囲を解釈
  " 参考資料: http://pc.2ch.net/test/read.cgi/tech/1002820903/
  let range = AL_sscan(url, mx, '\4')
  let mx_range = '[-0-9]\+'
  let s:parseurl_range_mode = ''
  let s:parseurl_range_start = ''
  let s:parseurl_range_end = ''
  let str_range = matchstr(range, mx_range)
  if str_range != ''
    " 範囲表記を走査
    let mx_range2 = '\(\d*\)-\(\d*\)'
    if str_range =~ mx_range2
      let s:parseurl_range_start = AL_sscan(str_range, mx_range2, '\1')
      let s:parseurl_range_end	 = AL_sscan(str_range, mx_range2, '\2')
      if s:parseurl_range_start == ''
	let s:parseurl_range_start = 1
      endif
      if s:parseurl_range_end == ''
	let s:parseurl_range_end = '$'
      endif
    else
      " 数字しかあり得ないので可
      let s:parseurl_range_start = str_range
      let s:parseurl_range_end = str_range
    endif
    let s:parseurl_range_mode = s:parseurl_range_mode . 'r'
    " 表示フラグ(n/l)の判定
    if range =~ 'n'
      let s:parseurl_range_mode = s:parseurl_range_mode . 'n'
    endif
    if range =~ 'l'
      let s:parseurl_range_mode = s:parseurl_range_mode . 'l'
    endif
  endif

  return 1
endfunction

function! s:ConvertOldRange(range_old)
  " 旧形式の2chのURLから、範囲指定を取り出す
  if a:range_old == ''
    return ''
  endif

  let mx_range_last = '&\%(amp\)\?ls=\(\d\+\)'
  let mx_range_part = '&\%(amp\)\?st=\(\d\+\)\%(&\%(amp\)\?to=\(\d\+\)\)\?'
  let mx_range_nofirst = '&\%(amp\)\?nofirst=true'

  let range = ''
  if a:range_old =~ mx_range_last
    let range = AL_sscan(a:range_old, mx_range_last, 'l\1')
  elseif a:range_old =~ mx_range_part
    let range = AL_sscan(a:range_old, mx_range_part, '\1-\2')
  endif
  if a:range_old =~ mx_range_nofirst
    let range = range . 'n'
  endif
  return '/'.range
endfunction

"
" 任意のバッファタイトルをstatuslineで表示するためのラッパー
"
function! s:GetBufferTitle()
  if !exists('b:title')
    let str = bufname('%')
  else
    let str = b:title
  endif
  return substitute(str, "[\<NL>]\\+", '', 'g')
endfunction

"
" ある行が何番目のスレか判定する
"
function! s:GetArticleNum(lnum)
  let lnum = a:lnum + 0 > 0 ? a:lnum : line(a:lnum)
  while getline(lnum) =~ '^-'
    let lnum = lnum + 1
  endwhile
  while lnum > 0
    let retval = matchstr(getline(lnum), '^\d\+') + 0
    if retval > 0
      return retval
    endif
    let lnum = lnum - 1
  endwhile
  return 0
endfunction

"
" スレの位置を表示する
"
function! s:GetStatus_ThreadNum()
  if exists('b:chalice_lastnum')
    let cur = s:GetArticleNum('.')
    return cur.'/'.b:chalice_lastnum
  else
    return line('.').'/'.line('$')
  endif
endfunction

"
" dat, kakoの有無を表示する
"
function! s:GetDatStatus()
  if exists('b:host') && exists('b:board') && exists('b:dat')
    if b:host != '' && b:board != '' && b:dat != ''
      if filereadable(s:GenerateLocalDat(b:host, b:board, b:dat))
	let dat = 'D'
      else
	let dat = '-'
      endif
      if filereadable(s:GenerateLocalKako(b:host, b:board, b:dat))
	let kako = 'K'
      else
	let kako = '-'
      endif
      let bid = substitute(b:board, '^/', '', '')
      if exists('s:movechecked_' . bid) && s:movechecked_{bid} != b:host
	let moved = 'M'
      else
	let moved = '-'
      endif
      return "[" . dat . kako . moved . "]"
    else
      return '[---]'
    endif
  else
    return ''
  endif
endfunction

" s:OpenAllChaliceBuffers
"   Chalice用のバッファを一通り全て開いてしまう
function! s:OpenAllChaliceBuffers()
  " スレッド用バッファを開く
  call AL_execute("edit! " . s:buftitle_thread)
  setlocal filetype=2ch_thread
  let b:title = s:prefix_thread

  " 板一覧用バッファを開く
  call AL_execute("topleft 15vnew! " . s:buftitle_boardlist)
  setlocal filetype=2ch_boardlist
  let b:title = s:label_boardlist

  " スレッド一覧用バッファ(==板)を開く
  call s:GoBuf_Thread()
  call AL_execute("leftabove 10new! " . s:buftitle_threadlist)
  setlocal filetype=2ch_threadlist
  let b:title = s:prefix_board
endfunction

function! s:HttpDownload2(uri, filename, continueat, timebase)
  if s:dont_download
    return 200
  endif
  " メッセージ表示
  call s:Redraw('force')
  call s:EchoH('WarningMsg', s:msg_wait_download)
  " 起動オプションの構築→cURLの実行
  let opts = g:chalice_curl_options
  " 生dat読み込み制限に対応
  let opts = opts.' -A '.AL_quote(s:GetUserAgent())
  if a:continueat > 0
    let opts = opts.' -C '.a:continueat
  endif
  let tmp_head = tempname()
  let opts = opts.' -D '.AL_quote(tmp_head)
  let opts = opts.' -o '.AL_quote(a:filename)
  if filereadable(a:timebase)
    let opts = opts.' -z '.AL_quote(a:timebase)
  endif
  let opts = opts.' '.AL_quote(a:uri)
  " ダウンロード実行
  let cmd = s:cmd_curl.' '.opts
  if s:debug
    let s:last_downloadcommand = cmd
  endif
  call s:DoExternalCommand(cmd)
  " ヘッダー情報取得→テンポラリファイル削除
  call AL_execute('1vsplit ' . tmp_head)
  let retval = AL_sscan(getline(1), '^HTTP\S*\s\+\(\d\+\).*$', '\1') + 0
  silent! bwipeout!
  call delete(tmp_head)
  " 画面再描画→関数終了
  call s:Redraw('force')
  return retval
endfunction

" ホスト名とパスからURIを生成する
function! s:GenerateHostPathUri(host, path)
  return 'http://'.a:host.'/'.substitute(a:path, '^/\+', '', '')
endfunction

"
" HTTPダウンロードの関数:
"
" Param:
"   host	ホスト名、もしくはURL
"   remote	リモート名。hostにURLが指定された場合は無視される
"   flag	'', 'noagent', 'continue', 'flag' またはこれらの組み合わせ
" Flags:
"   continue	継続ダウンロードを行なう
"   head	ヘッダー情報だけを取得する
"
function! s:HttpDownload(host, remotepath, localpath, flag)
  " オフラインのチェック
  if s:dont_download
    return
  endif
  call s:Redraw('force')
  call s:EchoH('WarningMsg', s:msg_wait_download)

  let local = a:localpath
  if a:host =~ s:mx_anchor_url
    let url = a:host
  else
    let url = s:GenerateHostPathUri(a:host, a:remotepath)
  endif
  let continued = 0
  let compressed = 0

  " 起動オプションの構築→cURLの実行
  let opts = g:chalice_curl_options

  " 生dat読み込み制限に対応
  if s:user_agent_enable && !AL_hasflag(a:flag, 'noagent')
    let opts = opts . ' -A ' . AL_quote(s:GetUserAgent())
  endif

  " ファイルに更新がある時だけ、実際の転送を試みる(If-Modified-Since)
  "if filereadable(local) && (AL_hasflag(a:flag, 'continue') || !AL_hasflag(a:flag, 'force'))
  "  let opts = opts . ' -z ' . AL_quote(local)
  "endif
  " MEMO: 本当に要るのか?

  " 継続ロードのオプション設定
  if AL_hasflag(a:flag, 'continue')
    let size = getfsize(local)
    if size > 0
      let continued = 1
      let opts = opts . ' -C ' . size
    endif
  endif

  " 圧縮ロードのオプション設定
  if !continued && g:chalice_gzip && s:cmd_gzip != '' && a:remotepath !~ '\.gz$'
    let compressed = 1
    let local = local . '.gz'
    let opts = opts . ' -H Accept-Encoding:gzip,deflate'
  endif

  " ヘッダー情報を取得するためテンポラリファイルを使用
  let tmp_head = tempname()
  if AL_hasflag(a:flag, 'head')
    " ヘッダー情報だけを取得する (-I オプション)
    let opts = opts . ' -I'
    let opts = opts . ' -o ' . AL_quote(tmp_head)
  else
    let opts = opts . ' -D ' . AL_quote(tmp_head)
    let opts = opts . ' -o ' . AL_quote(local)
  endif
  let opts = opts . ' ' . AL_quote(url)

  " ダウンロード実行
  let cmd = s:cmd_curl.' '.opts
  if s:debug
    let s:last_downloadcommand = cmd
  endif
  call s:DoExternalCommand(cmd)

  " ヘッダー情報取得→テンポラリファイル削除
  call AL_execute('1vsplit ' . tmp_head)
  let retval = AL_sscan(getline(1), '^HTTP\S*\s\+\(\d\+\).*$', '\1') + 0
  if compressed
    if search('^\ccontent-encoding:.*gzip', 'w')
      call s:Gunzip(local)
    else
      call rename(local, substitute(local, '\.gz$', '', ''))
    endif
  endif
  silent! bwipeout!
  call delete(tmp_head)

  call s:Redraw('force')
  return retval
endfunction

"
" 板一覧のバッファを更新
"
function! s:UpdateBoardList(force)
  call s:GoBuf_BoardList()
  let b:title = s:label_boardlist

  " ネットワークから板一覧のデータを取得する
  let local_menu = s:dir_cache . s:menu_localpath
  if s:fcachedir_enabled
    " 板一覧整形キャッシュ
    let cacheid = s:menu_localpath.'.'.&encoding.'.txt'
    let fcachedfile = CACHEMAN_update(s:fcachedir, cacheid)
  endif
  " 板一覧の読み込み
  if a:force || !filereadable(local_menu) || localtime() - getftime(local_menu) > g:chalice_reloadinterval_boardlist
    let mx = '^http://\([^/]\+\)/\(.*\)$'
    if exists('g:chalice_menu_url') && g:chalice_menu_url =~ mx
      " 外部からメニューのURLを与える
      let menu_host = AL_sscan(g:chalice_menu_url, mx, '\1')
      let menu_remotepath = AL_sscan(g:chalice_menu_url, mx, '\2')
    else
      " 2chのフレームを読み込んでframedataに格納
      let local_frame = tempname()
      call s:HttpDownload(s:host, s:remote, local_frame, '')
      call AL_execute('%delete _')
      call AL_execute('read ' . local_frame)
      call AL_execute("%join")
      let framedata = getline('.')
      call AL_execute('%delete _')
      call delete(local_frame)

      " frameタグの解釈
      let framedata = AL_sscan(framedata, '^.*\(frame\>[^>]*name="\?menu"\?[^>]*\)>.*$', '\1')
      let mx = '^.*src="\?http://\([^/]\+\)/\([^" ]*\)"\?.*$'
      let menu_host = AL_sscan(framedata, mx, '\1')
      let menu_remotepath = AL_sscan(framedata, mx, '\2')
    endif

    " 最低限の保証
    if menu_host == ''
      let menu_host = s:menu_host
      let menu_remotepath = s:menu_remotepath
    endif

    " メニューファイルの読込
    call s:HttpDownload(menu_host, menu_remotepath, local_menu, '')

    " フォーマットキャッシュを削除する
    if s:fcachedir_enabled
      call CACHEMAN_clear(s:fcachedir, cacheid)
    endif
  endif

  " 板一覧を整形もしくはキャッシュを読み込む
  let save_undolevels = &undolevels
  set undolevels=-1
  if s:fcachedir_enabled && filereadable(fcachedfile)
    " フォーマットキャッシュを読み込む
    call AL_buffer_clear()
    call AL_execute('read ++enc= ' . escape(fcachedfile, ' '))
    silent! normal! gg"_dd0
  else
    " 板一覧の整形
    call AL_buffer_clear()
    call AL_execute('read ' . local_menu)
    " 改行<BR>を本当の改行に
    call AL_execute("%s/\\c<br>/\r/g")
    " カテゴリと板へのリンク以外を消去
    call AL_execute('%g!/^\c<[AB]\>/delete _')
    " カテゴリを整形
    call AL_execute('%s/^<B>\([^<]*\)<\/B>/' . Chalice_foldmark(0) . '\1/')
    " 板名を整形
    call AL_execute('%s/^<A HREF=\([^ ]*\/\)[^/>]*>\([^<]*\)<\/A>/ \2\t\t\t\t\1')
    " 「2ch総合案内」を削除…本当はちゃんとチェックしなきゃダメだけど。
    normal! gg
    call AL_execute("1,/^" . Chalice_foldmark(0) . "/-1delete _")
    if s:fcachedir_enabled
      call AL_write(fcachedfile)
    endif
  endif
  " ユーザ定義の板一覧の追加
  let userboardlist = g:chalice_basedir.'/boardlist.txt'
  if filereadable(userboardlist)
    execute '0read '.userboardlist
  endif
  let &undolevels = save_undolevels

  " folding作成
  if 1
    silent! normal! gg
    while 1
      call AL_execute('.,/\n\(' . Chalice_foldmark(0) . '\)\@=\|\%$/fold')
      let prev = line('.')
      silent! normal! j
      if prev == line('.')
	break
      endif
    endwhile
  endif

  silent normal! gg
  call AL_del_lastsearch()
endfunction

"
" Chalice起動確認
"
function! ChaliceIsRunning()
  return s:opened
endfunction

"}}}

"------------------------------------------------------------------------------
" MOVE AROUND BUFFER {{{
" バッファ移動用関数

function! s:GetLnum_Article(num)
  " 指定した番号の記事の先頭行番号を取得。カーソルは移動しない。
  call s:GoBuf_Thread()
  let oldline = line('.')
  let oldcol = col('.')
  let anumstr = ''.a:num
  if anumstr ==# 'next'
    let lnum = s:GetLnum_Article(s:GetArticleNum('.') + 1)
  elseif anumstr ==# 'prev'
    let lnum = s:GetLnum_Article('current')
    if lnum >= line('.')
      let lnum = s:GetLnum_Article(s:GetArticleNum('.') - 1)
    endif
    " 1(最初の記事)を超えた時はヘッダ部分を表示
    if lnum == 0
      let lnum = 1
    endif
  elseif anumstr ==# 'current'
    let lnum = s:GetLnum_Article(s:GetArticleNum('.'))
  else
    " 入力する方法もあり
    if anumstr ==# 'input'
      let target = inputdialog(s:msg_prompt_articlenumber)
    else
      let target = a:num + 0
    endif
    " 番号から記事の位置を調べる
    let lnum = target <= 0 ? 0 : search('^' . target . '  ', 'bw')
  endif
  call cursor(oldline, oldcol)
  return lnum
endfunction

function! s:GoThread_Article(target)
  let lnum = s:GetLnum_Article(a:target)
  if lnum
    if a:target ==# 'input'
      call s:AddHistoryJump(s:ScreenLine(), line('.'))
    endif

    " 指定行へ移動
    call AL_execute("normal! ".lnum."G")
    " 必要ならばfoldingを解除
    if foldclosed(lnum) > 0
      normal! zO
    endif
    " 表示位置を修正
    call AL_execute("normal! zt\<C-Y>")

    if a:target ==# 'input'
      call s:AddHistoryJump(s:ScreenLine(), line('.'))
    endif
  endif
  return lnum
endfunction

function! s:GoBuf_Write()
  let retval = AL_selectwindow(s:buftitle_write)
  if retval < 0
    call AL_execute("rightbelow split " . s:buftitle_write)
    setlocal filetype=2ch_write
  endif
  return retval
endfunction

function! s:GoBuf_Preview()
  let retval = AL_selectwindow(s:buftitle_preview)
  return retval
endfunction

function! s:GoBuf_Thread()
  let retval = AL_selectwindow(s:buftitle_thread)
  return retval
endfunction

function! s:GoBuf_BoardList()
  let retval = AL_selectwindow(s:buftitle_boardlist)
  return retval
endfunction

function! s:GoBuf_ThreadList()
  let retval = AL_selectwindow(s:buftitle_threadlist)
  return retval
endfunction

"}}}

"------------------------------------------------------------------------------
" JUMPLIST {{{
" 独自のジャンプリスト

let s:jumplist_current = 0
let s:jumplist_max = 0

function! s:JumplistClear()
  let s:jumplist_current = 0
  let s:jumplist_max = 0
endfunction

function! s:JumplistCurrent()
  return s:jumplist_max > 0 ? s:jumplist_data_{s:jumplist_current} : -1
endfunction

function! s:JumplistAdd(data)
  if s:jumplist_max > 0
    let s:jumplist_current = s:jumplist_current + 1
  else
    let s:jumplist_current = 0
  endif
  let s:jumplist_data_{s:jumplist_current} = a:data
  let s:jumplist_max = s:jumplist_current + 1

  " 履歴が増えすぎないように制限
  if s:jumplist_max > g:chalice_jumpmax
    let newmax = g:chalice_jumpmax / 2
    let src = s:jumplist_max - newmax
    let dest = 0
    while dest < newmax
      let s:jumplist_data_{dest} = s:jumplist_data_{src}
      let src = src + 1
      let dest = dest + 1
    endwhile
    let s:jumplist_max = newmax
    let s:jumplist_current = newmax - 1
  endif
endfunction

" 最後の要素を削除
function! s:JumplistRemoveLast()
  if s:jumplist_max > 0
    let s:jumplist_max = s:jumplist_max - 1
    if s:jumplist_max <= s:jumplist_current
      let s:jumplist_current = s:jumplist_max - 1
      if s:jumplist_current < 0
	let s:jumplist_current = 0
      endif
    endif
  endif
endfunction

function! s:JumplistNext()
  if s:jumplist_current >= s:jumplist_max - 1
    let s:jumplist_current = s:jumplist_max - 1
    return -1
  endif
  let s:jumplist_current = s:jumplist_current + 1
  let retval = s:jumplist_data_{s:jumplist_current}
  return retval
endfunction

function! s:JumplistPrev()
  if s:jumplist_max <= 0 || s:jumplist_current <= 0
    let s:jumplist_current = 0
    return -1
  endif
  let s:jumplist_current = s:jumplist_current - 1
  let retval = s:jumplist_data_{s:jumplist_current}
  return retval
endfunction

" ダンプ
function! s:JumplistDump()
  let i = 0
  call s:EchoH('Title',  'Chalice Jumplist (size=' . s:jumplist_max . ')')
  while i < s:jumplist_max
    let padding = i == s:jumplist_current ? '---->' : '     '
    let numstr = matchstr(padding . i, '......$')
    let indicator = (i == s:jumplist_current) ? ' > ' : '  '
    echo numstr . ': ' . s:jumplist_data_{i}
    let i = i + 1
  endwhile
endfunction

"
" 独自ジャンプリストのデバッグ用コマンド
"
if s:debug
  command! JumplistClear		call <SID>JumplistClear()
  command! -nargs=1 JumplistAdd		call <SID>JumplistAdd(<q-args>)
  command! JumplistPrev			echo "Prev: " . <SID>JumplistPrev()
  command! JumplistNext			echo "Next: " . <SID>JumplistNext()
  command! JumplistDump			call <SID>JumplistDump()
endif

"
" ジャンプ履歴に項目を追加
"
function! s:AddHistoryJump(scline, curline)
  call s:GoBuf_Thread()
  if b:host == '' || b:board == '' || b:dat == ''
    return ''
  endif
  let str1 = b:host.' '.b:board.' '.b:dat.' '.a:scline.' '
  let str2 = str1.a:curline.' '
  let current = s:JumplistCurrent()
  if strpart(current, 0, strlen(str2)) !=# str2
    if strpart(current, 0, strlen(str1)) ==# str1
      call s:JumplistPrev()
    endif
    call s:JumplistAdd(str2.b:title_raw)
    return 1
  else
    return 0
  endif
endfunction

"
" 履歴をジャンプ
function! s:DoHistoryJump(flag)
  let data = 0
  if AL_hasflag(a:flag, '\cnext')
    let data = s:JumplistNext()
  elseif AL_hasflag(a:flag, '\cprev')
    let data = s:JumplistPrev()
  endif

  let mx = '^\(\S\+\) \(\S\+\) \(\S\+\) \(\S\+\) \(\S\+\).*$'
  if data =~ mx
    " 履歴データを解釈
    let host = AL_sscan(data, mx, '\1')
    let board = AL_sscan(data, mx, '\2')
    let dat = AL_sscan(data, mx, '\3')
    let scline = AL_sscan(data, mx, '\4')
    let curline = AL_sscan(data, mx, '\5')
    " 履歴にあわせてバッファを移動
    call s:GoBuf_Thread()
    if host != b:host || board != b:board || dat != b:dat
      call s:UpdateThread('', host, board, dat, 'continue,noforce')
    endif
    " スクリーン表示開始行を設定→実行
    call s:ScreenLineJump(scline, 0)
    call AL_execute('normal! ' . curline . 'G')
  endif
endfunction

"}}}

"------------------------------------------------------------------------------
" PREVIEW FUNCTIONS {{{

function! s:OpenPreview_autocmd()
  if g:chalice_preview
    call s:OpenPreview()
  endif
endfunction

"
" カーソル直下のアンカーをプレビュー窓で開く
"
function! s:OpenPreview(...)
  " 現在行のアンカーの検出
  let anchor = a:0 > 0 && a:1 != '' ? a:1 : s:GetAnchorCurline()
  if anchor =~ s:mx_anchor_num
    " アンカーがレス番号参照の場合
    let host  = b:host
    let board = b:board
    let dat   = b:dat
  elseif s:ParseURL(anchor)
    " アンカーが有効なURLの場合
    let host  = s:parseurl_host
    let board = s:parseurl_board
    let dat   = s:parseurl_dat
    let anchor = '1'
    if s:parseurl_range_mode !~ 'l'
      if s:parseurl_range_start != ''
	let anchor = s:parseurl_range_start
      endif
      " >>1-1 や >>1-$ のような表記を避ける。ちなみに「>>1-$」という時は1か
      " ら最後まで表示するのではなく、1の記事だけを表示している。プレビュー
      " の意味だからそのほうが良いと判断したのだろう。
      if s:parseurl_range_end != '' && anchor != s:parseurl_range_end && s:parseurl_range_end != '$'
	let anchor = anchor.'-'.s:parseurl_range_end
      endif
    endif
    let anchor = '>>'.anchor
  else
    " アンカーがなければ何もしないかプレビューを閉じる
    if AL_hasflag(g:chalice_previewflags, 'autoclose')
      call s:ClosePreview()
    endif
    return 0
  endif

  " アンカーとdat名から最後に表示したプレビューを識別し、同じなら表示しない
  let id = s:GenerateDatname(host, board, dat) . anchor
  if id == getbufvar(s:buftitle_preview, 'chalice_preview_id')
    return 0
  endif

  " アンカーから開始記事と終了記事の番号を取得し、行番号へ変換
  let startnum = AL_sscan(anchor, s:mx_anchor_num, '\2') + 0
  let endnum = AL_sscan(anchor, s:mx_anchor_num, '\3') + 0
  if startnum > endnum
    let endnum = startnum
  endif

  let oldbuf = bufname('%')
  let result = s:OpenPreview2(host, board, dat, startnum, endnum)

  if result == 0
    if AL_hasflag(g:chalice_previewflags, 'autoclose')
      call s:ClosePreview()
    endif
    if AL_selectwindow(oldbuf) < 0
      call GoBuf_Thread()
    endif
    return 0
  endif

  " プレビューバッファの体裁を整える
  call setbufvar(s:buftitle_preview, 'chalice_preview_id', id)
  let b:title = s:prefix_preview.anchor
  if host != getbufvar(s:buftitle_thread, 'host') || board != getbufvar(s:buftitle_thread, 'board') || dat != getbufvar(s:buftitle_thread, 'dat')
    let b:title = b:title.' ('.substitute(getline(1), '^Title: ', '', '').')'
  endif
  let b:host  = host
  let b:board = board
  let b:dat   = dat
  call append(1, 'URL: '.s:GenerateThreadURL(host, board, dat, 'raw'))

  " プレビューの高さ、表示位置を調節する。
  call AL_setwinheight(&previewheight)
  normal! 4GztL$
  let height = winline()
  if height < &previewheight
    call AL_setwinheight(height)
  endif
  normal! 4Gzt

  call AL_selectwindow(oldbuf)
  return result
endfunction

" 指定されたdatの指定された範囲の記事をプレビュー表示する
function! s:OpenPreview2(host, board, dat, nstart, nend)
  let local = s:GenerateDatname(a:host, a:board, a:dat)
  if !filereadable(local)
    " DATが無い場合、
    call s:EchoH('ErrorMsg', s:msg_error_cantpreview)
    return 0
  endif

  if s:CountLines(local) < a:nstart
    let retval = s:DatCatchup(a:host, a:board, a:dat, 'continue,ifmodified')
    if retval < 1 || s:CountLines(local) < a:nstart
      call s:EchoH('ErrorMsg', s:msg_error_invalidanchor)
      return 0
    endif
  endif

  " プレビューバッファへ移動、必要なら作成してから移動
  if s:GoBuf_Preview() < 0
    let dir = AL_hasflag(g:chalice_previewflags, 'above') ? 'aboveleft' : 'belowright'
    call AL_execute(dir.' pedit '.s:buftitle_preview)
    call s:GoBuf_Preview() " 失敗したら?…知らん!!
    setlocal filetype=2ch_thread
  endif

  " プレビューの中身を作成する
  let contents = s:FormatThreadPartial(local, a:nstart, a:nend, s:GetHostEncoding(a:host))
  call s:GoBuf_Preview()
  if contents.'X' == 'X'
    call s:EchoH('ErrorMsg', s:msg_error_invalidanchor)
    return 0
  else
    call AL_buffer_clear()
    normal! G$
    call AL_append_multilines(contents)
    normal! gg"_2dd
    call append(0, 'Title: '.s:formatthreadpartion_title)
    return 1
  endif
endfunction

function! s:ClosePreview()
  call AL_execute('pclose')
endfunction

function! s:TogglePreview()
  if g:chalice_preview
    let g:chalice_preview = 0
    call s:ClosePreview()
  else
    let g:chalice_preview = 1
  endif
  " プレビューモード表示
  call s:EchoH('WarningMsg', g:chalice_preview ? s:msg_warn_preview_on : s:msg_warn_preview_off)
endfunction

"}}}

"------------------------------------------------------------------------------
" 2HTML {{{
" HTML化
"

function! s:ShowWithHtml(...)
  call s:GoBuf_Thread()
  if !exists("b:host") || !exists("b:board") || !exists("b:dat")
    call s:EchoH('Error', s:msg_error_htmlnotopen)
    return 0
  endif
  let dat = s:GenerateLocalKako(b:host, b:board, b:dat)
  if !filereadable(dat)
    let dat = s:GenerateLocalDat(b:host, b:board, b:dat)
    if !filereadable(dat)
      call s:EchoH('Error', s:msg_error_htmlnodat)
      return 0
    endif
  endif

  " HTML化開始記事番号と終了記事番号を取得
  if a:0 == 0
    let startnum = s:GetArticleNum('.')
    let endnum   = startnum
  elseif a:0 == 1
    let mx = '^\(\d*\)-\(\d*\)$'
    if a:1 =~ mx
      let startnum = AL_sscan(a:1, mx, '\1')
      let endnum   = AL_sscan(a:1, mx, '\2')
    else
      let startnum = a:1
      let endnum   = startnum
    endif
  else
    let startnum = a:1
    let endnum   = a:2
  endif
  let startnum = startnum == '' ? s:GetArticleNum('.') : startnum + 0
  let endnum   =   endnum == '' ? s:GetArticleNum('$') : endnum   + 0

  let url_base  = s:GenerateThreadURL(b:host, b:board, b:dat, 'raw')
  let url_board = s:GenerateBoardURL(b:host, b:board)

  let html = Dat2HTML(dat, startnum, endnum, url_base, url_board)
  if html != ''
    " ファイルへ書き出し
    let temp = s:dir_cache.'tmp.html'
    call AL_execute('redir! > '.temp)
    silent echo html
    redir END
    return AL_open_url('file://'.temp, g:chalice_exbrowser)
  else
    " 通常は起こらないエラー
    call s:EchoH('Error', 'Something wrong with Dat2HTML()!!')
    return 0
  endif
endfunction

"}}}

"------------------------------------------------------------------------------
" BOOKMARK FUNCTIONS {{{
" Bookmarkルーチン
"
let s:opened_bookmark = 0

"
" スレ一覧の内容を削除し、ブックマークをファイルから読み込み表示する。
"
function! s:OpenBookmark()
  if s:opened_bookmark
    return
  endif
  call s:GoBuf_ThreadList()
  let s:opened_bookmark = line('.') ? line('.') : 1
  let b:title = s:label_bookmark

  " 栞データの読込み
  let save_undolevels = &undolevels
  set undolevels=-1
  call AL_buffer_clear()
  setlocal filetype=2ch_bookmark
  call AL_execute("read ++enc= " . g:chalice_bookmark)
  silent! normal! gg"_dd0
  let &undolevels = save_undolevels

  call s:Redraw('force')
  call s:EchoH('WarningMsg', s:msg_warn_bookmark)
endfunction

"
" ブックマークをファイルに保存し、バッファを消去する。
"
function! s:CloseBookmark()
  if !s:opened_bookmark
    return
  endif
  let s:opened_bookmark = 0
  call s:GoBuf_ThreadList()
  match none
  " ブックマークのバックアップファイルネームを作成
  let mx = escape(s:bookmark_filename, '.').'$'
  let backupname = g:chalice_bookmark . s:bookmark_backupsuffix
  if g:chalice_bookmark =~ mx
    let backupname = substitute(g:chalice_bookmark, mx, s:bookmark_backupname, '')
  endif
  " バックアップファイルが充分古ければ再度バックアップを行なう
  if g:chalice_bookmark_backupinterval >= s:minimum_backupinterval && localtime() - getftime(backupname) > g:chalice_bookmark_backupinterval
    call rename(g:chalice_bookmark, backupname)
  endif
  " ブックマークファイルを保存
  call AL_write(g:chalice_bookmark)
  let save_undolevels = &undolevels
  set undolevels=-1
  call AL_buffer_clear()
  let &undolevels = save_undolevels

  " ftをセットした瞬間に必要なバッファ変数が消去されてしまうので、その対策。
  " 消去されるバッファ変数は ftplugin/2ch_threadlist.vim 参照:
  "	b:title, b:title_raw, b:host, b:board
  let title_raw = b:title_raw
  let host = b:host
  let board = b:board
  setlocal filetype=2ch_threadlist
  let b:title_raw = title_raw
  let b:host = host
  let b:board = board
endfunction

function! s:AddBookmark(title, url)
  let winnum = winnr()
  call s:OpenBookmark()
  call s:GoBuf_ThreadList()
  let url = a:url

  " 2重登録時
  normal! gg
  let existedbookmark = search('\V'.escape(a:url, "\\"), 'w')
  normal! 0
  if existedbookmark
    " 登録しようとしているURLが既出の場合、そのURLを表示してどうすべきか問い
    " 合わせる。
    if foldclosed(existedbookmark) > 0
      " currentとexistedbookmarkが同じであると言う前提(今はsearchにより保証
      " されている)
      normal! zv
    endif
    normal! 0zz
    " 問い合わせ
    call s:HighlightWholeline(existedbookmark, 'Search')
    call s:Redraw('force')
    let last_confirm = confirm(s:msg_confirm_replacebookmark, s:choice_rac, 3, "Question")
    match none
    call s:Redraw('force')
    if last_confirm == 1
      " 置き換え
      call AL_execute(':' . existedbookmark . 'delete _')
    elseif last_confirm == 2
      " 強制追加
    elseif last_confirm == 3
      " 登録をキャンセル
      let url = ''
    endif
  endif

  " URLをバッファに書込む
  if url != ''
    call append(0, a:title . "\t\t\t\t" . url)
  endif

  execute winnum.'wincmd w'
  if url == ''
    call s:Redraw('force')
    call s:EchoH('WarningMsg', s:msg_warn_bmkcancel)
  endif
endfunction

function! s:ToggleBookmark(flag)
  if !s:opened_bookmark
    call s:OpenBookmark()
  else
    let lnum = s:opened_bookmark
    call s:UpdateBoard('', '', '', '')
    call s:GoBuf_ThreadList()
    execute "normal! " . lnum . "G0"
  endif
  if AL_hasflag(a:flag, 'thread')
    call s:GoBuf_Thread()
  elseif AL_hasflag(a:flag, 'threadlist')
    call s:GoBuf_ThreadList()
  endif
endfunction

function! s:Thread2Bookmark(target)
  let title = ''
  let url = ''
  if AL_hasflag(a:target, 'thread')
    " スレッドから栞に登録
    call s:GoBuf_Thread()
    if b:host == '' || b:board == '' || b:dat == ''
      call s:Redraw('force')
      call s:EchoH('ErrorMsg', s:msg_error_addnothread)
      return
    endif
    if b:title_raw == ''
      let title = b:host . b:board . '/' . b:dat
    else
      let title = b:title_raw
    endif
    let url = s:GenerateThreadURL(b:host, b:board, b:dat, 'internal')
  elseif AL_hasflag(a:target, 'threadlist')
    " スレ一覧から栞に登録
    call s:GoBuf_ThreadList()
    let curline = getline('.')
    let mx = '^. \(.\+\) (\d\+) \%(\d\d\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d\)\?\s*\(\d\+\)\.\%(dat\|cgi\)$'
    if b:host == '' || b:board == '' || curline !~ s:mx_thread_dat
      call s:Redraw('force')
      call s:EchoH('ErrorMsg', s:msg_error_addnothreadlist)
      return
    endif
    let title = AL_sscan(curline, s:mx_thread_dat, '\1')
    let dat = AL_sscan(curline, s:mx_thread_dat, '\3')
    let url = s:GenerateThreadURL(b:host, b:board, dat, 'internal')
  elseif AL_hasflag(a:target, 'boardlist')
    " 板一覧から栞に登録
    call s:GoBuf_BoardList()
    let curline = getline('.')
    let mx = '^ \(.\+\)\s\+\(http:.\+\)$'
    if curline !~ mx
      call s:Redraw('force')
      call s:EchoH('ErrorMsg', s:msg_error_addnoboardlist)
      return
    endif
    " [板]を付けることでスレッドの区別(スレ名が[板]で始まったら泣く?)
    let title = s:label_board.' '.AL_sscan(curline, mx, '\1')
    let url = AL_sscan(curline, mx, '\2')
  endif
  " OUT: titleとurl

  call s:Redraw('force')
  if 0
    echo "title=" . title . " url=" . url
  else
    call s:AddBookmark(title, url)
  endif
endfunction

"}}}

"------------------------------------------------------------------------------
" WRITE BUFFER {{{
" 書き込みバッファルーチン
"

" 最後の書き込みで使用したusername及びusermail
let s:last_username = ''
let s:last_usermail = ''

" カレントバッファから
" <input type=hidden>なnameとvalueをURL形式で取得する
function! s:GetHiddenInputAsParamsFromBuffer(name_allow, name_deny)
  let retval = ''
  let mx = '\m\c<input type="\?hidden"\? name="\?\([^" \t>]*\)"\? value="\?\([^" \t>]*\)"\?'
  call AL_execute('%s/'.mx.'/\r&/g')
  call AL_execute('v/'.mx.'/d _')
  let lnum = 1
  while lnum <= line('$')
    let lstr = getline(lnum)
    let lnum = lnum + 1
    let name  = AL_sscan(lstr, mx, '\1')
    let value = AL_sscan(lstr, mx, '\2')
    if name != '' && (a:name_allow == '' || name =~ a:name_allow) && (a:name_deny == '' || name !~ a:name_deny)
      let retval = retval . '&'.name.'='.value
    endif
  endwhile
  call AL_execute('undo')
  call AL_execute('undo')
  return retval
endfunction

" URLのコンテンツから
" <input type=hidden>なnameとvalueをURL形式で取得する
function! s:GetHiddenInputAsParams(url)
  let tmp = tempname()
  call s:HttpDownload(a:url, '', tmp, '')
  call AL_execute('1vsplit ++enc= '.tmp)
  call delete(tmp)
  let retval = s:GetHiddenInputAsParamsFromBuffer('', '')
  silent! bwipeout!
  return retval
endfunction

function! s:GetWriteParams(url, host, bbs, key)
  " 2chから、書き込みに必要なhiddenパラメータを取得する
  let params = s:GetHiddenInputAsParams(s:GenerateThreadURL(a:host, a:bbs, a:key, 'onlyone'))
  if params != ''
    return params
  else
    if a:host =~ s:mx_servers_jbbstype
      return '&BBS='.a:bbs.'&KEY='.a:key.'&TIME='.localtime()
    else
      return '&bbs='.a:bbs.'&key='.a:key.'&time='.localtime()
    endif
  endif
endfunction

"
" 書き込み用バッファを開く
"
function! s:OpenWriteBuffer(...)
  let newthread = 0
  let quoted = ''

  " スレッドバッファから host, board, dat を取得
  if !newthread
    " 通常の書き込み
    call s:GoBuf_Thread()
    if b:host == '' || b:board == '' || b:dat == ''
      call s:EchoH('ErrorMsg', s:msg_error_appendnothread)
      return 0
    endif
    let title = b:title_raw
    let key = substitute(b:dat, '\.\(dat\|cgi\)$', '', '')
    " 現在カーソルがある記事の引用
    if a:0 > 0 && AL_hasflag(a:1, 'quote')
      " 引用開始位置を検索
      let quote_start = s:GetLnum_Article('current') - 1
      let first_article = s:GetLnum_Article(1) - 1
      if quote_start < first_article
	let quote_start = first_article
	let quote_end = s:GetLnum_Article(2) - 3
      else
	" 引用終了位置を検索
	let quote_end = s:GetLnum_Article('next') - 3
      endif
      " 範囲指定がひっくり返っている時、もしくは不正な時
      if quote_end < 1 || quote_end < quote_start
	let quote_end = line("$")
      endif
      " 文章を引用した文字列を作成(->quotedに格納)
      let quoted = '>>' . matchstr(getline(quote_start + 1), '^\(\d\+\)')
      let i = quote_start + 2
      while i <= quote_end
	let quoted = AL_addline(quoted, substitute(getline(i), '^.', '>', ''))
	let i = i + 1
      endwhile
    endif
  else
    " TODO 新規書き込み
    call s:GoBuf_ThreadList()
    if b:host == '' || b:board == ''
      call s:EchoH('ErrorMsg', s:msg_error_creatnoboard)
      return 0
    endif
    let title = ''
    let key = localtime()
  endif
  let host = b:host
  let bbs = substitute(b:board, '^/', '', '')

  " フラグに応じて匿名、sageを自動設定
  if exists('g:chalice_username_'.bbs.'_'.key)
    let username = g:chalice_username_{bbs}_{key}
  elseif exists('g:chalice_username_'.bbs)
    let username = g:chalice_username_{bbs}
  else
    let username = g:chalice_username
  endif
  if exists('g:chalice_usermail_'.bbs.'_'.key)
    let usermail = g:chalice_usermail_{bbs}_{key}
  elseif exists('g:chalice_usermail_'.bbs)
    let usermail = g:chalice_usermail_{bbs}
  else
    let usermail = g:chalice_usermail
  endif
  if a:0 > 0
    if AL_hasflag(a:1, 'anony')
      let username = g:chalice_anonyname
      let usermail = ''
    endif
    if AL_hasflag(a:1, 'last')
      let username = s:last_username
      let usermail = s:last_usermail
    endif
    if AL_hasflag(a:1, 'sage')
      let usermail = 'sage'
    endif
    if AL_hasflag(a:1, 'new')
      let newthread = 1
    endif
  endif

  " バッファの作成
  call s:GoBuf_Write()
  if !newthread
    let b:title = s:prefix_write . title
  else
    let b:title = s:prefix_write . s:label_newthread
  endif
  let b:title_raw = title
  let b:host = host
  let b:bbs = bbs
  let b:key = key
  let b:newthread = newthread
  " 書き込むべきスレのURLを作成しバッファ変数に保存する
  let b:url = 'http://'.host.'/test/read.cgi/'.bbs.'/'.key
  " hiddenなtimeパラメータの生成を、書き込み時ではなくバッファ作成時にする
  let b:write_params = s:GetWriteParams(b:url, host, bbs, key)

  call s:Redraw('')

  " 書き込みテンプレート作成
  let save_undolevels = &undolevels
  set undolevels=-1
  call AL_buffer_clear()
  let def = AL_addline('', 'Title: ' . title)
  let def = AL_addline(def, 'From: ' . username)
  let def = AL_addline(def, 'Mail: ' . usermail)
  let def = AL_addline(def, '--------')
  if quoted.'X' != 'X'
    let def = AL_addline(def, quoted)
  endif
  let def = AL_addline(def, '')
  call AL_append_multilines(def)
  let s:opened_write = 1
  let &undolevels = save_undolevels
  let &modified = 0

  " 書き込みに失敗した文章があれば自動的に追加。
  " なければインサートモード開始。
  if exists('g:chalice_lastmessage') && g:chalice_lastmessage != ''
    normal! G$
    call AL_append_multilines(g:chalice_lastmessage)
    call s:Redraw('force')
    call s:EchoH('WarningMsg', s:msg_help_rewrite)
  else
    call s:Redraw('force')
    call s:EchoH('WarningMsg', s:msg_help_write)
    normal! G
    startinsert
  endif
endfunction

function! s:OnCloseWriteBuffer()
  let s:opened_write = 0
endfunction

"
" 書込もう!!。書き込み内容が正しいかチェックしてから書き込み。
"
function! s:DoWriteBuffer(flag)
  if !s:opened_write
    return 0
  endif
  call s:GoBuf_Write()
  let newthread = b:newthread
  " 書き込み実行
  let write_result =  s:DoWriteBufferStub(a:flag)

  " 書き込みに成功した時には最終メッセージをクリアする
  if write_result != 0
    let g:chalice_lastmessage = ''
  endif

  " 書き込み後のバッファ処理
  if AL_hasflag(a:flag, '\cclosing')
    let s:opened_write = 0
    call s:GoBuf_Thread()
  elseif write_result != 0
    let s:opened_write = 0
    call s:GoBuf_Write()
    execute ":close!"
    call s:GoBuf_Thread()
  endif

  if !s:opened_write
    if !newthread
      "call s:GoBuf_Thread()
      "normal! zb
    else
      " 新スレ作成時(現在は使われない)
      call s:GoBuf_ThreadList()
    endif
  endif
  return 1
endfunction

" 書き込みを実行する。成功した場合は0以外を返す。
" TODO: 戻り値は考え直したほうが良い。-1とか変な値も返している。
function! s:DoWriteBufferStub(flag)
  let force_close = AL_hasflag(a:flag, '\cclosing')
  let writeoptions = g:chalice_writeoptions
  call s:GoBuf_Write()
  call s:Redraw('force')
  let newthread = b:newthread

  " デバッグ表示
  if 0
    echo 'b:title_raw=' . b:title_raw
    echo 'b:host=' . b:host
    echo 'b:bbs=' . b:bbs
    echo 'b:key=' . b:key
  endif

  " 書き込みバッファヘッダの妥当性検証
  let title = getline(1)
  let name = getline(2)
  let mail = getline(3)
  let sep = getline(4)
  if title !~ '^Title:\s*' || name !~ '^From:\s*' || mail !~ '^Mail:\s*' || sep != '--------'
    call confirm(s:msg_error_writebufhead, "", 1, "Error")
    return 0
  endif
  let title = AL_chompex(substitute(title,  '^Title:', '', ''))
  let name =  AL_chompex(substitute(name,   '^From:',  '', ''))
  let mail =  AL_chompex(substitute(mail,   '^Mail:',  '', ''))

  " 新スレ作成時にタイトルを設定したか確認
  if newthread && title == ''
    call confirm(s:msg_error_writetitle, "", 1, "Error")
    return 0
  endif

  if !AL_hasflag(writeoptions, 'keepemptylines')
    " 本文先頭と末尾の空白行を削除
    normal! 5G
    while line('.') > 4
      if getline('.') !~ '^\s*$'
	break
      endif
      normal! "_dd
    endwhile
    " 末尾
    normal! G
    while line('.') > 4
      if getline('.') !~ '^\s*$'
	break
      endif
      normal! "_dd
    endwhile
  endif

  " 本文があるかをチェック
  if line('$') < 5
    call confirm(s:msg_error_writebufbody, "", 1, "Error")
    return 0
  endif

  " 本文中のタブを整理
  if AL_hasflag(writeoptions, 'retab')
    silent! retab!
  endif

  " 本文からメッセージを取得
  let message = getline(5)
  let curline = 6
  let lastline = line('$')
  while curline <= lastline
    let message = message . "\n" . getline(curline)
    let curline = curline + 1
  endwhile
  let g:chalice_lastmessage = message

  " 必要な文字は実体参照へ置き換え
  if b:host =~ s:mx_servers_shitaraba
    " したらば系では&amp;と&nbsp;への置換えはサーバ側で行なわれる
    let writeoptions = AL_delflag(writeoptions, 'amp')
    let writeoptions = AL_delflag(writeoptions, 'nbsp')
    let writeoptions = AL_delflag(writeoptions, 'nbsp2')
  endif
  " &記号を&amp;に置換
  if AL_hasflag(writeoptions, 'amp')
    let message = substitute(message, '&', '\&amp;', 'g')
  endif
  " 半角スペース2個を全角スペース1個に展開
  if AL_hasflag(writeoptions, 'zenkaku')
    let message = substitute(message, '  ', '　', 'g')
  endif
  " 半角スペースを&nbsp;に置換
  if AL_hasflag(writeoptions, 'nbsp')
    let message = substitute(message, ' ', '\&nbsp;', 'g')
  endif
  " &nbsp;への展開を最小限にする
  if AL_hasflag(writeoptions, 'nbsp2')
    "let message = substitute(message, '  ', ' \&nbsp;', 'g')
    let message = substitute(message, '\(^\|'."\n".'\| \) ', '\1\&nbsp;', 'g')
  endif

  " 書き込み前の最後の確認
  echohl Question
  " chalice_noquery_writeが設定されている時には有無を言わさず書込む。Chalice
  " 終了に伴う強制書込みでは同オプションに関わらず確認をする。
  if AL_hasflag(a:flag, 'quit') || !exists('g:chalice_noquery_write') || !g:chalice_noquery_write
    if force_close
      " 通常の確認
      let last_confirm = confirm(s:msg_confirm_appendwrite_yn, s:choice_yn, 2, "Question")
      echohl None
      if last_confirm == 1
      elseif last_confirm == 2
	call confirm(s:msg_error_writeabort, "", 1, "Error")
	return -1
      endif
    else
      " 選択肢にキャンセルがある確認
      let last_confirm = confirm(s:msg_confirm_appendwrite_ync, s:choice_ync, 3, "Question")
      echohl None
      if last_confirm == 1
      elseif last_confirm == 2
	call s:Redraw('force')
	call s:EchoH('ErrorMsg', s:msg_error_writeabort)
	return -1
      elseif last_confirm == 3
	call s:Redraw('force')
	call s:EchoH('WarningMsg', s:msg_error_writecancel)
	return 0
      endif
    endif
  endif

  " 書き込みデータチャンク作成
  let key = b:key
  let flags = ''
  if newthread
    let key = localtime()
    let flags = flags . 'new'
  endif
  let chunk = s:CreateWriteChunk(b:host, b:bbs, key, title, name, mail, message, flags)
  if chunk == ''
    return 0
  endif

  " 書き込み結果を格納する一時ファイル
  let resfile = tempname()
  " 書き込む内容を保存した一時ファイル
  let tmpfile = tempname()
  redraw!
  execute "redir! > " . tmpfile 
  silent echo chunk
  redir END
  if s:debug
    let g:chalice_lastchunk = chunk
  endif

  " 書き込みコマンドの発行
  "   必要なデータ変数: tmpflie, b:host, b:bbs
  call s:Redraw('force')
  " 起動オプションの構築→cURLの実行
  let opts = g:chalice_curl_options
  if exists('g:chalice_curl_writeoptions') && g:chalice_curl_writeoptions.'X' != 'X'
    let opts = g:chalice_curl_writeoptions
  endif
  if s:user_agent_enable
    let opts = opts . ' -A ' . AL_quote(s:GetUserAgent())
  endif
  let opts = opts . ' -b NAME= -b MAIL='
  if g:chalice_curl_cookies != 0 && exists('g:chalice_cookies')
    let opts = opts . ' -c ' . AL_quote(g:chalice_cookies)
    let opts = opts . ' -b ' . AL_quote(g:chalice_cookies)
  endif
  let opts = opts . ' -d @' . AL_quote(tmpfile)
  let opts = opts . ' -e http://' . b:host . '/' . b:bbs . '/index2.html'
  let opts = opts . ' -o ' . AL_quote(resfile)
  let opts = opts . ' ' . s:GenerateWriteURL(b:host, b:bbs, b:key)
  let thread_url = s:GenerateThreadURL(b:host, b:bbs, b:key, 'raw')
  let exec_cmd = s:cmd_curl.' '.opts
  call s:DoExternalCommand(exec_cmd)
  " 書き込み時のusernameとusermailを保存
  let s:last_username = name
  let s:last_usermail = mail
  let wrote_host = b:host

  " 書き込み結果(resfile)の解析
  let retval = 1
  let show_resfile = 0
  let error_msg = ''
  let new_write_params = ''
  call AL_execute('1vsplit '.resfile)
  let mx = '2ch_X:\(\w\+\)'
  let nr2ch_X = search(mx, 'w')
  let rescode = nr2ch_X > 0 ? AL_sscan(getline(nr2ch_X), mx, '\1') : ''
  " 書き込みになんらかの理由で失敗していたらreturn 0(retval = 0)する。
  " 結果ファイルを表示するかどうかはshow_resfileで制御する。
  " エラーメッセージを表示する必要がある場合にはerror_msgに設定する。
  if rescode ==# 'cookie'
    " Cookie確認画面でwrite_paramsを更新する。
    let retval = 0
    let show_resfile = 1
    let error_msg = s:msg_error_writecookie
    if wrote_host =~ s:mx_servers_jbbstype
      let new_write_params = s:GetHiddenInputAsParamsFromBuffer('', '\m^\%(SUBJECT\|NAME\|MAIL\|MESSAGE\)$')
    else
      let new_write_params = s:GetHiddenInputAsParamsFromBuffer('', '\m^\%(subject\|FROM\|mail\|MESSAGE\)$')
    endif
  elseif rescode ==# 'error'
    let retval = 0
    let show_resfile = 1
    let error_msg = s:msg_error_writeerror
  elseif rescode ==# 'false'
    let show_resfile = 1
    let error_msg = s:msg_error_writefalse
  elseif rescode ==# 'check'
    let retval = 0
    let show_resfile = 1
    let error_msg = s:msg_error_writecheck
  elseif getline(2) =~ 'サーバ.*負荷.*高'
    " サーバ過負荷による書き込み失敗
    let retval = 0
    let show_resfile = 1
    let error_msg = s:msg_error_writehighload
  else
    let is_error = 1
    if is_error == 1 && rescode ==? 'true'
      let is_error = 0
    endif
    if is_error == 1 && getline(1) =~ '書きこみました'
      let is_error = 0
    endif
    if is_error == 1 && search('<title>書きこみました。</title>', 'w') > 0
      let is_error = 0
    endif
    if is_error == 1 && wrote_host =~ s:mx_servers_machibbs && search('302 Found', 'w') > 0
      let is_error = 0
    endif
    if is_error != 0
      " 書き込み成功ではない場合
      let retval = 0
      let show_resfile = 1
      let error_msg = s:msg_error_writenottrue
    endif
  endif
  " 結果ファイルをHTMLで表示
  if show_resfile
    let temp = s:dir_cache.'tmp.html'
    call AL_write(temp)
    call AL_open_url('file://'.temp, g:chalice_exbrowser)
  endif
  silent! bwipeout!
  " 存在する場合にはエラーメッセージを表示する
  if error_msg.'X' ==# 'X'
    let result = 'OK'
  else
    let result = 'ERROR: '.error_msg
  endif

  " ログを取る
  if AL_hasflag(g:chalice_writeoptions, 'log')
    call s:LogWriteBuffer(thread_url, exec_cmd, result)
  endif

  if result !=# 'OK'
    call s:Redraw('force')
    call s:EchoH('ErrorMsg', error_msg)
    if new_write_params != ''
      let b:write_params = new_write_params
    endif
  endif

  " 後始末
  call delete(resfile)
  call delete(tmpfile)
  if retval > 0
    if !newthread
      call s:UpdateThread('', '', '', '', 'continue,force')
    else
      call s:UpdateThread(title,  b:host , '/' . b:bbs, b:key . '.dat', '')
    endif
  endif
  return retval
endfunction

function! s:LogWriteBuffer(thread_url, exec_cmd, result)
  call s:GoBuf_Write()
  echo ""
  execute "redir! >> ".s:chalice_writelogfile
  silent echon 'Time: '.strftime('%Y/%m/%d %H:%M:%S')
  silent echo 'Result: '.a:result
  silent echo 'Command: '.a:exec_cmd
  silent echo 'URL: '.a:thread_url
  silent %print
  silent echo AL_string_multiplication('=', 78)
  silent echo ''
  redir END
endfunction

function! s:CreateWriteChunk(host, board, key, title, name, mail, message, ...)
  let flags = a:0 > 0 ? a:1 : ''

  " ホストに合わせてサブミットキーを決定
  let sbmk = '書き込み'
  if AL_hasflag(flags, 'new')
    if a:host =~ s:mx_servers_jbbstype
      let sbmk = '新規書き込み'
    else
      let sbmk = '新規スレッド作成'
    endif
  endif

  " ホストに合わせて書き込みエンコーディングを決定
  let enc_write = s:GetHostEncoding(a:host)

  " 文字コード変換
  let title = a:title
  let name = a:name
  let mail = a:mail
  let msg = a:message
  if &encoding != enc_write
    if has('iconv')
      let title	= iconv(title,	&encoding, enc_write)
      let name	= iconv(name,	&encoding, enc_write)
      let mail	= iconv(mail,	&encoding, enc_write)
      let msg	= iconv(msg,	&encoding, enc_write)
      let sbmk	= iconv(sbmk,	&encoding, enc_write)
    else
      " TODO: エラーメッセージ
      return ''
    endif
  endif

  " 書き込み用チャンク作成
  let sbmk = AL_urlencode(sbmk)
  if b:host =~ s:mx_servers_jbbstype
    return s:CreateWriteChunk_JBBS(a:host, a:board, a:key, title, name, mail, msg, sbmk, flags)
  else

    return s:CreateWriteChunk_2ch(a:host, a:board, a:key, title, name, mail, msg, sbmk, flags)
  endif
endfunction

function! s:CreateWriteChunk_2ch(host, board, key, title, name, mail, message, submitkey, ...)
  " 書き込みデータチャンクを作成
  " 2ちゃんねる、2ちゃんねる互換板、したらば用
  "   利用すべきデータ変数: name, mail, message, a:board, a:key(, host)
  "   参考URL: http://members.jcom.home.ne.jp/monazilla/document/write.html
  let flags = a:0 > 0 ? a:1 : ''
  let chunk = ''
  let chunk = chunk . 'submit=' . a:submitkey
  let chunk = chunk . '&FROM=' . AL_urlencode(a:name)
  let chunk = chunk . '&mail=' . AL_urlencode(a:mail)
  let chunk = chunk . '&MESSAGE=' . AL_urlencode(a:message)
  " bbsとkeyはb:write_paramsとして、取得できているハズなので追加しない
  "let chunk = chunk . '&bbs=' . a:board
  if !AL_hasflag(flags, 'new')
    "let chunk = chunk . '&key=' . a:key
  else
    let chunk = chunk . '&subject=' . AL_urlencode(a:title)
  endif
  if exists('b:write_params')
    let chunk = chunk . b:write_params
  endif
  " SIDがある場合は追加する
  let chunk = s:AddSidToChunk(chunk)
  return chunk
endfunction

"}}}

"------------------------------------------------------------------------------
" GENERATE FILENAMES {{{
" ファイル名の生成

function! s:GetPath_FormatedCache_Subject(host, board)
  return s:GetPath_FormatedCache(a:host, a:board, 'subject')
endfunction

function! s:GetPath_FormatedCache(host, board, dat)
  return s:RegularlisePath(a:host.a:board).'_'.s:RegularliseDat(a:dat).'.'.&encoding.'.txt'
endfunction

function! s:GetPath_Datdir_Skelton(host, board, dat, ext)
  let hostdir = s:GetPath_Datdir_Host(a:host)
  if hostdir.'X' ==# 'X'
    return ''
  else
    return hostdir.s:RegularlisePath(a:board).'_'.s:RegularliseDat(a:dat).a:ext
  endif
endfunction

function! s:GetPath_Datdir_Dat(host, board, dat)
  return s:GetPath_Datdir_Skelton(a:host, a:board, a:dat, '.dat')
endfunction

function! s:GetPath_Datdir_Kako(host, board, dat)
  return s:GetPath_Datdir_Skelton(a:host, a:board, a:dat, '.kako')
endfunction

function! s:GetPath_Datdir_Abone(host, board, dat)
  return s:GetPath_Datdir_Skelton(a:host, a:board, a:dat, '.abone')
endfunction

function! s:GetPath_Datdir_Subject(host, board)
  return s:GetPath_Datdir_Skelton(a:host, a:board, 'subject', '.txt')
endfunction

" ホスト用のDATDIRのパスを返す。
function! s:GetPath_Datdir_Host(host)
  return s:GetPath_Datdir().s:RegularlisePath(a:host).'/'
endfunction

" DATDIR用ディレクトリを取得する。
function! s:GetPath_Datdir()
  return s:dir_cache.'dat.d/'
endfunction

" Chaliceで使用するリモートパスを正規化する
function! s:RegularlisePath(path)
  return substitute(substitute(a:path, '/', '_', 'g'), '^_\|_$', '', '')
endfunction

" Chaliceで使用するDAT識別子の拡張子を削除、正規化する
function! s:RegularliseDat(dat)
  return substitute(a:dat, '\m.\(dat\|cgi\)$', '', '')
endfunction

function! s:GenerateAboneFile(host, board, dat)
  if s:datdir_enabled
    return s:GetPath_Datdir_Abone(a:host, a:board, a:dat)
  else
    return s:dir_cache .'abonedat_'. s:RegularlisePath(a:host.a:board) .'_'. s:RegularliseDat(a:dat)
  endif
endfunction

function! s:GenerateDatname(host, board, dat)
  let datname = s:GenerateLocalKako(a:host, a:board, a:dat)
  if filereadable(datname)
    return datname
  endif
  let datname = s:GenerateLocalDat(a:host, a:board, a:dat)
  if filereadable(datname)
    return datname
  endif
  return ''
endfunction

function! s:GenerateRemoteDat(host, board, dat)
  if a:host =~ s:mx_servers_shitaraba
    return '/bbs'.a:board.'/dat/'.a:dat.'.dat'
  else
    return a:board.'/dat/'.a:dat
  endif
endfunction

" ローカルDATのパスを生成する
function! s:GenerateLocalDat(host, board, dat)
  if s:datdir_enabled
    return s:GetPath_Datdir_Dat(a:host, a:board, a:dat)
  else
    return s:dir_cache .'dat_'. s:RegularlisePath(a:host.a:board) .'_'. s:RegularliseDat(a:dat)
  endif
endfunction

function! s:GenerateLocalKako(host, board, dat)
  if s:datdir_enabled
    return s:GetPath_Datdir_Kako(a:host, a:board, a:dat)
  else
    return s:dir_cache .'kako_dat_'. s:RegularlisePath(a:host.a:board) .'_'. s:RegularliseDat(a:dat)
  endif
endfunction

function! s:GenerateLocalSubject(host, board)
  if s:datdir_enabled
    return s:GetPath_Datdir_Subject(a:host, a:board)
  else
    return s:dir_cache .'subject_'. s:RegularlisePath(a:host.a:board)
  endif
endfunction

"}}}

"------------------------------------------------------------------------------
" FORMATTING {{{
" 各ペインの整形

function! s:WriteFormatedCache_Subject(host, board)
  if s:fcachedir_enabled
    let cacheid = s:GetPath_FormatedCache_Subject(a:host, a:board)
    let fcachedfile = CACHEMAN_update(s:fcachedir, cacheid)
    call AL_write(fcachedfile)
  endif
endfunction

function! s:ShowNumberOfArticle(flags)
  " スレ一覧の既得スレ数を更新
  let save_undolevels = &undolevels
  set undolevels=-1
  if AL_hasflag(a:flags, 'all')
    let retval = s:FormatThreadInfo(1, 0, 'numcheck')
  elseif AL_hasflag(a:flags, 'curline')
    let retval = s:FormatThreadInfo(line('.'), line('.'), 'numcheck')
  endif
  let &undolevels = save_undolevels
  " フォーマットキャッシュを更新
  if retval > 0
    call s:WriteFormatedCache_Subject(b:host, b:board)
  endif
endfunction

function! s:RemoveNGWords()
  " NGワードの削除
  if exists('g:chalice_ngwords') && g:chalice_ngwords.'X' !=# 'X'
    " ローカルあぼーん用置換え文字列を構築
    let mx = '\m^\([^,]*\),\([^,]*\),\([^,]*\)$'
    let label = substitute(g:chalice_localabone, '[<>]', '', 'g')
    if label !~# mx
      let label = s:label_localabone
    endif
    let localabone = AL_sscan(label, mx, '\1').'<>'.AL_sscan(label, mx, '\2').'<><>'.AL_sscan(label, mx, '\3').'<>'
    " 各単語に対してローカルあぼーんを判定していく
    let ngwords = g:chalice_ngwords
    while ngwords != ''
      let ngw = AL_firstline(ngwords)
      let ngwords = AL_lastlines(ngwords)
      if ngw != ''
	call AL_execute('silent! 2,$g/'.ngw."/call setline('.','".localabone."')")
      endif
    endwhile
    call AL_del_lastsearch()
  endif
endfunction

function! s:UpdateFormatCache()
  " フォーマットキャッシュの更新
  if s:fcachedir_enabled && exists('b:host') && exists('b:board') && exists('b:dat')
    " DAT整形キャッシュ(書き込み)
    let cacheid = s:GetPath_FormatedCache(b:host, b:board, b:dat)
    let filename = CACHEMAN_update(s:fcachedir, cacheid)
    "call AL_echokv('filename', filename)
    if filename.'X' !=# 'X'
      call AL_write(filename)
    endif
  endif
endfunction

function! s:FormatThreadWhole(local, enc)
  " バッファクリアとスレdatの読み込み
  call AL_buffer_clear()
  if a:enc.'X' !=# 'X'
    call AL_execute('read ++enc='.a:enc.' '.a:local)
  else
    call AL_execute('read '.a:local)
  endif
  normal! gg"_dd
  " 最終記事番号を取得
  let b:chalice_lastnum = line('$')
  " NGワード
  call s:RemoveNGWords()
  " Do the 整形
  call s:EchoH('WarningMsg', s:msg_wait_threadformat)
  let retval = Dat2Text(g:chalice_verbose > 0 ? 'verbose' : '')
  " Board表示追加
  if exists('b:host') && exists('b:board') && exists('b:dat')
    call append(2, 'Board: '.s:GenerateBoardURL(b:host, b:board))
    call append(3, 'URL: '.s:GenerateThreadURL(b:host, b:board, b:dat, 'raw'))
    " フォーマットキャッシュの更新
    call s:UpdateFormatCache()
  endif
  return retval
endfunction

function! s:FormatThread(local, ...)
  let flags = a:0 > 0 ? a:1 : ''
  let fcachedfile = ''
  " キャッシュ済みファイルの検索
  if s:fcachedir_enabled && exists('b:host') && exists('b:board') && exists('b:dat')
    let cacheid = s:GetPath_FormatedCache(b:host, b:board, b:dat)
    if AL_hasflag(flags, 'ignorecache')
      call CACHEMAN_clear(s:fcachedir, cacheid)
    else
      let fcachedfile = CACHEMAN_getpath(s:fcachedir, cacheid)
    endif
  endif

  " スレ整形作業
  let retval = 0
  let save_undolevels = &undolevels
  set undolevels=-1
  if fcachedfile.'X' !=# 'X' && filereadable(fcachedfile)
    " 存在すればフォーマットキャッシュを読み込み、差分を整形する。
    call AL_buffer_clear()
    call AL_execute("read ++enc= " . fcachedfile)
    normal! gg"_dd
    call s:FormatThreadDiff(a:local, s:GetArticleNum('$') + 1, s:GetHostEncoding(b:host))
    let retval = s:formatthreadpartion_title
  else
    if exists('b:host')
      let retval = s:FormatThreadWhole(a:local, s:GetHostEncoding(b:host))
    else
      let retval = s:FormatThreadWhole(a:local, '')
    endif
  endif
  let &undolevels = save_undolevels
  return retval
endfunction

function! s:FormatThreadDiff(local, newarticle, enc)
  let contents = s:FormatThreadPartial(a:local, a:newarticle, -1, a:enc)
  " スレバッファへ挿入
  if AL_countlines(contents) > 0
    call s:GoBuf_Thread()
    normal! G$
    call AL_append_multilines(contents)
  else
    call s:GoBuf_Thread()
    normal! G0
  endif
  " 最終記事番号を保存
  let b:chalice_lastnum = s:GetArticleNum('$')
  " DATサイズを更新
  let b:datutil_datsize = getfsize(a:local)
  call setline(2, 'Size: '.(b:datutil_datsize / 1024).'KB')
  " フォーマットキャッシュの更新
  call s:UpdateFormatCache()
endfunction

function! s:FormatThreadPartial(local, n_start, n_end, enc)
  if a:enc.'X' !=# 'X'
    call AL_execute('vertical 1sview ++enc='.a:enc.' '.a:local)
  else
    call AL_execute('vertical 1sview '.a:local)
  endif
  call s:RemoveNGWords()
  let s:formatthreadpartion_title = DatGetTitle()
  " 整形作業
  let contents = ''
  let i = a:n_start
  let n_end = a:n_end < 0 || a:n_end > line('$') ? line('$') : a:n_end
  let on_verbose = 0
  if n_end - a:n_start > 50
    call AL_echo(s:msg_wait_threadformat, 'WarningMsg')
    if g:chalice_verbose > 0
      let on_verbose = 1
    endif
  endif
  while i <= n_end
    if on_verbose  && i % 100 == 0
      call AL_echo(i.'/'.n_end, 'WarningMsg')
    endif
    let contents =  contents ."\r". DatLine2Text(i, getline(i))
    let i = i + 1
  endwhile
  silent! bwipeout!
  return substitute(contents, "\r", "\<NL>", 'g')
endfunction

function! s:FormatThreadInfoWithoutUndo(startline, endline, ...)
  let save_undolevels = &undolevels
  set undolevels=-1
  let flags = a:0 > 0 ? a:1 : ''
  call s:FormatThreadInfo(a:startline, a:endline, flags)
  let &undolevels = save_undolevels
endfunction

"
" endlineに0を指定するとバッファの最後。
"
function! s:FormatThreadInfo(startline, endline, ...)
  call s:GoBuf_ThreadList()
  " バッファがスレ一覧ではなかった場合、即終了
  if s:opened_bookmark || b:host == '' || b:board == ''
    return 0
  endif
  let flags = a:0 > 0 ? a:1 : ''

  let modified = 0
  let i = a:startline
  let lastline = a:endline ? a:endline : line('$')
  let threshold_time = localtime() - g:chalice_threadinfo_expire

  " 各スレのdatファイルが存在するかチェックし、存在する場合には最終取得時刻
  " をチェックし、それによって強調の仕方を変える。
  " 1. datが存在し過去chalice_threadinfo_expire内に更新 →!を行頭へ
  " 2. datが存在し過去chalice_threadinfo_expire外に更新 →+を行頭へ
  while i <= lastline
    let curline = getline(i)
    if curline =~ s:mx_thread_dat
      " タイトル、書き込み数、dat名を取得
      let title = AL_sscan(curline, s:mx_thread_dat, '\1')
      let point = AL_sscan(curline, s:mx_thread_dat, '\2') + 0
      let dat	= AL_sscan(curline, s:mx_thread_dat, '\3')
      " ローカルDAT、Aboneフラグファイルを取得
      let local = s:GenerateLocalDat(b:host, b:board, dat)
      let abone = s:GenerateAboneFile(b:host, b:board, dat)
      " ファイルが存在するならばファイル情報を取得
      let indicator = ' '
      let time = ''
      let artnum = 0
      if filereadable(abone)
	let indicator = 'x'
      elseif filereadable(local)
	let lasttime = getftime(local)
	let indicator = threshold_time > lasttime ? '+' : '*'
	let time = strftime("%Y/%m/%d %H:%M:%S", lasttime)
	" 既存の書込み数をチェック
	if AL_hasflag(flags, 'numcheck')
	  let artnum = s:CountLines(local)
	  if artnum > 0
	    if point > artnum
	      let indicator = '!'
	    else
	      let point = artnum
	    endif
	  endif
	else
	  let artnum = -1
	endif
      endif
      " ラインの内容が変化していたら設定
      let newline = indicator.' '.title.' ('.(artnum >= 0 ? artnum : '???').'/'. point.') '.time."\t\t\t\t".dat
      if curline !=# newline
	call setline(i, newline)
	let modified = modified + 1
      endif
    endif
    let i = i + 1
  endwhile

  normal! 0
  return modified
endfunction

function! s:FormatBoard()
  " subject.txtの整形。各タイプ毎の置換パターンを用意
  " ちょっと免疫アルゴリズム的(笑)
  let mx_shitaraba  = '^\(\d\+_\d\+\)<>\(.\{-\}\)<>\(\d\+\)<><>NULL<>$'
  let mx_mikage	    = '^\(\d\+\.\%(dat\|cgi\)\),\(.*\)(\(\d\+\))$'
  let mx_2ch	    = '^\(\d\+\.dat\)<>\(.*\) (\(\d\+\))$'
  let out_pattern   = '  \2 (\3)\t\t\t\t\1'

  " どのタイプかを判定。デフォルトは2ch形式
  let firstline = getline(1)
  let mx = mx_2ch
  let b:format = '2ch'
  if firstline =~ mx_shitaraba
    " したらばの場合
    let mx = mx_shitaraba
    let out_pattern = out_pattern . '.dat'
    let b:format = 'shitaraba'
  elseif firstline =~ mx_mikage
    " mikageの場合
    let mx = mx_mikage
    let b:format = 'mikage'
  endif

  " 整形を実行
  call AL_execute('%s/' .mx. '/' .out_pattern)
  " 特殊文字潰し
  call AL_decode_entityreference_with_range('%')
  call AL_del_lastsearch()

  if g:chalice_threadinfo
    call s:FormatThreadInfo(1, 0, g:chalice_autonumcheck != 0 ? 'numcheck' : '')
  endif
endfunction

"}}}

"------------------------------------------------------------------------------
" BBS WRAPPER {{{
" BBSの種別を隠蔽するためのラッパー
"

function! s:DatCatchup(host, board, dat, flags)
  if a:host =~ s:mx_servers_jbbstype
    let dat = substitute(a:dat, '\.dat$', '.cgi', '')
    let retval = s:DatCatchup_JBBS(a:host, a:board, dat, a:flags)
  else
    let retval = s:DatCatchup_2ch(a:host, a:board, a:dat, a:flags)
  endif
  return retval
endfunction

function! s:GenerateWriteURL(host, board, key, ...)
  " host, board, key, flagからき込み用URLを生成する
  let flags = a:0 > 0 ? a:1 : ''
  if a:host =~ s:mx_servers_jbbstype
    let url = ' http://' . a:host . '/bbs/write.cgi'
  elseif a:host =~ s:mx_servers_shitaraba
    let url = ' http://' . a:host . '/cgi-bin/bbs.cgi'
  else
    let url = ' http://' . a:host . '/test/bbs.cgi'
  endif
  return url
endfunction

function! s:GenerateRemoteSubject(host, board, ...)
  let flags = a:0 > 0 ? a:1 : ''
  if a:host =~ s:mx_servers_shitaraba
    let url = '/bbs'.b:board.'/subject.txt'
  else
    let url = b:board.'/subject.txt'
  endif
  return url
endfunction

function! s:GenerateBoardURL(host, board, ...)
  if a:host =~ s:mx_servers_shitaraba
    return 'http://'.b:host.'/bbs'.b:board.'/'
  else
    return 'http://'.b:host.b:board.'/'
  endif
endfunction

" Flags:
"   NONE	最新50のURL
"   raw		スレッド全体のURL
"   internal	スレッド全体のURL
"   onlyone	1のみのURL
function! s:GenerateThreadURL(host, board, key, ...)
  " host, board, key, flagから開くべきURLを生成する
  let flags = a:0 > 0 ? a:1 : ''
  let board = substitute(a:board, '^/', '', '')
  let key = substitute(a:key, '\.\(dat\|cgi\)$', '', '')
  if a:host =~ s:mx_servers_jbbstype
    if a:host =~ s:mx_servers_machibbs
      let url = 'http://'.a:host.'/bbs/read.pl?BBS='.board.'&KEY='.key
    else
      let url = 'http://'.a:host.'/bbs/read.cgi?BBS='.board.'&KEY='.key
    endif
    if AL_hasflag(flags, 'onlyone')
      let url = url . '&START=1&END=1'
    elseif !AL_hasflag(flags, 'internal') && !AL_hasflag(flags, 'raw')
      let url = url . '&LAST=50'
    endif
  elseif a:host =~ s:mx_servers_shitaraba
    let url = 'http://'.a:host.'/cgi-bin/read.cgi?key='.key.'&bbs='.board
    if AL_hasflag(flags, 'onlyone')
      let url = url . '&START=1&END=1'
    elseif !AL_hasflag(flags, 'internal') && !AL_hasflag(flags, 'raw')
      let url = url . '&ls=50'
    endif
  else
    let url = 'http://'.a:host.'/test/read.cgi/'.board.'/'.key.'/'
    if AL_hasflag(flags, 'onlyone')
      let url = url . '1n'
    elseif !AL_hasflag(flags, 'internal') && !AL_hasflag(flags, 'raw')
      let url = url . 'l50'
    endif
  endif
  return url
endfunction

" OUT:
"   s:parseurl_host
"   s:parseurl_board
"   s:parseurl_dat
"   s:parseurl_range_start
"   s:parseurl_range_end
"   s:parseurl_range_mode
function! s:ParseURL(url)
  let retval = 0
  if s:ParseURL_is2ch(a:url)
    let retval = 1
  elseif s:ParseURL_isJBBS(a:url)
    let retval = 1
  elseif s:ParseURL_isShitaraba(a:url)
    let retval = 1
  endif
  "echo 'host='.s:parseurl_host.' board='.s:parseurl_board.' dat='.s:parseurl_dat
  "echo 'start='.s:parseurl_range_start.' end='.s:parseurl_range_end.' mode='.s:parseurl_range_mode
  return retval
endfunction

"}}}

"------------------------------------------------------------------------------
" JBBS {{{
" JBBS/したらば/まちBBS対応用
"

function! s:ParseURL_isShitaraba(url)
  let host = AL_sscan(a:url, s:mx_url_parse, '\1')
  let path = AL_sscan(a:url, s:mx_url_parse, '\2')
  let argq = AL_sscan(a:url, s:mx_url_parse, '\3')
  let mark = AL_sscan(a:url, s:mx_url_parse, '\4')
  if host !~ s:mx_servers_shitaraba
    return 0
  endif
  if path ==# 'cgi-bin/read.cgi'
    let s:parseurl_host  = host
    let s:parseurl_board = AL_sscan(argq, 'bbs=\([^/&]\+\)', '/\1')
    let s:parseurl_dat   = AL_sscan(argq, 'key=\(\d\+_\d\+\)', '\1')
    let s:parseurl_range_mode = ''
    let s:parseurl_range_start = ''
    let s:parseurl_range_end = ''
    let mx_list = 'ls=\(\d\+\)'
    let mx_res  = 'res=\(\d\+\)'
    if argq =~ mx_list
      let s:parseurl_range_mode  = s:parseurl_range_mode . 'l'
      let s:parseurl_range_start = AL_sscan(argq, mx_list, '\1')
    elseif argq =~ mx_res
      let s:parseurl_range_start = AL_sscan(argq, mx_res, '\1')
      let s:parseurl_range_end	 = s:parseurl_range_start
    else
      " 表示範囲指定
      let s:parseurl_range_start = AL_sscan(argq, 'st=\(\d\+\)', '\1')
      let s:parseurl_range_end   = AL_sscan(argq, 'to=\(\d\+\)', '\1')
      if s:parseurl_range_start != ''
	" 表示範囲指定オプション (r: folding使用, n: 1非表示)
	let s:parseurl_range_mode  = s:parseurl_range_mode . 'r'
      endif
      if argq =~ 'nofirst=true'
	let s:parseurl_range_mode  = s:parseurl_range_mode . 'n'
      endif
    endif
    return 1
  endif
  return 0
endfunction

function! s:ParseURL_isJBBS(url)
  let mx = '^http://\(..\{-\}\)/bbs/read.\%(cgi\|pl\)?BBS=\([^/&]\+\)&KEY=\(\d\+\)\(.*\)'
  if a:url !~ mx
    return 0
  endif

  let s:parseurl_host = AL_sscan(a:url, mx, '\1')
  let s:parseurl_board = AL_sscan(a:url, mx, '/\2')
  let s:parseurl_dat = AL_sscan(a:url, mx, '\3') . '.cgi'

  let s:parseurl_range_mode = ''
  let s:parseurl_range_start = ''
  let s:parseurl_range_end = ''
  let range = AL_sscan(a:url, mx, '\4')
  if range != ''
    let mx_range_start = '&START=\(\d\+\)'
    let mx_range_end = '&END=\(\d\+\)'
    let mx_range_last = '&LAST=\(\d\+\)'
    let mx_range_nofirst = '&NOFIRST=TRUE'
    if range =~ mx_range_start
      let s:parseurl_range_start = AL_sscan(range, mx_range_start, '\1')
    endif
    if range =~ mx_range_end
      let s:parseurl_range_end = AL_sscan(range, mx_range_end, '\1')
    endif
    if s:parseurl_range_start == ''
      let s:parseurl_range_start = 1
    endif
    if s:parseurl_range_end == ''
      let s:parseurl_range_end = '$'
    endif
    let s:parseurl_range_mode = s:parseurl_range_mode . 'r'
    if range =~ mx_range_nofirst
      let s:parseurl_range_mode = s:parseurl_range_mode . 'n'
    endif
    if range =~ mx_range_last
      let s:parseurl_range_mode = s:parseurl_range_mode . 'l'
      let s:parseurl_range_start = AL_sscan(range, mx_range_last, '\1')
    endif
  endif
  return 1
endfunction

function! s:DatCatchup_JBBS(host, board, dat, flags)
  let local = s:GenerateLocalDat(a:host, a:board, a:dat)
  call AL_mkdir(AL_basepath(local))
  let prevsize = getfsize(local)
  let oldarticle = 0
  " 差分取得用のフラグ
  let continued = 0
  if AL_hasflag(a:flags, 'continue') && filereadable(local)
    let continued = 1
    let oldarticle = s:CountLines(local)
  endif

  let newarticle = oldarticle + 1

  if !s:dont_download && !AL_hasflag(a:flags, 'noforce')
    let tmpfile = tempname()
    let bbs = substitute(a:board, '^/', '', '')
    let key = substitute(a:dat, '\.cgi$', '', '')
    " WORKAROUND: まちBBSではread.plを使ったほうが速い。
    let cgi = a:host =~# s:mx_servers_machibbs ? 'read.pl' : 'read.cgi'
    if continued
      let remote = '/bbs/'.cgi.'?BBS='.bbs.'&KEY='.key.'&START='.newarticle.'&NOFIRST=TRUE'
    else
      let remote = '/bbs/'.cgi.'?BBS='.bbs.'&KEY='.key
    endif
    let result = s:HttpDownload(a:host, remote, tmpfile, '')
    let result = s:Convert_JBBSHTML2DAT(local, tmpfile, continued, s:GetHostEncoding(a:host))
    call delete(tmpfile)
    if !result
      " スレが存在しない
      call s:GoBuf_Thread()
      call AL_buffer_clear()
      call setline(1, 'Error: '.s:msg_error_nothread)
      call append('$', 'Error: '.s:msg_error_accesshere)
      call append('$', '')
      call append('$', '  '.s:GenerateThreadURL(a:host, a:board, a:dat))
      let b:host = a:host
      let b:board = a:board
      let b:dat = a:dat
      let b:title = s:prefix_thread
      let b:title_raw = ''
      return 0
    endif
  endif

  call s:GoBuf_Thread()
  let b:datutil_datsize = getfsize(local)
  if AL_hasflag(a:flags, 'ifmodified') && prevsize >= b:datutil_datsize
    return -1
  endif

  call s:UpdateThreadInfo(a:host, a:board, a:dat)
  let b:chalice_local = local
  return newarticle
endfunction

function! s:Convert_JBBSHTML2DAT(datfile, htmlfile, continued, enc)
  " jbbs.net、jbbs.shitaraba.com、machibbs.comのcgiアウトプットを解析。
  " 1レスは<dt>要素から始まる1行で形成されており、下の様な形式（共通）：
  "
  " <dt>1 名前：<b>NAME</b> 投稿日： 2002/05/29(水) 00:48<br><dd>本文 <br><br>
  " ^^^^^^^^^^^^           ^^^^^^^^^                     ^^^^^^^^    ^^^^^^^^^
  "
  " 上の '^' で示した部分を削除、または区切り文字 '<>' に置換することで、2
  " ちゃんのdat形式に変換する。

  call AL_execute('1vsplit ++enc='.a:enc.' '.a:htmlfile)
  if !a:continued
    " 全取得の場合、タイトルを保持しておく
    call search('<title>')
    let title = AL_sscan(getline('.'), '<title>\([^<]*\)</title>', '\1')
  endif
  " リモートホストのアドレス表示機能がある板（まち、JBBSの一部）で、記事中に
  " 挿入される改行を修正。例：
  "
  " <dt>1 名前：<b>NAME</b> 投稿日： 2002/07/12(金) 14:55 [ remote.host.ip ]<br><dd> 本文 <br><br>
  if getline(search('^<dt>') + 1) =~ '^\s*]'
    silent g/^<dt>/join
  endif
  silent v/^<dt>/delete _
  silent %s+^<dt>\d\+\s*名前：\%(<a href="mailto:\([^"]*\)">\)\?\(.\{-\}\)\%(</a>\)\?\s*投稿日：\s*\(.*\)\s*<br>\s*<dd>+\2<>\1<>\3<>+ie
  if getline(1) !~ '^$'
    if a:continued
      silent %s/\s*\(<br>\)\+$/<>/
      call AL_write(a:datfile, 1)
    else
      silent 1s/\s*\(<br>\)\+$/\='<>'.title/
      if line('$') > 1
	silent 2,$s/\s*\(<br>\)\+$/<>/
      endif
      call AL_write(a:datfile)
    endif
  endif
  silent! bwipeout!
  if !filereadable(a:datfile)
    return 0
  else
    return 1
  endif
endfunction

function! s:CreateWriteChunk_JBBS(host, board, key, title, name, mail, message, submitkey, ...)
  " jbbs.net, jbbs.shitaraba.com, machibbs.com用の書き込みデータチャンク作成
  let chunk = ''
  let chunk = chunk . 'submit=' . a:submitkey
  " BBSとKEYはb:write_paramsにより供給されるので、明示的に追加する必要は無い
  if !b:newthread
    "let chunk = chunk . '&KEY=' . b:key
  else
    let chunk = chunk . '&SUBJECT=' . AL_urlencode(a:title)
  endif
  let chunk = chunk . '&NAME=' . AL_urlencode(a:name)
  let chunk = chunk . '&MAIL=' . AL_urlencode(a:mail)
  let chunk = chunk . '&MESSAGE=' . AL_urlencode(a:message)
  "let chunk = chunk . '&BBS=' . b:bbs
  if !b:newthread
    if exists('b:write_params')
      let chunk = chunk . b:write_params
    endif
  else
    let chunk = chunk . '&TIME=' . b:key
  endif
  return chunk
endfunction

"}}}

"------------------------------------------------------------------------------
" AUTHENTICATION FUNCTIONS {{{
" 2ch認証関連

let s:sessionid = ''
let s:last_loginid = ''
let s:last_password = ''

if s:debug
  function! ChaliceDebugLogin()
    call AL_echokv('DOLIB_get_useragent(s:sessionid)', DOLIB_get_useragent(s:sessionid))
    call AL_echokv('DOLIB_get_sessionid(s:sessionid)', DOLIB_get_sessionid(s:sessionid))
    call AL_echon(' '.strlen(DOLIB_get_sessionid(s:sessionid)), 'WarningMsg')
    call AL_echokv('DOLIB_get_logintime(s:sessionid)', DOLIB_get_logintime(s:sessionid))
    call AL_echokv('s:last_loginid', s:last_loginid)
    call AL_echokv('s:last_password', s:last_password)
    if exists('g:chalice_lastchunk')
      call AL_echokv('g:chalice_lastchunk', g:chalice_lastchunk)
    endif
    if exists('s:last_downloadcommand')
      call AL_echokv('s:last_downloadcommand', s:last_downloadcommand)
    endif
    if exists('s:getofflawdat')
      call AL_echokv('s:getofflawdat', s:getofflawdat)
    endif
  endfunction

  function! ChaliceEnsureLogin()
    call s:EnsureLogin()
  endfunction

  function! ChaliceForceLogin()
    call s:EnsureLogin('force')
  endfunction

  function! ChaliceGetOfflaw(host, board, dat)
    return s:GetOfflawDat(a:host, a:board, a:dat, 'offlaw.txt')
  endfunction
endif

function! s:GetUserAgent()
  call s:EnsureLogin()
  let useragent = DOLIB_get_useragent(s:sessionid)
  if useragent.'X' !=# 'X'
    return useragent
  else
    return 'Monazilla/1.00 (Chalice/'.s:version.')'
  endif
endfunction

function! s:AddSidToChunk(chunk)
  call s:EnsureLogin()
  let sid = DOLIB_get_sessionid(s:sessionid)
  if sid.'X' !=# 'X'
    return a:chunk . '&sid='.AL_urlencode(sid)
  else
    return a:chunk
  endif
endfunction

function! s:GenerateRemoteOfflaw(host, board, dat)
  call s:EnsureLogin()
  let sid = DOLIB_get_sessionid(s:sessionid)
  let board = substitute(a:board, '^/', '', '')
  let dat = substitute(a:dat, '.dat$', '', '')
  if sid.'X' !=# 'X'
    return '/test/offlaw.cgi/'.board.'/'.dat.'/?raw=0.0&sid='.AL_urlencode(sid)
  else
    return ''
  endif
endfunction

function! s:ResetSession()
  let s:sessionid = ''
  let s:last_loginid = ''
  let s:last_password = ''
  return 0
endfunction

function! s:EnsureLogin(...)
  let flags = a:0 > 0 ? a:1 : ''
  if !exists('g:chalice_loginid') || g:chalice_loginid.'X' ==# 'X' || !exists('g:chalice_password') || g:chalice_password.'X' ==# 'X'
    return s:ResetSession()
  endif
  " 既にログインできているかのチェック
  if !AL_hasflag(flags, 'force') && !DOLIB_isexpired(s:sessionid) && s:last_loginid ==# g:chalice_loginid && s:last_password ==# g:chalice_password
    return 1
  endif
  " ログイン実行
  call s:Redraw('force')
  call AL_echo(s:msg_wait_login, 'WarningMsg')
  let s:sessionid = DOLIB_login(g:chalice_loginid, g:chalice_password, 'Chalice/'.s:version, 'curlpath='.s:cmd_curl)
  if s:sessionid.'X' !=# 'X'
    let s:last_loginid = g:chalice_loginid
    let s:last_password = g:chalice_password
    return 1
  else
    return 0
  endif
endfunction

function! s:GetOfflawDat(host, board, dat, local)
  if s:debug
    let s:getofflawdat = 'host='.a:host .' board='.a:board .' dat='.a:dat .' local='.a:local
  endif
  let remote = s:GenerateRemoteOfflaw(a:host, a:board, a:dat)
  if remote.'X' ==# 'X'
    " Can't login
    return 0
  endif
  " Download file
  let result = s:HttpDownload(a:host, remote, a:local, '')
  if !filereadable(a:local)
    return 0
  endif
  call AL_execute('1vsplit ++enc= ++bad=keep '.a:local)
  let result = getline(1)
  normal! gg"_dd
  call AL_write()
  silent! bwipeout!
  if result =~# '^+OK'
    return 1
  else
    call delete(a:local)
    return 0
  endif
endfunction

"}}}

"------------------------------------------------------------------------------
" COMMAND REGISTER {{{
" コマンド登録ルーチン
"   動的に登録可能なコマンドは動的に登録する
"

function! s:CommandRegister()
  command! ChaliceQuit			call <SID>ChaliceClose('')
  command! ChaliceQuitAll		call <SID>ChaliceClose('all')
  command! ChaliceGoBoardList		call <SID>GoBuf_BoardList()
  command! ChaliceGoThreadList		call <SID>GoBuf_ThreadList()
  command! ChaliceGoThread		call <SID>GoBuf_Thread()
  command! -nargs=1 ChaliceGoArticle	call <SID>GoThread_Article(<q-args>)
  command! -nargs=1 Article		call <SID>GoThread_Article(<q-args>)
  command! -nargs=? ChaliceOpenBoard	call <SID>OpenBoard(<f-args>)
  command! -nargs=? ChaliceOpenThread	call <SID>OpenThread(<f-args>)
  command! ChaliceHandleJump		call <SID>HandleJump('internal')
  command! ChaliceHandleJumpExt		call <SID>HandleJump('external')
  command! ChaliceReloadBoardList	call <SID>UpdateBoardList(1)
  command! -nargs=1 ChaliceReloadThreadList	call <SID>UpdateBoard('', '', '', <q-args>)
  command! ChaliceReloadThread		call <SID>UpdateThread('', '', '', '', 'ignorecache,force')
  command! ChaliceReloadThreadInc	call <SID>UpdateThread('', '', '', '', 'continue,force')
  command! -nargs=1 ChaliceReformat	call <SID>Reformat(<q-args>)
  command! ChaliceDoWrite		call <SID>DoWriteBuffer('')
  command! -nargs=? ChaliceWrite	call <SID>OpenWriteBuffer(<f-args>)
  command! -nargs=1 ChaliceHandleURL	call <SID>HandleURL(<q-args>, 'internal')
  command! -nargs=1 ChaliceBookmarkToggle	call <SID>ToggleBookmark(<q-args>)
  command! -nargs=1 ChaliceBookmarkAdd	call <SID>Thread2Bookmark(<q-args>)
  command! ChaliceJumplist		call <SID>JumplistDump()
  command! ChaliceJumplistNext		call <SID>DoHistoryJump('next')
  command! ChaliceJumplistPrev		call <SID>DoHistoryJump('prev')
  command! ChaliceDeleteThreadDat	call <SID>DeleteThreadDat()
  command! ChaliceAboneThreadDat	call <SID>AboneThreadDat()
  command! ChaliceToggleNetlineStatus	call <SID>ToggleNetlineState()
  command! -nargs=* ChalicePreview	call <SID>OpenPreview(<q-args>)
  command! ChalicePreviewClose		call <SID>ClosePreview()
  command! ChalicePreviewToggle		call <SID>TogglePreview()
  command! -nargs=* ChaliceCruise	call <SID>Cruise(<q-args>)
  command! -nargs=* ChaliceShowNum	call <SID>ShowNumberOfArticle(<q-args>)
  command! -nargs=* ChaliceCheckThread	call <SID>CheckThreadUpdate(<q-args>)
  command! -nargs=* Chalice2HTML	call <SID>ShowWithHtml(<f-args>)
  command! ChaliceAdjWinsize		call <SID>AdjustWindowSizeDefault()
  if s:debug || !s:datdir_enabled == 0
    command! ChaliceDatdirOn		call <SID>DatdirOn()
  endif
  delcommand Chalice
endfunction

function! s:CommandUnregister()
  command! Chalice			call <SID>ChaliceOpen()
  delcommand ChaliceQuit
  delcommand ChaliceQuitAll
  delcommand ChaliceGoBoardList
  delcommand ChaliceGoThreadList
  delcommand ChaliceGoThread
  delcommand ChaliceGoArticle
  delcommand Article
  delcommand ChaliceOpenBoard
  delcommand ChaliceOpenThread
  delcommand ChaliceHandleJump
  delcommand ChaliceHandleJumpExt
  delcommand ChaliceReloadBoardList
  delcommand ChaliceReloadThreadList
  delcommand ChaliceReloadThread
  delcommand ChaliceReloadThreadInc
  delcommand ChaliceReformat
  delcommand ChaliceDoWrite
  delcommand ChaliceWrite
  delcommand ChaliceHandleURL
  delcommand ChaliceBookmarkToggle
  delcommand ChaliceBookmarkAdd
  delcommand ChaliceJumplist
  delcommand ChaliceJumplistNext
  delcommand ChaliceJumplistPrev
  delcommand ChaliceDeleteThreadDat
  delcommand ChaliceAboneThreadDat
  delcommand ChaliceToggleNetlineStatus
  delcommand ChalicePreview
  delcommand ChalicePreviewClose
  delcommand ChalicePreviewToggle
  delcommand ChaliceCruise
  delcommand ChaliceShowNum
  delcommand ChaliceCheckThread
  delcommand Chalice2HTML
  delcommand ChaliceAdjWinsize
  if exists(':ChaliceDatdirOn')
    delcommand ChaliceDatdirOn
  endif
endfunction

" 起動コマンドの設定
command! Chalice			call <SID>ChaliceOpen()

"}}}
