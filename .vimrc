" Last update: 28.03.2020 20:05
" ============ vim-plug settings ============
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'lifepillar/vim-mucomplete'
Plug 'davidhalter/jedi-vim'
Plug 'shawncplus/phpcomplete.vim'
Plug 'Rip-Rip/clang_complete'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'}
" Plug 'artur-shaik/vim-javacomplete2'

Plug 'jlanzarotta/bufexplorer'

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Initialize plugin system
call plug#end()

filetype plugin indent on

if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

set completeopt-=preview
set completeopt+=menu,menuone,noinsert
set shortmess+=c

augroup OmniCompletionSetup
	autocmd!
	autocmd FileType c,cpp 			set omnifunc=ClangComplete#Complete
	autocmd FileType php 			set omnifunc=phpcomplete#CompletePHP
	autocmd FileType python 		set omnifunc=jedi#completions
	autocmd FileType ruby,eruby 		set omnifunc=rubycomplete#Complete
	autocmd FileType javascript 		set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html 			set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css 			set omnifunc=csscomplete#CompleteCSS
	autocmd FileType xml 			set omnifunc=xmlcomplete#CompleteTags
	autocmd FileType go 			set omnifunc=gocomplete#Complete
	autocmd FileType java 			set omnifunc=javacomplete#Complete
augroup END

" provide Clang library path for clang_complete
if g:os == "Darwin"
    let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
elseif g:os == "Linux"
    let g:clang_library_path='/usr/lib/libclang.so'
endif

" enable MUcomplete on startup
let g:mucomplete#enable_auto_at_startup = 1

" set MUcomplete options
let g:mucomplete#chains = {}
let g:mucomplete#chains.default = ['path', 'omni', 'keyn', 'dict']
let g:mucomplete#chains.vim = ['path', 'cmd', 'keyn']

" Auto commands
au BufRead,BufNewFile {*.md,*.mkd,*.markdown} 			set ft=markdown
au BufRead,BufNewFile {COMMIT_EDITMSG} 				set ft=gitcommit
au BufNewFile,BufReadPost *.go 					set ft=go
au BufRead,BufNewFile {*.gplot,*.gp,*.gpi,*.gnuplot,*.plt}      set ft=gnuplot

au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif " restore position in file

set shiftwidth=4
set smartindent

au FileType crontab,fstab,make 			set noexpandtab tabstop=8 shiftwidth=8

" File-type detection and language-specific settings
augroup python
	autocmd BufReadPre,FileReadPre 		*.py set tabstop=4
	autocmd BufReadPre,FileReadPre 		*.py set expandtab
augroup END

augroup ruby
	autocmd BufReadPre,FileReadPre 		*.rb set tabstop=2
	autocmd BufReadPre,FileReadPre 		*.rb set expandtab
augroup END

augroup php
	autocmd BufReadPre,FileReadPre 		*.php set tabstop=4
	autocmd BufReadPre,FileReadPre 		*.php set expandtab
augroup END

augroup java
	autocmd BufReadPre,FileReadPre 		*.java set tabstop=4
	autocmd BufReadPre,FileReadPre 		*.java set expandtab
augroup END

augroup html
	autocmd BufReadPre,FileReadPre 		*.html,*.htm set tabstop=4
	autocmd BufReadPre,FileReadPre 		*.html,*.htm set expandtab
augroup END

augroup css
	autocmd BufReadPre,FileReadPre 		*.css set tabstop=4
	autocmd BufReadPre,FileReadPre 		*.css set expandtab
augroup END

" ============ NerdTree settings ============
" show current file in the file tree
nnoremap <silent> <Leader>u :NERDTreeFind<CR> 
" autoload by default
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" close after opening a file
let NERDTreeQuitOnOpen = 1
" q closes Vim if NerdTree is the last remaining window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeShowGitStatus = 1
let g:NERDTreeUpdateOnWrite = 1

" ============ Misc settings ============
set nocompatible " turn off the vi compatibility mode
set backspace=indent,eol,start " allow backspacing over everything
set number " enable line numbers
set relativenumber " enable relative line numbers
set numberwidth=6 " set the width of the gutter
set noruler " show the cursor position
set title " show buffer name in the terminal title bar
set showcmd " show incomplete commands
" No. of lines shown before/after the current line when scrolling
set scrolloff=5
set mouse=a " enable mouse
set keymodel=startsel,stopsel " GUI-like behaviour for text selection
set clipboard=unnamed " use system clipboard
" colorscheme flattened_dark " sane colours for Solarized-light
set encoding=utf8
set hidden " allow abandoning unsaved buffers
" disable swapping (all of my computers have at least 8GB of RAM and can
" handle any amount of Vim buffers)
set noswapfile
set visualbell " silence, bitch!
set pastetoggle= " keep indentation when pasting

