"
" vimrc - universal for linux, windows, msys, cygwin
"
" defaults for vim
source ~/.defaults.vim
"-----------------------------------------
" Platform specific core options
"-----------------------------------------
if has('mac')
	echo 'mac'
elseif has('win32') || has('win64')
	source $VIMRUNTIME/mswin.vim
	"if !has('nvim')
	"	source $VIMRUNTIME/vimrc_example.vim
	"endif
	let g:PATHBASE = 'C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;'
	let g:PATHNODEJS = 'C:\Program Files\nodejs;'
	let g:PATHGIT = $USERPROFILE . '\git\bin;'
	let g:PATHGVIM = 'C:\Program Files\Vim\vim82;'
	let g:PATHNVIM = $USERPROFILE . '\Neovim\bin;'
	let g:PATHMINGW64 = 'C:\MinGW\mingw64\bin;'
	let g:PATHLLVM = 'C:\Program Files\LLVM\bin'
	execute "let $PATH = '" . PATHBASE . PATHNODEJS . PATHGIT . PATHGVIM . PATHNVIM . PATHMINGW64 . PATHLLVM . "'"
	" sourcing the mswin.vim file adds good stuff like ctrl-c for copy but messes up ctrl-f and ctrl-h keys - put these back to normal also put back increment number (ctrl-a) and decrement (ctrl-x) keys
	if !has('nvim')
		unmap <C-F>
		unmap <C-H>
	endif
	unmap <C-A>
	unmap <C-X>
	" settings for temporary files
	set nobackup
	set noundofile
	set swapfile
	set dir=~/vimswap
	set encoding=utf-8
	scriptencoding utf8
	if !has('nvim')
		set guifont=DejaVu_Sans_Mono_for_Powerline:h12:cANSI
	end
elseif has("win32unix")
	set term=xterm-256color
	set encoding=utf-8
	scriptencoding utf8
	"echo 'running on msys/cygwin'
elseif has('unix') && !has("win32unix")
	if filereadable(expand("/usr/share/vim/vimfiles/archlinux.vim"))
		runtime! archlinux.vim
	endif
	set mouse=a
else
	echo 'something else'
endif

"-----------------------------------------
" ------ leader mapping ------
"-----------------------------------------
"let g:mapleader = "\<Space>"
let g:mapleader = "\\"
"-----------------------------------------

"-----------------------------------------
" base options
"-----------------------------------------
set cursorline
set lazyredraw
set ignorecase
set smartcase
set backspace=indent,eol,start
" always have status and tab bar
set laststatus=2
set showtabline=2
" colours
set t_Co=256
" syntax
syntax enable
" turn of syntax when diff'ing
if &diff
	syntax off
endif
" turn of graphical tabs in gvim
if has('gui_running')
	set guioptions-=e
endif
" turn of graphical tabs in gvim
if has('gui_running')
	set guioptions-=e
endif

"-----------------------------------------
" Initialize plugin system
" note: plugins don't get activated untill the
" end block.
" ok to apply "settings" though
"-----------------------------------------
call plug#begin('~/.vim/plugged')
     
         " Make sure you use single quotes
	Plug 'scrooloose/nerdtree'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'morhetz/gruvbox'
	Plug 'itchyny/lightline.vim'
	Plug 'mengelbrecht/lightline-bufferline'
	Plug 'shinchu/lightline-gruvbox.vim'
	Plug 'tpope/vim-unimpaired'
	Plug 'ap/vim-css-color'
	if ( v:version > 800 || has ('nvim') ) && !has('win32unix')
		Plug 'neoclide/coc.nvim', {'branch': 'release'}
	endif
	"-----------------------------------------
	" Platform specific plugins
	"-----------------------------------------
	if executable('fzf')
		Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
		Plug 'junegunn/fzf.vim'
	else
		Plug 'ctrlpvim/ctrlp.vim'
	endif

call plug#end()
"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" End of plugin configuration
"-----------------------------------------
" Plugins now activated. Set options that required activation

