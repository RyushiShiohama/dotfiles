# ============================================================
#  alias
# ============================================================
alias ll='ls -l'
alias la='ls -la'
alias dc='docker compose'
alias r='dc exec spring bin/spring rails'
alias rk='dc exec spring bin/rake'
alias rs='dc exec spring bin/spring rspec'
alias rb='dc exec spring bundle exec rubocop'
alias s=server
alias gco='git checkout'
alias gst='git status'
alias gsh='git stash pop stash@{0}'
alias gdif='git diff --compaction-heuristic'
alias gclean='git branch --merged | egrep -v "\*|master|staging" | xargs git branch -D'
alias lsusb='system_profiler SPUSBDataType'

# --- legacy aliases (from old PC) ---
alias pj='phantomjs'
alias gp='cd /Users/ryushi/go/src/github.com/micin-jp'
alias curon='cd ~/Documents/work/micin/dev/codes'
alias sedori='cd ~/Documents/work/sedori/dev/codes'
alias eyez='cd ~/Documents/work/eyez/dev/codes'
alias curon-prd='AWS_PROFILE=curon_prod_ssm ./docker/console/ssm/start_session.prod.sh'
alias curon-stg0='AWS_PROFILE=curon_new_stg_ssm ./docker/console/ssm/start_session.stg0.sh'
alias curon-stg1='AWS_PROFILE=curon_new_stg_ssm ./docker/console/ssm/start_session.stg1.sh'
alias curon-stg2='AWS_PROFILE=curon_new_stg_ssm ./docker/console/ssm/start_session.stg2.sh'
alias curon-stg3='AWS_PROFILE=curon_new_stg_ssm ./docker/console/ssm/start_session.stg3.sh'
alias curon-stg4='AWS_PROFILE=curon_new_stg_ssm ./docker/console/ssm/start_session.stg4.sh'
alias curon-stg5='AWS_PROFILE=curon_new_stg_ssm ./docker/console/ssm/start_session.stg5.sh'
alias curon-stg6='AWS_PROFILE=curon_new_stg_ssm ./docker/console/ssm/start_session.stg6.sh'
alias curon-demo='ssh curon-demo-console'
alias proxy='sh ~/Documents/work/micin/dev/scripts/launch_proxy.sh'
alias can_deploy='sh ~/Documents/work/micin/dev/scripts/check_build_availability.sh'

# ============================================================
#  SSH keys
# ============================================================
ssh-add ~/.ssh/curon_rsa   2>/dev/null
ssh-add ~/.ssh/curon_rsa2  2>/dev/null
ssh-add ~/.ssh/github_rsa  2>/dev/null

# ============================================================
#  PATH
# ============================================================
PATH=$PATH:$HOME/.local/bin:$HOME/bin:/usr/local/bin

# ============================================================
#  Zsh options
# ============================================================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt auto_cd
setopt auto_pushd
setopt list_packed
setopt nolistbeep
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt NO_HUP
setopt no_nomatch

autoload -U compinit
compinit
zstyle ':completion:*:default' menu select=1

export LC_ALL=ja_JP.UTF-8

# ============================================================
#  History
# ============================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ============================================================
#  Prompt
# ============================================================
PROMPT="ryushi$ "
RPROMPT="%~"

autoload -U colors; colors

function rprompt-git-current-branch {
        local name st color

        if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
                return
        fi
        name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
        if [[ -z $name ]]; then
                return
        fi
        st=`git status 2> /dev/null`
        if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
                color=${fg[green]}
        elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
                color=${fg[yellow]}
        elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
                color=${fg_bold[red]}
        else
                color=${fg[red]}
        fi

        echo "%{$color%}$name%{$reset_color%} "
}
setopt prompt_subst
RPROMPT='[`rprompt-git-current-branch`%~]'

# ============================================================
#  Tool integrations
# ============================================================

# direnv
eval "$(direnv hook zsh)"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nvm
export PATH="./node_modules/.bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

# golang
export GOVERSION=1.9
export GOPATH_LIB=$HOME/.go
export GOPATH_DEV=$HOME/go
export GOPATH=$GOPATH_DEV:$GOPATH_LIB

# pyenv
export PYENV_ROOT=/usr/local/var/pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Java
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# ============================================================
#  Misc exports
# ============================================================
export EDITOR="vim"
export AWS_DEFAULT_REGION=ap-northeast-1
export PKG_CONFIG_PATH=/usr/local/Cellar/imagemagick@6/6.9.9-39/lib/pkgconfig/
