""" General Settings

noremap <leader>ev :execute 'e ' . resolve(expand($MYVIMRC))<CR>
set shell=sh

syntax on

set number
set relativenumber

set mouse=a

set tabstop=4
set shiftwidth=4
set softtabstop=0
set cindent

set ignorecase
set smartcase

set nocompatible
filetype plugin on

map <F6> :setlocal spell! spelllang=en_au<CR>

""" Keybinds

" Buffers
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>
:nnoremap <C-d> :bdelete<CR>

" Windows
no <C-h> <C-w>h
no <C-j> <C-w>j
no <C-k> <C-w>k
no <C-l> <C-w>l

inoremap <Space><Space> <Esc>/<++><Enter>"_c4l

" C/C++
autocmd FileType c,cpp inoremap ;m  int<Space>main()<Enter>{<Enter><Tab><Enter>}<Esc>ka
autocmd FileType c,cpp inoremap ;fu (<++>)<Enter>{<Enter><++><Enter>}<Enter><++><Esc>4kI
autocmd FileType c,cpp inoremap ;fc (<++>)<Space>const<Enter>{<Enter><++><Enter>}<Enter><++><Esc>4kI
autocmd FileType c,cpp inoremap ;i  if<Space>()<Enter>{<Enter><++><Enter>}<++><Esc>3k$i
autocmd FileType c,cpp inoremap ;el <Space>else<Enter>{<Enter>}<++><Esc>kA<Enter>
autocmd FileType c,cpp inoremap ;ei <Space>else<Space>if<Space>()<Enter>{<Enter><++><Enter>}<++><Esc>3k$i
autocmd FileType c,cpp inoremap ;w  while<Space>()<Enter>{<Enter><++><Enter>}<Enter><++><Esc>4kf)i
autocmd FileType c,cpp inoremap ;fi for<Space>(;<Space><++>;<Space><++>)<Enter>{<Enter><++><Enter>}<Enter><++><Esc>4kf(a
autocmd FileType c,cpp inoremap ;fe for<Space>(<Space>:<Space><++>)<Enter>{<Enter><++><Enter>}<Enter><++><Esc>4kf(a
autocmd FileType c,cpp inoremap ;sw switch<Space>()<Enter>{<Enter><++><Enter>}<Enter><++><Esc>4kf)i
autocmd FileType c,cpp inoremap ;ca case<Space><++>:<Space><++><Space>break;<++><Esc>3F<c4l
autocmd FileType c,cpp inoremap ;d  default:<Space><++><Space>break;<++><Esc>2F<c4l
autocmd FileType c,cpp inoremap ;st struct<Space><Enter>{<Enter><++><Enter>}<++>;<Enter><++><Esc>4kA
autocmd FileType c,cpp inoremap ;ts typedef<Space>struct<Space><Enter>{<Enter><++><Enter>}<++>;<Enter><++><Esc>4kA
autocmd FileType c,cpp inoremap ;cl class<Space><Enter>{<Enter><Backspace>public:<Enter><++><Enter><Backspace><Backspace>private:<Enter><Backspace><++><Enter>};<Enter><++><Esc>7kA
autocmd FileType c,cpp inoremap ;p  #pragma<Space>once<Enter>

" Rust
autocmd FileType rust inoremap ;m  fn<Space>main()<Enter>{<Enter><Enter>}<Esc>kA<Tab>

" Markdown
autocmd Filetype markdown,rmd inoremap ;b ****<++><Esc>F*hi
autocmd Filetype markdown,rmd inoremap ;s ~~~~<++><Esc>F~hi
autocmd Filetype markdown,rmd inoremap ;e **<++><Esc>F*i
autocmd Filetype markdown,rmd inoremap ;c ``<++><Esc>F`i
autocmd Filetype markdown,rmd inoremap ;h ====<Space><++><Esc>F=hi
autocmd Filetype markdown,rmd inoremap ;i ![](<++>)<++><Esc>F[a
autocmd Filetype markdown,rmd inoremap ;a [](<++>)<++><Esc>F[a
autocmd Filetype markdown,rmd inoremap ;1 #<Space><Enter><++><Esc>kA
autocmd Filetype markdown,rmd inoremap ;2 ##<Space><Enter><++><Esc>kA
autocmd Filetype markdown,rmd inoremap ;3 ###<Space><Enter><++><Esc>kA
autocmd Filetype markdown map <F5> :!pandoc<space>"<C-r>%"<space>-o<space>"<C-r>%.pdf"<Enter><Enter>
autocmd Filetype rmd map <F5> :!echo<space>"require(rmarkdown);<space>render('<C-r>%')"<space>\|<space>R<space>--vanilla<enter>
autocmd Filetype rmd inoremap ;r ```{r}<CR>```<CR><CR><esc>2kO
autocmd Filetype rmd inoremap ;p ```{python}<CR>```<CR><CR><esc>2kO

" Latex
autocmd FileType tex,rmd,markdown inoremap ;m $$<Space><++><Esc>2T$i
autocmd FileType tex,rmd,markdown inoremap ;M $$$$<Enter><Enter><++><Esc>2k$hi
autocmd FileType tex,rmd inoremap ;ol \begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><++><Esc>3kA\item<Space>
autocmd FileType tex,rmd inoremap ;ul \begin{itemize}<Enter><Enter>\end{itemize}<Enter><Enter><++><Esc>3kA\item<Space>
autocmd FileType tex,rmd inoremap ;dl \begin{description}<Enter><Enter>\end{description}<Enter><Enter><++><Esc>3kA\item<Space>
autocmd FileType tex,rmd inoremap ;li <Enter>\item<Space>
autocmd FileType tex,rmd inoremap ;re \ref{}<Space><++><Esc>T{i

" Copy/paste

vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

""" Plugins

" Install vim-plug if it doesn't exist
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin("~/.vim/plugged")

Plug 'dylanaraps/wal.vim'
set rtp+=~/.vim/plugged/wal.vim
"colorscheme wal

Plug 'itchyny/calendar.vim'
Plug 'potatoesmaster/i3-vim-syntax'
Plug 'dag/vim-fish'
Plug 'cespare/vim-toml'
Plug 'tikhomirov/vim-glsl'

Plug 'zhou13/vim-easyescape'
let g:easyescape_chars = { "n": 1, "e": 1 }
let g:easyescape_timeout = 50
"cnoremap ne <ESC>
"cnoremap en <ESC>

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_math = 1

Plug 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_rust_checkers = ['cargo']
function! SyntasticCheckHook(errors)
	if !empty(a:errors)
		let g:syntastic_loc_list_height = min([len(a:errors), 10])
	endif
endfunction

"Plug 'rust-lang/rust.vim'

Plug 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1

Plug 'scrooloose/nerdcommenter'

Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
" Open NerdTree if no file is specified when opening vim
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open NerdTree when a vim starts up on opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" Close vim if the only window left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Get rid of the ? thing
let NERDTreeMinimalUI = 1
" Quit when file is opened
let NERDTreeQuitOnOpen = 1
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
"Plug 'Xuyuanp/nerdtree-git-plugin'
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "",
    \ "Staged"    : "",
    \ "Untracked" : "",
    \ "Renamed"   : "",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '',
    \ "Unknown"   : "?"
    \ }


Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'bling/vim-airline'
let g:airline_powerline_fonts = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#branch#format = 'CustomBranchName'
function! CustomBranchName(name)
	return '[' . a:name . ']'
endfunction
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#wordcount#filetypes = '\vtext|markdown|rmd'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='deus'

if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
	inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
	inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
	autocmd CompleteDone * silent! pclose!
	set completeopt+=noinsert
	let g:deoplete#enable_at_startup = 1

	Plug 'zchee/deoplete-clang'
	let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
	let g:deoplete#sources#clang#clang_header = "/usr/lib/clang/"
	Plug 'zchee/deoplete-jedi'
	Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }

	"Plug 'sebastianmarkow/deoplete-rust'
	"if executable('racer')
	"	let g:deoplete#sources#rust#racer_binary = systemlist('which racer')[0]
	"endif
	"if executable('rustc')
	"	" if src installed via rustup, we can get it by running
	"	" rustc --print sysroot then appending the rest of the path
	"	let rustc_root = systemlist('rustc --print sysroot')[0]
	"	let rustc_src_dir = rustc_root . '/lib/rustlib/src/rust/src'
	"	if isdirectory(rustc_src_dir)
	"		let g:deoplete#sources#rust#rust_source_path = rustc_src_dir
	"	endif
	"endif

	Plug 'autozimu/LanguageClient-neovim', {
		\ 'branch': 'next',
		\ 'do': './install.sh',
		\ }
	" Required for operations modifying multiple buffers like rename.
	set hidden
	let g:LanguageClient_serverCommands = {
		\ 'rust': ['rustup', 'run', 'nightly', 'rls'],
		\ 'javascript': ['javascript-typescript-stdio'],
		\ }

	let g:LanguageClient_diagnosticsDisplay = {
		\ 1: {
        \     "name": "Error",
        \     "texthl": "ALEError",
        \     "signText": "",
        \     "signTexthl": "ALEErrorSign",
        \ },
        \ 2: {
        \     "name": "Warning",
        \     "texthl": "ALEWarning",
        \     "signText": "",
        \     "signTexthl": "ALEWarningSign",
        \ },
        \ 3: {
        \     "name": "Information",
        \     "texthl": "ALEInfo",
        \     "signText": "",
        \     "signTexthl": "ALEInfoSign",
        \ },
        \ 4: {
        \     "name": "Hint",
        \     "texthl": "ALEInfo",
        \     "signText": "",
        \     "signTexthl": "ALEInfoSign",
        \ },
	\ }

	nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
	nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
	nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
	nnoremap <silent> <F3> :call LanguageClient_textDocument_codeAction()<CR>

endif

Plug 'ryanoasis/vim-devicons'
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFolderPatternMatching = 1

call plug#end()

""" Calendar

let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

