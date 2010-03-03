このリポジトリには他の方の書いたスクリプトやVimプラグインなどが含まれています。
一応本人の情報は載せてあるのですが
(例えばライセンスが書かれていれば何もせず
ライセンスが書かれていないスクリプトにもURL元を追記するなど)
もし問題がある場合はtyru.exe@gmail.comまでご連絡ください。

This repository contains other person's scripts.
So please inform me if there is any problem
by email(tyru.exe@gmail.com), or github Issues, and so on.



# movein.sh, send_config
このディレクトリはmovein.sh用のディレクトリです。
またmovein.shはもともとオライリーから出ている「LINUXサーバHACKS」という本で紹介されていたものにいくつか手を加えたものです。
このスクリプトはsshでログインできるマシンに対して設定を素早くインストールするというものです。
なぜこのスクリプトはこのリポジトリのルートディレクトリをそのままコピーするようになっていないかというと、
.gitディレクトリやsync-dotfiles、README.mdなどのファイルをコピーさせないためとか、
ログイン先にはインストールする設定はセキュリティあるいはプライバシー等の意味でも自分で選びたいからだとか、
あとログイン先が下手に弄っていい環境ばかりとは限らないかも、とか。
でもそれだったらそもそもインストールしようと思わないよね。