" highlight Tabs and trailing spaces
" set list
set listchars=tab:>-,trail:⋅,eol:∇

" ============ fold settings ============
set foldenable
set foldmethod=indent
set foldcolumn=3
set foldlevel=1
set foldopen=all " open folds on enter
set foldclose=all " close folds on leave

" word wrap without line breaks ('soft-wrap')
:set wrap
:set linebreak
" don't insert linebreaks in newly entered text
:set textwidth=0
:set wrapmargin=0

" ============ .vimrc settings ============
" autoreload .vimrc on saving
autocmd! bufwritepost $MYVIMRC source $MYVIMRC
" insert last modification date when saving .vimrc
autocmd! bufwritepre $MYVIMRC call setline(1, '" Last update: '.strftime("%d.%m.%Y %H:%M"))

" ============ status line settings ============
" buffer number, file path, file format, encoding, ASCII code, HEX code,
" position, file length (No. of lines)
set statusline=%-10.3n\ %F%m%r%h%w\ [%{&fileformat},%{&fileencoding}\]\ [TYPE=%Y]\ [ASCII=\%03.3b][HEX=\%02.2B]\ %=[POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2 " statusline always visible

" ============ Search settings ============
set ignorecase " case-insensitive search
" if search string contains uppercase characters, use case-sensitive search
set smartcase
" don't highlight search result after search is complete and dismissed
set nohlsearch
set incsearch " incremental search
" use * and # to search for selected text, forward/backward respectively
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" ============ Keyboard Settings ============
let mapleader="," " setting the leader key to something easier to reach than \

set keymap=ru-jcukenmac " use Russian keyboard layout in the Insert mode
set iminsert=0 " use EN by default in the Insert mode
set imsearch=0 " ...and when searching

" use Ctrl+F to switch keyboard layouts within Vim
cmap <silent> <C-F> <C-^>
" really...
imap <silent> <C-F> <C-^><Space><Esc>:call CurrentKeymapHighlight()<cr>a<C-H>
nmap <silent> <C-F> a<C-^><Esc>:call CurrentKeymapHighlight()<cr>
vmap <silent> <C-F> <Esc>a<C-^><Esc>:call CurrentKeymapHighlight()<cr>gv
" F2 to save
nmap <F2> :w<cr>
imap <F2> <Esc>:w<cr>i
vmap <F2> <Esc>:w<cr>i

" fix navigation for softwrapped text
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" quickly toggle NERDTree
nnoremap <leader>nt :NERDTreeToggle<cr>
" list buffers, quickly switch to a buffer by entering its number
" or delete # and enter the file name
nnoremap <leader>bb :buffers<cr>:edit<Space>#
" call BufExplorer
nnoremap <leader>be :BufExplorer<cr>
" leader-n — next buffer
nnoremap <leader>n :bn<cr>
" leader-p — previous buffer
nnoremap <leader>p :bp<cr>
" leader-z as undo
nnoremap <leader>z :u<cr>
" leader-y as redo
nnoremap <leader>y <C-R>
" leader-trs to strip trailing spaces
nnoremap <leader>trs :call RemoveTrailingSpaces()<cr>
" leader-eu to set file encoding to UTF-8
nnoremap <leader>eu :set fileencoding=utf-8<cr>
" leader-f to toggle folding
nnoremap <leader>f zi
" leader-i to toggle highlighting of Tabs, trailing spaces and EOLs
nnoremap <leader>i :set list!<cr>

" Ctrl+D to duplicate the current line
imap <C-d> <Esc>yypi
nmap <C-d> yyp

" ============ custom functions ============

" better indication of the current keyboard layout
function! CurrentKeymapHighlight()
    if &iminsert == 0 " if KB = EN the status bar is green
	hi StatusLine ctermfg=DarkGreen guifg=DarkGreen
    else " otherwise the status bar is red
	hi StatusLine ctermfg=DarkRed guifg=DarkRed
    endif
endfunction
call CurrentKeymapHighlight() " set statusline colour on launch
autocmd WinEnter * :call CurrentKeymapHighlight() " refresh when changing windows

" remove trailing spaces
function! RemoveTrailingSpaces()
   normal! mzHmy
   execute '%s:\s\+$::ge'
   normal! 'yzt`z
endfunction

