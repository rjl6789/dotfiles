"---------------------------------------------
"" Neovim gui settings
"---------------------------------------------
"

" disable ugly tabline and popup window
GuiTabline 0
GuiPopupmenu 0


"---------------------------------------------
" font setting
"---------------------------------------------
:GuiFont! DejaVu\ Sans\ Mono\ for\ Powerline:h13:cANSI
" enable ctrl mouse scroll wheel sizing
let s:fontsize = 13
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! DejaVu\ Sans\ Mono\ for\ Powerline:h" . s:fontsize . ":cANSI"
endfunction

n

noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