" ---------------------------------------
" plugin universal config
" ---------------------------------------
"


" nerdtree
map <C-n> :NERDTreeToggle<CR>

" coc.nvim
if ( v:version > 800 || has ('nvim') ) && !has('win32unix')
	source $HOME/.cocrc.vim
	" disable Coc
	autocmd VimEnter * CocDisable
endif

" lightline
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['bufnum'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
      \ }
let g:lightline#bufferline#show_number = 2
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline_gruvbox_style = 'hard_left'

"
"-----------------------------------------
" Platform specific options
"-----------------------------------------
	" (note in msys2/cygwin - vim is a 'unix' app but rg and ag are
	" only available as mingw binaries - they don't play nice)
	" also fzf doesn't support mintty - the default msys2 and cygwin tty -
	" use conemu instead
if executable('fzf') && !has('win32unix')
	if executable('rg')
		let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --color=never --no-ignore --smart-case --no-ignore-vcs --glob "!.git/**"'
	elseif executable('ag') 
		let $FZF_DEFAULT_COMMAND = 'ag -l --nocolor -g ""'
	else
		let $FZF_DEFAULT_COMMAND = 'find %s -type f'
	endif
	let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
	nnoremap <C-p> :Files<cr>
	let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
	" Preview window: Pass an empty option dictionary if the screen is narrow
	if has('win32') || has('win64')
		" preview window too slow if use the nice built in previewer
		command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, &columns > 80 ? {'options': ['--layout=reverse', '--info=inline', '--preview', 'cat {}']} : {}, <bang>0)
	else
		" this command is the default
		" (install 'bat' for syntax highlighting)
		command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, &columns > 80 ? fzf#vim#with_preview() : {}, <bang>0)
	endif
	" Empty value to disable preview window altogether
	" let g:fzf_preview_window = ''
else
	" CtrlP
	if executable('rg') && !has('win32unix')
		set grepprg=rg\ --color=never
		let g:ctrlp_user_command = 'rg --files --hidden --follow --color=never --no-ignore --smart-case --no-ignore-vcs --no-messages --glob "!.git/*"'
		let g:ctrlp_use_caching = 0
	elseif executable('ag') && !has('win32unix')
		set grepprg=ag\ --nogroup\ --nocolor
		let g:ctrlp_user_command = 'ag -l --nocolor -g ""' 
		let g:ctrlp_use_caching = 0
	else
		let g:ctrlp_clear_cache_on_exit = 0
	endif	
	let g:ctrlp_map = '<c-p>'
	let g:ctrlp_cmd = 'CtrlP'
	let g:ctrlp_working_path_mode = 'ra'
	let g:ctrlp_show_hidden = 1
	let g:ctrlp_match_window = 'min:4,max:10,results=100'
	let g:ctrlp_max_files=0
	let g:ctrlp_max_depth=40
endif

"-----------------------------------------
" Colour scheme
"-----------------------------------------
nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>
nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?
let g:gruvbox_contrast_dark = 'medium'
set background=dark    " Setting dark mode
colorscheme gruvbox

"-----------------------------------------
" custom options and binds
"-----------------------------------------
"

"-----------------------------------------
" Initialize plugin system
" note: plugins don't get activated untill the
" end block.
" ok to apply "settings" though
"-----------------------------------------
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'tpope/vim-unimpaired'
Plug 'ap/vim-css-color'
Plug 'vimwiki/vimwiki'
"-----------------------------------------
" Platform specific plugins
"-----------------------------------------
if ( v:version > 800 || has ('nvim') ) && !has('win32unix')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
if executable('fzf')
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
else
	Plug 'ctrlpvim/ctrlp.vim'
endif

call plug#end()
"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" End of plugin configuration
"-----------------------------------------
" Plugins now activated. Set options that required activation

" ---------------------------------------
" plugin universal config
" ---------------------------------------

" vimwiki
au FileType vimwiki setlocal
			\ shiftwidth=4
			\ tabstop=4
			\ noexpandtab
