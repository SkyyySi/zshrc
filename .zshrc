#!/usr/bin/env zsh

# Quick settings.

# If you have your own folder with plugins and themes, you can define it here.
# Note: plugins and themes must be put in $ZSH_CUSTOM_DIR/plugins and $ZSH_CUSTOM_DIR/themes, respectively.
#ZSH_CUSTOM_DIR="$HOME/zshstuff"

# Try to load the following ZSH theme.
# Set to "none" to use the default (or whatever you specified at the end of this file).
ZSH_THEME="none"

# Try to load the following ZSH plugin(s).
ZSH_PLUGINS=(zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)

# Use color for some commands. It only matters if it's set to "false" or not
COLOR_COMMANDS="true"

# Use exa instead of ls. It only matters if it's set to "false" or not
REPLACE_LS_WITH_EXA="true"

# Use bat instead of cat. It only matters if it's set to "false" or not
REPLACE_CAT_WITH_BAT="true"

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# Some common environment variables.
local __guess_editor() {
	local a e editors=('micro' 'nvim' 'vim' 'emacs' 'nano' 'vi' 'ex')

	for e in $editors; do
		if (( $+commands[${e}] )); then
			export EDITOR=${e}
			break
		fi
	done

	sed "s|$EDITOR ||g" <<< "$editors "

	for a in $editors; do
		if (( $+commands[${a}] )); then
			export ALTERNATE_EDITOR=${a}
			break
		fi
	done
}

local __guess_browser() {
	local b browsers=('firefox' 'chromium' 'qutebrowser' 'surf' 'vivaldi' 'opera')

	for b in $browsers; do
		if if (( $+commands[${b}] )); then
			export BROWSER=${b}
			break
		fi
	done
}

export TERM=xterm-256color

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# Load some shell modules...
autoload -Uz add-zsh-hook \
             add-zle-hook-widget \
             calendar \
             calendar_add \
             calendar_edit \
             calendar_lockfiles \
             calendar_parse \
             calendar_read \
             calendar_scandate \
             calendar_show \
             calendar_showdate \
             calendar_sort \
             checkmail \
             colors \
             compinit \
             compaudit \
             pick-web-browser \
             promptinit \
             run-help \
             run-help-git \
             run-help-ip \
             run-help-openssl \
             run-help-p4 \
             run-help-sudo \
             run-help-svk \
             run-help-svn \
             tetriscurses \
             vcs_info \
             zcalc \
             zed \
             zfcd \
             zmv \
             ztodo

# ...and activate them.
colors     # Not needed in newer versions of ZSH where you can use %F...%f and %K...%k, but many themes still need it.
promptinit

# Enable some shell options.
setopt alwaystoend
setopt appendhistory
setopt autocd
setopt autolist
setopt automenu
setopt completeinword
setopt correct
setopt histignorealldups
setopt histignorespace
setopt nobeep
setopt nocheckjobs
setopt noglobdots
setopt nohup
setopt notify
setopt promptsubst
setopt sharehistory
setopt unset
setopt vi

# ZSH aliases run-help to man (for some reason). Disable that!
(( $+aliases[run-help] )) && unalias run-help

# Set up history storage.
# Instead of throwing it into your home directory, the history file
# will be put in ~/.cache (unless $XDG_CACHE_HOME is set).
if [[ ! -w "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history" ]]; then
	command mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/"
	touch "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
fi

HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
HISTSITE="1000000"
SAVEHIST="1000000"

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# Set up a nicer completion.

[[ $(uname -s) = 'Linux' ]] && zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' format '%B%F{blue}Available%f %F{white}%d%f%b '
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' prompt '%B%F{white}%e %F{red}errors found. Possible corrections%F{white}:%b%f '
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename "$HOME/.zshrc"
compinit; compaudit

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# Define aliases and functions.

# First, some general-porpuse ones:
alias sudo='command sudo '   # Notice the space
alias pico='command nano -p'
alias df='command df -h'
alias free='command free -m'

# Next, a few aliases for file management:
alias f='command find . -iname'
alias ff='command find / -iname'
alias cp='command cp -vi'
alias mv='command mv -vi'
alias rm='command rm -vi'
alias mkdir='command mkdir -vp'

# Add color to some commands.

