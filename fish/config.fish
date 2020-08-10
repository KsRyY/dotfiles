# set dotfiles directory
set -x DOTFILES DOTFILES_PATH_PLACEHOLDER

# fish prompt color
set -x fish_color_command green

# editors
set -x EDITOR vim
set -x VEDITOR code

# run user defined scripts
for script_path in (find $DOTFILES/user/scripts -iname "*.fish" -print0 | string split0)
    source $script_path
end