let g:vimwiki_list = [
			\ {'path': '~/Documents/VimWiki/atr.wiki'},
			\ {'path': '~/Documents/VimWiki/personal.wiki'}
			\ ]
" nerdtree
map <C-n> :NERDTreeToggle<CR>


" lightline
let g:lightline = {
			\ 'colorscheme': 'gruvbox',
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
			\ },
			\ 'tabline': {
			\   'left': [ ['buffers'] ],
			\   'right': [ ['bufnum'] ]
			\ },
			\ 'component_expand': {
			\   'buffers': 'lightline#bufferline#buffers'
			\ },
			\ 'component_type': {
			\   'buffers': 'tabsel'
			\ }
			\ }
let g:lightline#bufferline#show_number = 2
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline_gruvbox_style = 'hard_left'

"
"-----------------------------------------
" Platform specific options
"-----------------------------------------
"
" coc.nvim - not in msys or cygwin as horribly slow
" also disable by default
if ( v:version > 800 || has ('nvim') ) && !has('win32unix')
	source $HOME/.cocrc.vim
	" disable Coc
	autocmd VimEnter * CocDisable
endif
" (note in msys2/cygwin - vim is a 'unix' app but rg and ag are
" only available as mingw binaries - they don't play nice)
" also fzf doesn't support mintty - the default msys2 and cygwin tty -
" use conemu instead
if executable('fzf') && !has('win32unix')
	if executable('rg')
		let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --color=never --no-ignore --smart-case --no-ignore-vcs --glob "!.git/**"'
	elseif executable('ag') 
		let $FZF_DEFAULT_COMMAND = 'ag -l --nocolor -g ""'
	else
		let $FZF_DEFAULT_COMMAND = 'find %s -type f'
	endif
	let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
	nnoremap <C-p> :Files<cr>
	let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
	" Preview window: Pass an empty option dictionary if the screen is narrow
	if has('win32') || has('win64')
		" preview window too slow if use the nice built in previewer
		command! -bang -nargs=? -complete=dir Files
					\ call fzf#vim#files(<q-args>, &columns > 80 ? {'options': ['--layout=reverse', '--info=inline', '--preview', 'cat {}']} : {}, <bang>0)
	else
		" this command is the default
		" (install 'bat' for syntax highlighting)
		command! -bang -nargs=? -complete=dir Files
					\ call fzf#vim#files(<q-args>, &columns > 80 ? fzf#vim#with_preview() : {}, <bang>0)
	endif
	" Empty value to disable preview window altogether
	" let g:fzf_preview_window = ''
else
	" CtrlP
	if executable('rg') && !has('win32unix')
		set grepprg=rg\ --color=never
		let g:ctrlp_user_command = 'rg --files --hidden --follow --color=never --no-ignore --smart-case --no-ignore-vcs --no-messages --glob "!.git/*"'
		let g:ctrlp_use_caching = 0
	elseif executable('ag') && !has('win32unix')
		set grepprg=ag\ --nogroup\ --nocolor
		let g:ctrlp_user_command = 'ag -l --nocolor -g ""' 
		let g:ctrlp_use_caching = 0
	else
		let g:ctrlp_clear_cache_on_exit = 0
	endif	
	let g:ctrlp_map = '<c-p>'
	let g:ctrlp_cmd = 'CtrlP'
	let g:ctrlp_working_path_mode = 'ra'
	let g:ctrlp_show_hidden = 1
	let g:ctrlp_match_window = 'min:4,max:10,results=100'
	let g:ctrlp_max_files=0
	let g:ctrlp_max_depth=40
endif

"-----------------------------------------
" Colour scheme
"-----------------------------------------
nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>
nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?
let g:gruvbox_contrast_dark = 'medium'
set background=dark    " Setting dark mode
colorscheme gruvbox

"-----------------------------------------
" custom options and binds
"-----------------------------------------
"

" the vim file explorer
" invoke by Sex (horiz split) or Vex (vert split)
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_winsize = 25
"
" If you don't have a hide list and just want to use gh's:
"
let ghregex='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide=ghregex