# First few aliases to get color:
if [[ $COLOR_COMMANDS != "false" ]]; then
	alias grep='command grep   --color=auto'
	alias egrep='command egrep --color=auto'
	alias fgrep='command fgrep --color=auto'
	alias watch='command watch --color'
	alias ip='command ip        -c'
fi

# Next, add color to less:
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Next, use bat instead of cat to get syntax highlighting:
if (( $+commands[bat] )) && [[ $REPLACE_CAT_WITH_BAT != "false" ]]; then
	alias cat='bat --theme=base16 --paging=never --style=plain --tabs 2'
fi

# Next, a few aliases for ls/exa:
if (( $+commands[exa] )) && [[ $REPLACE_LS_WITH_EXA != "false" ]]; then
	if [[ $COLOR_COMMANDS != "false" ]]; then
		alias ls='command exa  --color=auto --group-directories-first --git'
		alias la='command exa  --color=auto --group-directories-first --git -a'
		alias ll='command exa  --color=auto --group-directories-first --git -alhmg'
		alias lll='command exa --color=auto --group-directories-first --git -alhmgR --level 2'
		alias l='command exa   --color=auto --group-directories-first --git -lh'
	else
		alias ls='command exa  --color=never --group-directories-first --git'
		alias la='command exa  --color=never --group-directories-first --git -a'
		alias ll='command exa  --color=never --group-directories-first --git -alhmg'
		alias lll='command exa --color=never --group-directories-first --git -alhmgR --level 2'
		alias l='command exa   --color=never --group-directories-first --git -lh'
	fi
elif [[ $COLOR_COMMANDS != "false" ]]; then
	alias ls='command ls  --color=auto --group-directories-first'
	alias la='command ls  --color=auto --group-directories-first -A'
	alias ll='command ls  --color=auto --group-directories-first -AlhsF'
	alias lll='command ls --color=auto --group-directories-first -AlhsFR'
	alias l='command ls   --color=auto --group-directories-first -lhFG'
else
	alias ls='command ls  --color=never --group-directories-first'
	alias la='command ls  --color=never --group-directories-first -A'
	alias ll='command ls  --color=never --group-directories-first -AlhsF'
	alias lll='command ls --color=never --group-directories-first -AlhsFR'
	alias l='command ls   --color=never --group-directories-first -lhFG'
fi

# Lastly, some functions that wouldn't work as aliases:

# Nohup, but the output doesn't get written into a file.
function noout() {
	nohup "$@" &>/dev/null &
}

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# This zshrc has a build-in theme & plugin manager.

# First, the plugins defined in $ZSH_PLUGINS.
for p in $ZSH_PLUGINS; do
	  if [[ -r "$HOME/.oh-my-zsh/plugins/$p/$p.plugin.zsh" ]]; then source "$HOME/.oh-my-zsh/plugins/$p/$p.plugin.zsh";
	elif [[ -r "$HOME/.oh-my-zsh/plugins/$p/$p.zsh" ]]; then        source "$HOME/.oh-my-zsh/plugins/$p/$p.zsh";
	elif [[ -r "$HOME/.oh-my-zsh/plugins/$p.plugin.zsh" ]]; then    source "$HOME/.oh-my-zsh/plugins/$p.plugin.zsh";
	elif [[ -r "$HOME/.oh-my-zsh/plugins/$p.zsh" ]]; then           source "$HOME/.oh-my-zsh/plugins/$p.zsh";
	elif [[ -r "$HOME/.zsh/plugins/$p/$p.plugin.zsh" ]]; then       source "$HOME/.zsh/plugins/$p/$p.plugin.zsh";
	elif [[ -r "$HOME/.zsh/plugins/$p/$p.zsh" ]]; then              source "$HOME/.zsh/plugins/$p/$p.zsh";
	elif [[ -r "$HOME/.zsh/plugins/$p.plugin.zsh" ]]; then          source "$HOME/.zsh/plugins/$p.plugin.zsh";
	elif [[ -r "$HOME/.zsh/plugins/$p.zsh" ]]; then                 source "$HOME/.zsh/plugins/$p.zsh";
	elif [[ -r "/usr/share/zsh/plugins/$p/$p.plugin.zsh" ]]; then   source "/usr/share/zsh/plugins/$p/$p.plugin.zsh";
	elif [[ -r "/usr/share/zsh/plugins/$p/$p.zsh" ]]; then          source "/usr/share/zsh/plugins/$p/$p.zsh";
	elif [[ -r "/usr/share/zsh/plugins/$p.plugin.zsh" ]]; then      source "/usr/share/zsh/plugins/$p.plugin.zsh";
	elif [[ -r "/usr/share/zsh/plugins/$p.zsh" ]]; then             source "/usr/share/zsh/plugins/$p.zsh";
	elif [[ -r "$ZSH_CUSTOM_DIR/plugins/$p/$p.plugin.zsh" ]]; then  source "$ZSH_CUSTOM_DIR/plugins/$p/$p.plugin.zsh";
	elif [[ -r "$ZSH_CUSTOM_DIR/plugins/$p/$p.zsh" ]]; then         source "$ZSH_CUSTOM_DIR/plugins/$p/$p.zsh";
	elif [[ -r "$ZSH_CUSTOM_DIR/plugins/$p.plugin.zsh" ]]; then     source "$ZSH_CUSTOM_DIR/plugins/$p.plugin.zsh";
	elif [[ -r "$ZSH_CUSTOM_DIR/plugins/$p.zsh" ]]; then            source "$ZSH_CUSTOM_DIR/plugins/$p.zsh";
	fi
