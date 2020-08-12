#! /bin/fish

# quick variables
set fish_config_dir $HOME/.config/fish

argparse --name 'bootstrap.fish' 'V/verbose' 'q/quiet' 'n-node' 'h/help' 'c-china' -- $argv

# print help
function help
  echo 'Usage: bootstrap.fish [OPTIONS]'
  echo ''
  echo 'Options:'
  echo '  --china         Configure tools to use China mirrors if possible (npm/yarn, pyenv, pip)'
  echo '  --help          Display this help message'
  echo ''
end

# download files using either curl or wget
function download
  argparse 'o/output=' -- $argv

  if command -v curl
    if [ $_flag_verbose ]
        curl --create-dirs -Lo $_flag_o $argv
    else
        curl --create-dirs -sLo $_flag_o --create-dirs $argv -- $_flag_l
    end
  else
    echo 'No program avaliable for downloading found. Install either wget or curl to proceed. Exiting...'
    exit 1
  end
end

function log
  if [ !$_flag_q ]
    printf $argv
  end
end

# install fisher
log 'Installing fisher...'
download -o $fish_config_dir/functions/fisher.fish https://git.io/fisher

# link the fishfile and perform update
log 'Updating fisher plugins...'
ln -s $DOTFILES/fish/fishfile $fish_config_dir/fishfile
fisher

# subsitute the DOTFILE_PATH_PLACEHOLDER in fish/config.fish to the real dotfiles path and link it
log 'Linking fish config...'
sed -n 's/DOTFILE_PATH_PLACEHOLDER/$DOTFILES/gp' $DOTFILES/fish/config.fish
ln -s $DOTFILES/fish/config.fish $fish_config_dir/config.fish

# editorconfig
ln -s $DOTFILES/editorconfig/editorconfig $HOME/.editorconfig

# node (use flag --china to configure china mirrors for npm/yarn)
if command -v node
  log 'Configuring NPM&Yarn...'
  if [ $_flag_verbose ]
    npm install --verbose -g npm yarn
  else if [ $_flag_q ]
    npm install --silent -g npm yarn
  else
    npm install -g npm yarn
  end

  if [ $_flag_china ]
    if [ $_flag_verbose ]
      npm install --verbose -g mirror-config-china
    else if [ $_flag_q ]
      npm install --silent -g mirror-config-china
    else
      npm install -g mirror-config-china
    end
  end
end

exit 0
