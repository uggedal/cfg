" vim: filetype=vim

" general
set nocompatible
set undofile
set history=100

set undodir=~/.vim/tmp/undo//,/tmp//
set directory=~/.vim/tmp/swap//,/tmp//

set autoread

set ruler
set showcmd
set number

set shortmess+=I


" syntax
syntax enable
set synmaxcol=200
filetype plugin indent on

let g:is_posix=1
let b:ruby_no_expensive=1

let &t_ut=''


" ui
set backspace=indent,eol,start

set complete-=i

set incsearch
set hlsearch
set smartcase
set gdefault

set noerrorbells
set novisualbell
set t_vb=

set wildmode=longest,list,full

set path=.,**

set scrolloff=3

set display+=lastline

set virtualedit+=block

autocmd InsertLeave * set nocursorline
autocmd InsertEnter * set cursorline
nnoremap K <nop>

set notimeout
set ttimeout
set ttimeoutlen=10

set hidden

set nrformats-=octal

autocmd QuickFixCmdPost *grep* cwindow


" keybinding
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nnoremap gT <nop>
nnoremap gt <nop>

nnoremap j gj
nnoremap k gk

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv


" text
set wrap
set colorcolumn=80
set linebreak
silent! set breakindent
set autoindent

autocmd BufNewFile,BufRead * highlight trail_space ctermbg=1
autocmd InsertEnter * highlight trail_space ctermbg=NONE
autocmd InsertLeave * highlight trail_space ctermbg=1
autocmd BufNewFile,BufRead * match trail_space /\s\+$/

set noexpandtab
set smarttab
set softtabstop=0
set tabstop=8
set shiftwidth=8

set foldmethod=indent
set foldnestmax=3
set nofoldenable

set formatoptions+=j

" languages
function Spaces(n)
	setl expandtab
	exec 'setl softtabstop='.a:n
	exec 'setl tabstop='.a:n
	exec 'setl shiftwidth='.a:n
	setl shiftround
endfunction

command! Spaces :call Spaces(4)

au FileType python call Spaces(4)
au FileType yaml call Spaces(2)
au BufRead,BufNewFile *.nix call Spaces(2)


" leader
let mapleader = ","

nnoremap <leader>b :ls<CR>
nnoremap <leader>p :bp<CR>
nnoremap <leader>n :bn<CR>
nnoremap <leader>d :bd<CR>
nnoremap <leader>g :b#<CR>
nnoremap <leader>1 :1b<CR>
nnoremap <leader>2 :2b<CR>
nnoremap <leader>3 :3b<CR>
nnoremap <leader>4 :4b<CR>
nnoremap <leader>5 :5b<CR>
nnoremap <leader>6 :6b<CR>
nnoremap <leader>7 :7b<CR>
nnoremap <leader>8 :8b<CR>
nnoremap <leader>9 :9b<CR>
nnoremap <leader>0 :10b<CR>

nnoremap <leader>i :set invpaste<CR>

nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

nnoremap <leader>c :noh<CR>

" intentional trailing space:
nnoremap <leader>f :find 
nnoremap <leader>g :silent! grep -r  .<Left><Left>
nnoremap <leader>G :silent! grep -r "\b<C-R><C-W>\b" .<CR>

nnoremap <leader>s :GitGutterToggle<CR>

" plugins
call plug#begin('~/.vim/plugged')

	Plug 'robertmeta/nofrils'
	Plug 'ap/vim-buftabline'
	Plug 'tpope/vim-commentary'
	Plug 'ctrlpvim/ctrlp.vim'

call plug#end()

colorscheme nofrils-acme

let g:netrw_liststyle=3
let g:netrw_banner=0
nmap - :E %:h/<CR>

let g:buftabline_show=1
let g:buftabline_numbers=1
let g:buftabline_indicators=1

let g:pyindent_open_paren = '&sw'
let g:pyindent_continue = '&sw'

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files', 'find %s -type f']
let g:ctrlp_line_prefix = ''

let g:gitgutter_enabled = 0

function! s:goyo_enter()
	let g:buftabline_show=0
	call buftabline#update(0)
	set showtabline=0
endfunction

function! s:goyo_leave()
	let g:buftabline_show=1
	call buftabline#update(0)
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

augroup vimrcEx
	au!
	" always jump to the last known cursor position
	autocmd BufReadPost *
	\ if &filetype !~ 'commit\c' &&
	\     line("'\"") > 0 && line("'\"") <= line("$") |
	\ 	exe "normal g`\"" |
	\ endif
augroup END