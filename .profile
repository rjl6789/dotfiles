# profile
[[ -d $HOME/.bin ]] && export PATH=$HOME/.bin:$HOME/.local/bin:$PATH
export EDITOR="nvim"
export RANGER_LOAD_DEFAULT_RC="FALSE"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --color=never --no-ignore --smart-case --no-ignore-vcs --glob "!.git/*"'