done

# Before loading the theme, here's a better defalt one:
function __default_prompt() {
	function __prompt_git() {
		zstyle ':vcs_info:*' enable git
		if git diff --quiet --ignore-submodules HEAD 2>/dev/null; then
			zstyle ':vcs_info:git*' formats " %{$fg_bold[green]%}[%b]%{$reset_color%}"
			zstyle ':vcs_info:git*' actionformats " %{$fg_bold[green]%}[%b]%{$reset_color%}"
		else
			zstyle ':vcs_info:git*' formats " %{$fg_bold[yellow]%}[%b]%{$reset_color%}"
			zstyle ':vcs_info:git*' actionformats " %{$fg_bold[yellow]%}[%b]%{$reset_color%}"
		fi
		zstyle ':vcs_info:*' get-revision true
		zstyle ':vcs_info:*' check-for-changes true
		vcs_info
		echo -n "${vcs_info_msg_0_}"
	}

	# Next, if you want to disable the whitespace at the end (doesn't appear to always work),
	# you can uncomment this option. Note that on some terminals, this will cause a linebreak
	# (which is why it is there in the first place).
	#ZLE_RPROMPT_INTEND=0

	# Now set the prompt:
	PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n@%m%{$fg_bold[white]%}:%{$fg_bold[blue]%}%~%(?..%{$fg_bold[red]%}[%?]%{$reset_color%})%{$fg_bold[blue]%}%#%{$reset_color%} '
	RPROMPT='$(__prompt_git)'
}

# If $ZSH_THEME is set to a value in this array, the default theme will be used,
# even if a theme with a matching name exists (why would you name your theme "none" anyway?).
local __DEFAULT_ZSH_THEME_SUBSTITUTES=('none' 'default')

