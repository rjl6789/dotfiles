"
" vimrc - rob livesey
"
"
" defaults

if has('mac')
     echo 'mac'
elseif has('win32') || has('win64')
     source $VIMRUNTIME/vimrc_example.vim
     source $VIMRUNTIME/mswin.vim
     behave mswin
     "
     " sourcing the mswin.vim file adds good stuff like ctrl-c for copy
     " but messes up ctrl-f and ctrl-h keys - put these back to normal
     " also put back increment number (ctrl-a) and decrement (ctrl-x) keys
     "
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
     set runtimepath^=~/vimfiles/bundle/vim-airline
     set guifont=DejaVu_Sans_Mono_for_Powerline:h14:cANSI
     colorscheme desert
     scriptencoding utf8
     "set guifont=Source_Code_Pro_Light:h16:cANSI
     let g:airline#extensions#tabline#formatter = 'unique_tail'
elseif has("win32unix")
     set term=xterm-256color
     set runtimepath^=~/.vim/bundle/vim-airline
     set encoding=utf-8
     scriptencoding utf8
elseif has('unix') && !has("win32unix")
     if filereadable(expand("/usr/share/vim/vimfiles/archlinux.vim"))
	     runtime! archlinux.vim
     endif
     " Specify a directory for plugins
     " - For Neovim: stdpath('data') . '/plugged'
     " - Avoid using standard Vim directory names like 'plugin'
     call plug#begin('~/.vim/plugged')
     
         " Make sure you use single quotes
         
         " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
         Plug 'junegunn/vim-easy-align'
         
         " On-demand loading
         "Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
         Plug 'scrooloose/nerdtree'
         Plug 'Xuyuanp/nerdtree-git-plugin'
         Plug 'vim-airline/vim-airline'
         Plug 'vim-airline/vim-airline-themes'
         Plug 'morhetz/gruvbox'
	 Plug 'neoclide/coc.nvim', {'branch': 'release'}
	 Plug 'tpope/vim-unimpaired'
         
     " Initialize plugin system
     call plug#end()
     let g:airline#extensions#tabline#formatter = 'unique_tail'
     colorscheme gruvbox
     set background=dark    " Setting dark mode
     let g:gruvbox_contrast_dark = 'soft'
     map <C-n> :NERDTreeToggle<CR>
     nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
     nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
     nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

     nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
     nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
     nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?

     source $HOME/.cocrc.vim
else
     echo 'something else'
endif

"
" custom options
"
"
set cursorline
set lazyredraw
" vim-airline settings
"
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0

"
" always have status bar (for powerline and vim-airline)
set laststatus=2

set t_Co=256

syntax enable

if &diff
    syntax off
endif

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

" ------ leader mapping ------

let g:mapleader = "\<Space>"
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

"
"if !exists('g:airline_symbols')
"    let g:airline_symbols = {}
"endif
"
"    " unicode symbols
"    let g:airline_left_sep = '»'
"    let g:airline_left_sep = '▶'
"    let g:airline_right_sep = '«'
"    let g:airline_right_sep = '◀'
"    let g:airline_symbols.crypt = '🔒'
"    let g:airline_symbols.linenr = '☰'
"    let g:airline_symbols.linenr = '␊'
"    let g:airline_symbols.linenr = '␤'
"    let g:airline_symbols.linenr = '¶'
"    let g:airline_symbols.maxlinenr = ''
"    let g:airline_symbols.maxlinenr = '㏑'
"    let g:airline_symbols.branch = '⎇'
"    let g:airline_symbols.paste = 'ρ'
"    let g:airline_symbols.paste = 'Þ'
"    let g:airline_symbols.paste = '∥'
"    let g:airline_symbols.spell = 'Ꞩ'
"    let g:airline_symbols.notexists = 'Ɇ'
"    let g:airline_symbols.whitespace = 'Ξ'
"
"    " powerline symbols
"    let g:airline_left_sep = ''
"    let g:airline_left_alt_sep = ''
"    let g:airline_right_sep = ''
"    let g:airline_right_alt_sep = ''
"    let g:airline_symbols.branch = ''
"    let g:airline_symbols.readonly = ''
"    let g:airline_symbols.linenr = '☰'
"    let g:airline_symbols.maxlinenr = ''

" set the colorscheme

" do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1
