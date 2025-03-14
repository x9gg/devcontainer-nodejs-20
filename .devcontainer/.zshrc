# ~/.zshrc file for zsh interactive shells.

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LS_COLORS="di=34:ln=36:so=35:pi=33:ex=91:bd=43;33:cd=45;33:su=37;41:sg=30;43:tw=30;42:ow=34;42:*.gz=95:*.zip=91:*.jpg=93:*.mp4=96:*.mp3=92:*.txt=32"
export GPG_TTY=$(tty)


setopt APPEND_HISTORY          # Append history to file, don’t overwrite
setopt INC_APPEND_HISTORY      # Add commands to the history file as they are entered
setopt SHARE_HISTORY           # Share history across multiple zsh sessions
setopt HIST_IGNORE_DUPS        # Ignore duplicate commands
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicates, keeping the latest
setopt HIST_IGNORE_SPACE       # Don't save commands that start with a space
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks before saving
setopt HIST_VERIFY             # Show command before running with history expansion
setopt EXTENDED_HISTORY        # Save timestamps for each command
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.

setopt HIST_SAVE_NO_DUPS       # Avoid saving duplicate commands to history file
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicates first when trimming history

unsetopt FLOW_CONTROL
unset zle_bracketed_paste
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # Change suggestion settings to prevent visual duplication
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    ZSH_AUTOSUGGEST_MANUAL_REBIND=1
fi
# hide EOL sign ('%')
PROMPT_EOL_MARK=">> "

bindkey -e
bindkey '^n' history-search-forward

bindkey '^[b' backward-word      # Alt+b for backward word
bindkey '^[f' forward-word       # Alt+f for forward word

bindkey '^A' beginning-of-line  # Ctrl+A for start of line
bindkey '^E' end-of-line        # Ctrl+E for end of line
bindkey '^K' kill-line          # Ctrl+K to delete to end of line
bindkey '^U' kill-whole-line    # Ctrl+U to delete entire line
bindkey '^W' backward-kill-word # Ctrl+W to delete previous word

bindkey '^P' up-line-or-history      # Ctrl+P for previous command
bindkey '^N' down-line-or-history    # Ctrl+N for next command
bindkey '^R' history-incremental-search-backward # Ctrl+R for history search

bindkey '^[b' backward-word      # Alt+b to move backward one word
bindkey '^[f' forward-word       # Alt+f to move forward one word
bindkey '^[d' kill-word          # Alt+d to delete forward word


# Completion
# bindkey '^I' complete-word        # Tab for completion
bindkey '^I' expand-or-complete
bindkey '^[[Z' reverse-menu-complete # Shift+Tab for reverse completion


# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "%{(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

zstyle ':completion:*:options' list-separator ' '
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' remove-all-dups true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' insert-tab false


HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
HISTDUP=erase


alias history="history 0"

TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol=@
    PROMPT=$'%F{%(#.blue.green)} >> %B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)}-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}] %B%(#.%F{red}#.%F{blue}$)%b%F{reset} '

    unset prompt_symbol
}

NEWLINE_BEFORE_PROMPT=yes

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt

precmd() {
    print -Pnr -- "$TERM_TITLE"

    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi


## custom script may be handy
source $HOME/scripts/git-set-config.sh