#!/bin/bash

# Local dir
local current_dir='${PWD/#$HOME/~}'

# Check for git
local git_info='$(git_prompt_info)';
if command -v "__git_ps1" >/dev/null 2>&1; then
	git_info='$(__git_ps1)';
    GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWUPSTREAM=1
elif command -v "git_prompt_info" >/dev/null 2>&1; then
	git_info='$(git_prompt_info)';
fi

# Return script
local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"

# Set the prompt
PROMPT="
%{$terminfo[bold]$fg[green]%}%n@%{$HOST%}%{$reset_color%}\
:\
%{$terminfo[bold]$fg[blue]%}${current_dir}%{$reset_color%}\
%{$terminfo[bold]$fg[yellow]%}${git_info}%{$reset_color%}
${ret_status}%{$reset_color%}"
