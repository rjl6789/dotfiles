set nocompatible

set runtimepath^=~/vimfiles runtimepath+=~/vimfiles/after
let &packpath = &runtimepath

if has('win32') || has('win64')
	source $USERPROFILE/vimfiles/vimrc
else
	source ~/.vimrc
endif