# Now the theme from $ZSH_THEME.
for p in $ZSH_PLUGINS; do
	  if [[ "$ZSH_THEME" =~ "$__DEFAULT_ZSH_THEME_SUBSTITUTES" ]]; then           _default_prompt;
	elif [[ -r "$HOME/.oh-my-zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh-theme" ]]; then source "$HOME/.oh-my-zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh-theme";
	elif [[ -r "$HOME/.oh-my-zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh" ]]; then       source "$HOME/.oh-my-zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh";
	elif [[ -r "$HOME/.oh-my-zsh/themes/$ZSH_THEME.zsh-theme" ]]; then            source "$HOME/.oh-my-zsh/themes/$ZSH_THEME.zsh-theme";
	elif [[ -r "$HOME/.oh-my-zsh/themes/$ZSH_THEME.zsh" ]]; then                  source "$HOME/.oh-my-zsh/themes/$ZSH_THEME.zsh";
	elif [[ -r "$HOME/.zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh-theme" ]]; then       source "$HOME/.zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh-theme";
	elif [[ -r "$HOME/.zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh" ]]; then             source "$HOME/.zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh";
	elif [[ -r "$HOME/.zsh/themes/$ZSH_THEME.zsh-theme" ]]; then                  source "$HOME/.zsh/themes/$ZSH_THEME.zsh-theme";
	elif [[ -r "$HOME/.zsh/themes/$ZSH_THEME.zsh" ]]; then                        source "$HOME/.zsh/themes/$ZSH_THEME.zsh";
	elif [[ -r "/usr/share/zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh-theme" ]]; then   source "/usr/share/zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh-theme";
	elif [[ -r "/usr/share/zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh" ]]; then         source "/usr/share/zsh/themes/$ZSH_THEME/$ZSH_THEME.zsh";
	elif [[ -r "/usr/share/zsh/themes/$ZSH_THEME.zsh-theme" ]]; then              source "/usr/share/zsh/themes/$ZSH_THEME.zsh-theme";
	elif [[ -r "/usr/share/zsh/themes/$ZSH_THEME.zsh" ]]; then                    source "/usr/share/zsh/themes/$ZSH_THEME.zsh";
	elif [[ -r "$ZSH_CUSTOM_DIR/themes/$ZSH_THEME/$ZSH_THEME.zsh-theme" ]]; then  source "$ZSH_CUSTOM_DIR/themes/$ZSH_THEME/$ZSH_THEME.zsh-theme";
	elif [[ -r "$ZSH_CUSTOM_DIR/themes/$ZSH_THEME/$ZSH_THEME.zsh" ]]; then        source "$ZSH_CUSTOM_DIR/themes/$ZSH_THEME/$ZSH_THEME.zsh";
	elif [[ -r "$ZSH_CUSTOM_DIR/themes/$ZSH_THEME.zsh-theme" ]]; then             source "$ZSH_CUSTOM_DIR/themes/$ZSH_THEME.zsh-theme";
	elif [[ -r "$ZSH_CUSTOM_DIR/themes/$ZSH_THEME.zsh" ]]; then                   source "$ZSH_CUSTOM_DIR/themes/$ZSH_THEME.zsh";
	elif (( $+functions[prompt] )) && [[ $(prompt -l) =~ "$ZSH_THEME" ]]; then    prompt "$ZSH_THEME"
	else                                                                          __default_prompt;
	fi
done

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# Set some key bindings.

bindkey -- "${terminfo[khome]}" beginning-of-line
bindkey -- "${terminfo[kend]}"  end-of-line
bindkey -- "${terminfo[kich1]}" overwrite-mode
bindkey -- "${terminfo[kbs]}"   backward-delete-char
bindkey -- "${terminfo[kdch1]}" delete-char
bindkey -- "${terminfo[kcub1]}" backward-char
bindkey -- "${terminfo[kcuf1]}" forward-char
bindkey -- "${terminfo[kpp]}"   beginning-of-buffer-or-history
bindkey -- "${terminfo[knp]}"   end-of-buffer-or-history
bindkey -- "${terminfo[kcbt]}"  reverse-menu-complete

if [[ "${ZSH_PLUGINS[@]}" =~ "zsh-history-substring-search" ]]; then
	# Map up and down to use zhss instead of the built-ins if it's available.
	zle -N history-substring-search-up
	zle -N history-substring-search-down
	bindkey "${terminfo[kcuu1]}" history-substring-search-up
	bindkey "${terminfo[kcud1]}" history-substring-search-down
	bindkey -M emacs '^P'        history-substring-search-up
	bindkey -M emacs '^N'        history-substring-search-down
	bindkey -M vicmd 'k'         history-substring-search-up
	bindkey -M vicmd 'j'         history-substring-search-down
else
	autoload -Uz                   up-line-or-beginning-search \
	                             down-line-or-beginning-search
	zle -N                         up-line-or-beginning-search
	zle -N                       down-line-or-beginning-search
	bindkey "${terminfo[kcuu1]}"   up-line-or-beginning-search
	bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
	bindkey -M emacs '^P'          up-line-or-beginning-search
	bindkey -M emacs '^N'        down-line-or-beginning-search
	bindkey -M vicmd 'k'           up-line-or-beginning-search
	bindkey -M vicmd 'j'         down-line-or-beginning-search
fi

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# Lastly, source ~/.zshrc/.local to offer two, less cluttered zshrcs
# instead of one where you can't find anything.

if [[ -r "${ZDOTDIR:-$HOME}/.zshrc.local" ]]; then
	. "${ZDOTDIR:-$HOME}/.zshrc.local"
fi
