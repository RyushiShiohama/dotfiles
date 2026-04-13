" ---- vim-plug bootstrap ----
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ---- plugins ----
call plug#begin('~/.vim/plugged')

" (neocomplete) ※元は has('lua') で Lazy Insert。vim-plugにInsertEnterは無いので常時読み込みに変更
if has('lua')
  Plug 'Shougo/neocomplete.vim'
  Plug 'Shougo/vimproc.vim', { 'do': 'make' }
endif

Plug 'preservim/nerdtree'

" syntastic（重複定義があったので1つに集約）
Plug 'vim-syntastic/syntastic'
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']

" neosnippet + snippets
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" unite / vimfiler（Lazy: コマンド / <Plug>）
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimfiler', {
      \ 'on': ['VimFilerTab','VimFiler','VimFilerExplorer','VimFilerBufferDir'],
      \ 'for': [],
      \ }
" <Plug> マッピングでの遅延読み込み
autocmd VimEnter * call plug#load('vimfiler') | execute ''
" ※ <Plug>(vimfiler_switch) による純粋Lazyは挙動がブレるため必要なら上記で明示ロード

" vimproc（ビルドはOS毎に自動で 'make' を試行）
Plug 'Shougo/vimproc.vim', { 'do': 'make' }

" vimshell（Lazy: コマンド）
Plug 'Shougo/vimshell', { 'on': ['VimShell','VimShellExecute','VimShellInteractive','VimShellTerminal','VimShellPop'] }

" tpope系
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" JS / JSX
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'clausreinke/typescript-tools.vim'

call plug#end()

" ---- general settings ----
set clipboard=unnamed
