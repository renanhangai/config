#!/bin/bash

# Local dir
local current_dir='${PWD/#$HOME/~}'
local theme_dir=${0:a:h}
	
# Check for git
local git_info=""
if command -v "git" >/dev/null 2>&1; then
	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWUPSTREAM=1
	git_info='$(__git_ps1)';
	if [ ! -f "${theme_dir}/git-prompt.sh" ]; then
		curl -L "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" > "${theme_dir}/git-prompt.sh"
	fi
	source "${theme_dir}/git-prompt.sh"
	if ! command -v "__git_ps1" >/dev/null 2>&1; then
		git_info=""
	fi
fi

# Virtual env theme
export VIRTUAL_ENV_DISABLE_PROMPT=1
function theme_get_virtualenv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        local virtualenv_name=$(basename "$VIRTUAL_ENV")
        echo "%{$fg_bold[yellow]%}[${virtualenv_name}]%{$reset_color%} "
    fi
}
local virtualenv_info='$(theme_get_virtualenv)'

# Return script
local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"

# Check SSH client and Root
local ps1_host="%{$terminfo[bold]$fg[green]%}%n@%{$HOST%}"
if [ "$(id -u)" = "0" ]; then
	ps1_host="%{$terminfo[bold]$fg[red]%}root:%n@%{$HOST%}"
elif [ -n "$SSH_CLIENT" ]; then
	ps1_host="%{$terminfo[bold]$fg[cyan]%}%n@%{$HOST%}"
fi

# Set the prompt
PROMPT="
${virtualenv_info}${ps1_host}%{$reset_color%}\
:\
%{$terminfo[bold]$fg[blue]%}${current_dir}%{$reset_color%}\
%{$terminfo[bold]$fg[yellow]%}${git_info}%{$reset_color%}
${ret_status}%{$reset_color%}"
