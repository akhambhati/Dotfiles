#!/usr/bin/env zsh

# Color the lambda according to context
local TIMEE="%(?,%{$fg_bold[green]%}[%*],%{$fg_bold[red]%}[%*])"
if [[ "$USER" == "root" ]]; then USERCOLOR="red"; else USERCOLOR="cyan"; fi

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST
}

# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ -z $(git_prompt_info 2> /dev/null) ]]; then
            git_head_info="%{$fg[blue]%}detached-head%{$reset_color%})"
            git_sha_info=""
        else
            git_head_info="$(git_prompt_info 2> /dev/null)"
            git_sha_info="$(git_prompt_short_sha)"
        fi

        git_mid_info="$(git_prompt_status)"
        if [[ ${#git_mid_info} == 0 ]]; then
            echo "${git_head_info} ${git_sha_info}"
        else
            echo "${git_head_info} %{$fg[white]%}(%{$reset_color%}${git_mid_info}%{$fg[white]%})%{$reset_color%} ${git_sha_info}"
        fi
    fi
}
local git_info='$(check_git_prompt_info)'

PROMPT="%E
$TIMEE \
%{$fg_no_bold[$USERCOLOR]%}%n \
%{$fg_no_bold[white]%}at \
%{$fg_no_bold[green]%}$(box_name) \
%{$fg_no_bold[magenta]%}[%~] \
${git_info} \
%{$fg[white]%}[%*]
%{$fg_bold[yellow]%}λ, %{$reset_color%}"

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}on%{$reset_color%} %{$fg[blue]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}%{$fg_bold[red]%} ✖︎"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}%{$fg_bold[green]%} ●"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg_bold[white]%}^"


# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg_bold[white]%}[%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg_bold[white]%}]"
