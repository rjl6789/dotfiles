"
" vimrc - universal for linux, windows, msys, cygwin
"
"-----------------------------------------
" Platform specific core options
"-----------------------------------------
if has('mac')
	echo 'mac'
elseif has('win32') || has('win64')
	source $VIMRUNTIME/vimrc_example.vim
	source $VIMRUNTIME/mswin.vim
	behave mswin
	" sourcing the mswin.vim file adds good stuff like ctrl-c for copy but messes up ctrl-f and ctrl-h keys - put these back to normal also put back increment number (ctrl-a) and decrement (ctrl-x) keys
	unmap <C-F>
	unmap <C-H>
	unmap <C-A>
	unmap <C-X>
	" settings for temporary files
	set nobackup
	set noundofile
	set swapfile
	set dir=~/vimswap
	set encoding=utf-8
	scriptencoding utf8
	set guifont=DejaVu_Sans_Mono_for_Powerline:h12:cANSI
elseif has("win32unix")
	set term=xterm-256color
	set encoding=utf-8
	scriptencoding utf8
	"echo 'running on msys/cygwin'
elseif has('unix') && !has("win32unix")
	if filereadable(expand("/usr/share/vim/vimfiles/archlinux.vim"))
	     runtime! archlinux.vim
	endif
else
	echo 'something else'
endif

"-----------------------------------------
" ------ leader mapping ------
"-----------------------------------------
let g:mapleader = "\<Space>"
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
	if v:version > 800
		Plug 'neoclide/coc.nvim', {'branch': 'release'}
	endif
	"-----------------------------------------
	" Platform specific plugins
	"-----------------------------------------
	if has('win32') || has('win64') || has("win32unix")
		Plug 'ctrlpvim/ctrlp.vim'
	elseif has('unix') && !has("win32unix")
		if executable('fzf')
			Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
			Plug 'junegunn/fzf.vim'
			nnoremap <C-p> :Files<cr>
			" Pass an empty option dictionary if the screen is narrow
			command! -bang -nargs=? -complete=dir Files
				\ call fzf#vim#files(<q-args>, &columns > 80 ? fzf#vim#with_preview() : {}, <bang>0)
			" note: in .profile have set FZF_DEFAULT_COMMAND
			" rg --files --hidden --follow --color=never --no-ignore --smart-case --no-ignore-vcs --glob "!.git/*"
		else
			Plug 'ctrlpvim/ctrlp.vim'
		endif
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

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_show_hidden = 1
let g:ctrlp_match_window = 'min:4,max:10,results=100'
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40

" nerdtree
map <C-n> :NERDTreeToggle<CR>

" coc.nvim
if v:version > 800
	source $HOME/.cocrc.vim
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

"
"-----------------------------------------
" Platform specific options
"-----------------------------------------
if has('win32') || has('win64') || has("win32unix")
	if executable('rg')
		set grepprg=rg\ --color=never
		let g:ctrlp_user_command = 'rg --files --hidden --follow --color=never --no-ignore --smart-case --no-ignore-vcs --no-messages --glob "!.git/*"'
		let g:ctrlp_use_caching = 0
	else
		let g:ctrlp_clear_cache_on_exit = 0
	endif	
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
let g:gruvbox_contrast_dark = 'soft'
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
set clipboard^=unnamed,unnamedplus

noremap <silent> <Leader>hh :set hlsearch! hlsearch?<CR>
hi Search cterm=NONE ctermfg=White ctermbg=Cyan

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
nnoremap <silent> <Backspace> <C-^>
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