" system clipboard (requires +clipboard)
"set clipboard^=unnamed,unnamedplus
set clipboard+=unnamedplus

noremap <silent> <Leader>hh :set hlsearch! hlsearch?<CR>
"hi Search cterm=NONE ctermfg=White ctermbg=Cyan

" change windows with ctrl+(hjkl)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"tab control
nnoremap <silent> <Leader>te :tabnew<CR>
nnoremap <silent> <Leader>tn :tabnext<CR>
nnoremap <silent> <Leader>tf :tabfirst<CR>
nnoremap <silent> <Leader>tp :tabprevious<CR>
"nnoremap <C-t>k :tabr<cr>
"nnoremap <C-t>j :tabl<cr>
"nnoremap <C-t>h :tabp<cr>
"nnoremap <C-t>l :tabn<cr>
nnoremap <silent> <Leader><C-K> :tabr<cr>
nnoremap <silent> <Leader><C-J> :tabl<cr>
nnoremap <silent> <Leader><C-H> :tabp<cr>
nnoremap <silent> <Leader><C-L> :tabn<cr>

"buffer control - use :bd to quit buffer (buffer delete)
nnoremap <silent> <Leader>bn :bn<CR>
nnoremap <silent> <Leader>bf :bf<CR>
nnoremap <silent> <Leader>bp :bp<CR>
nnoremap <silent> \k :brewind<cr>
nnoremap <silent> \j :blast<cr>
nnoremap <silent> \h :bprevious<cr>
nnoremap <silent> \l :bnext<cr>
nnoremap <silent> - :bprevious<cr>
nnoremap <silent> + :bnext<cr>
"nnoremap <silent> <Backspace> <C-^>
nnoremap <silent> bd :bd<cr>
nnoremap <silent> wbd :w <bar> bd<cr>


" toggle line numbers, nn (no number)
nnoremap <silent> <Leader>nn :set number!<CR>

" split the window vertically and horizontally
nnoremap _ <C-W>s<C-W><Down>
nnoremap <Bar> <C-W>v<C-W><Right>

" ------ commands ------

command! D Vexplore
command! Q call <SID>quitbuffer()
command! -nargs=1 B :call <SID>bufferselect("<args>")
command! W execute 'silent w !sudo tee % >/dev/null' | edit!

" ------ basic maps ------

" quit the current buffer and switch to the next
" without this vim will leave you on an empty buffer after quiting the current
function! <SID>quitbuffer() abort
	let l:bf = bufnr('%')
	let l:pb = bufnr('#')
	if buflisted(l:pb)
		buffer #
	else
		bnext
	endif
	if bufnr('%') == l:bf
		new
	endif
	if buflisted(l:bf)
		execute('bdelete! ' . l:bf)
	endif
endfunction

" switch active buffer based on pattern matching
" if more than one match is found then list the matches to choose from
function! <SID>bufferselect(pattern) abort
	let l:bufcount = bufnr('$')
	let l:currbufnr = 1
	let l:nummatches = 0
	let l:matchingbufnr = 0
	" walk the buffer count
	while l:currbufnr <= l:bufcount
		if (bufexists(l:currbufnr))
			let l:currbufname = bufname(l:currbufnr)
			if (match(l:currbufname, a:pattern) > -1)
				echo l:currbufnr.': '.bufname(l:currbufnr)
				let l:nummatches += 1
				let l:matchingbufnr = l:currbufnr
			endif
		endif
		let l:currbufnr += 1
	endwhile

	" only one match
	if (l:nummatches == 1)
		execute ':buffer '.l:matchingbufnr
	elseif (l:nummatches > 1)
		" more than one match
		let l:desiredbufnr = input('Enter buffer number: ')
		if (strlen(l:desiredbufnr) != 0)
			execute ':buffer '.l:desiredbufnr
		endif
	else
		echoerr 'No matching buffers'
	endif
endfunction
