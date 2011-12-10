use IO::File;
+{
    directory => "dotfiles",
    files => [do {
        my $FH = IO::File->new('dotfiles.lst') or die "dotfiles.lst: $!";
        map { chomp; $_ } <$FH>;
    }],
    os_files => {map {
        # MS Windows-specific filenames.
        $_ => {
            '.vimperator' => 'vimperator',
            '.vimperatorrc' => '_vimperatorrc',
            '.vim' => 'vimfiles',
        }
    } qw(MSWin32 cygwin)},
    ignore_files => [qw(
        .vim/backup
        .vim/.netrwhist
        .vim/.VimballRecord
        .vim/info
        .vim/record
        .vim/sessions
        .vim/swap
        .vimperator/info
    )],
}
