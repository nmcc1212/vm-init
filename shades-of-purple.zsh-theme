# vim:ft=zsh ts=2 sw=2 sts=2
#
# Shades of Purple.
# Forked agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README.
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
#
# In addition, if you're using it on Mac OS X, I recommend the
# [iTerm 2](http://www.iterm2.com/) over Terminal.app — it has
# significantly better color fidelity — and the
# [Shades of Purple iTerm2 theme](https://github.com/ahmadawais/Shades-of-Purple-iTerm2).

#
# # Goals.
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing.
# A few utility functions to make it easy and re-usable to draw segmented prompts.

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

## Not needed.
collapse_pwd() {
   # echo $(pwd | sed -e "s,^$HOME,~,")
   echo $(pwd | sed -e "s,^$HOME,~," | sed "s@\(.\)[^/]*/@\1/@g")
}

# Begin a segment.
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
    # echo $(pwd | sed -e "s,^$HOME,~," | sed "s@\(.\)[^/]*/@\1/@g")
    # echo $(pwd | sed -e "s,^$HOME,~,")
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments.
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components.
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I).
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%{%F{green}%}$USER@%m %{%F{white}%}❯"
  else
    prompt_segment black default "%(!.%{%F{yellow}%}.)❯"
  fi
}


# Git: branch/detached head, dirty status.
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi
    echo -n "${ref/refs\/heads\// }$dirty"
  fi
}

# Dir: current working directory.
prompt_dir() {
  prompt_segment blue black '%~'
  # echo $(pwd | sed -e "s,^$HOME,~," | sed "s@\(.\)[^/]*/@\1/@g")
}

# Status:
# - Was there an error
# - Am I root
# - Are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

## Main prompt.
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
