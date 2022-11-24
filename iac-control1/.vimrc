syntax on
autocmd FileType yaml setlocal sw=2 ts=2 expandtab autoindent

au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif
