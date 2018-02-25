""" General Settings

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
autocmd Filetype markdown,rmd inoremap ;h ====<Space><++><Esc>F=hi
autocmd Filetype markdown,rmd inoremap ;i ![](<++>)<++><Esc>F[a
autocmd Filetype markdown,rmd inoremap ;a [](<++>)<++><Esc>F[a
autocmd Filetype markdown,rmd inoremap ;1 #<Space><Enter><++><Esc>kA
autocmd Filetype markdown,rmd inoremap ;2 ##<Space><Enter><++><Esc>kA
autocmd Filetype markdown,rmd inoremap ;3 ###<Space><Enter><++><Esc>kA
autocmd Filetype rmd map <F5> :!echo<space>"require(rmarkdown);<space>render('<c-r>%')"<space>\|<space>R<space>--vanilla<enter>
autocmd Filetype rmd inoremap ;r ```{r}<CR>```<CR><CR><esc>2kO
autocmd Filetype rmd inoremap ;p ```{python}<CR>```<CR><CR><esc>2kO

" Latex
autocmd FileType tex,rmd inoremap ;m $$<Space><++><Esc>2T$i
autocmd FileType tex,rmd inoremap ;M $$$$<Enter><Enter><++><Esc>2k$hi
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

Plug 'itchyny/calendar.vim'
Plug 'potatoesmaster/i3-vim-syntax'
Plug 'dag/vim-fish'
Plug 'cespare/vim-toml'

Plug 'zhou13/vim-easyescape'
let g:easyescape_chars = { "j": 1, "k": 1 }
let g:easyescape_timeout = 100
cnoremap jk <ESC>
cnoremap kj <ESC>

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

Plug 'rust-lang/rust.vim'

Plug 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1

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

	Plug 'sebastianmarkow/deoplete-rust'
	if executable('racer')
		let g:deoplete#sources#rust#racer_binary = systemlist('which racer')[0]
	endif
	if executable('rustc')
		" if src installed via rustup, we can get it by running 
		" rustc --print sysroot then appending the rest of the path
		let rustc_root = systemlist('rustc --print sysroot')[0]
		let rustc_src_dir = rustc_root . '/lib/rustlib/src/rust/src'
		if isdirectory(rustc_src_dir)
			let g:deoplete#sources#rust#rust_source_path = rustc_src_dir
		endif
	endif

endif

call plug#end()

""" Statusline

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=%#LineNr#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

""" Calendar

let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

