# set dotfiles directory
set -x DOTFILES DOTFILES_PATH_PLACEHOLDER

# fish prompt color
set -x fish_color_command green

# initialize starship prompt if installed
if command -v starship %> /dev/null
  starship init fish | source
end

# editors
set -x EDITOR vim
set -x VEDITOR code

# run user defined scripts
if [ -d $DOTFILES/user/scripts ]
  for script_path in (find $DOTFILES/user/scripts -iname "*.fish" -print0 | string split0)
    source $script_path
  end
end

# initialize pyenv if installed
if [ -d $HOME/.pyenv ]
  set -x PATH "/home/andyc/.pyenv/bin" $PATH
  status --is-interactive; and . (pyenv init -|psub)
  status --is-interactive; and . (pyenv virtualenv-init -|psub)
end

# initialize nvs if installed
if [ -d $HOME/.nvs ]
  set -x NVS_HOME $HOME/.nvs
  bass source $NVS_HOME/nvs.sh
end
