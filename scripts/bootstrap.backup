#! /bin/fish

# quick variables
set fish_config_dir $HOME/.config/fish

# detect if $DOTFILES is properly set
if [ [ -z $DOTFILES ] -o [ $DOTFILES = 'DOTFILES_PATH_PLACEHOLDER' ] ]
  echo 'Please set the DOTFILES environement variable to the root of your dotfiles, or else this script won\'t work properly. Exiting...'
  exit 1
end

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

  if command -v curl %> /dev/null
    if [ -n $_flag_V ]
        curl --create-dirs -Lo $_flag_o $argv
    else
        curl --create-dirs -sLo $_flag_o --create-dirs $argv -- $_flag_l
    end
  else
    echo 'No program avaliable for downloading found. Install either curl to proceed. Exiting...'
    exit 1
  end
end

function log
  if [ -z $_flag_q ]
    printf $argv
    printf '\n'
  end
end

# install fisher
log 'Installing fisher...'
if [ -e $fish_config_dir/functions/fisher.fish ]
  log 'fisher has been already installed on this machine, running fisher self update...'
  if [ -n $_flag_V ]
    fisher self-update
  else
    fisher self-update %> /dev/null
  end
else
  download -o $fish_config_dir/functions/fisher.fish https://git.io/fisher
end

# link the fishfile and perform update
log 'Updating fisher plugins...'
if [ (realpath $fish_config_dir/fishfile) = $DOTFILES/fish/fishfile ]
  log 'Found existing fishfile link pointing to the dotfiles provided version, skipping linking...'
else if [ -e $fish_config_dir/fishfile ]
  log 'Found existing fishfile, backing it up...'
  cp $fish_config_dir/fishfile $fish_config_dir/fishfile.backup
else
  ln -s $DOTFILES/fish/fishfile $fish_config_dir/fishfile
  if [ -n $_flag_V ]
    fisher
  else
    fisher %> /dev/null
  end
end

# subsitute the DOTFILE_PATH_PLACEHOLDER in fish/config.fish to the real dotfiles path and link it
log 'Linking fish config...'
sed -n 's/DOTFILE_PATH_PLACEHOLDER/$DOTFILES/gp' $DOTFILES/fish/config.fish
if [ (realpath $fish_config_dir/config.fish) = $DOTFILES/fish/config.fish ]
  log 'Found existing config.fish link pointing to the dotfiles provided version, skipping linking...'
else if [ -e $fish_config_dir/config.fish ]
  log 'Found existing fish config, backing it up...'
  mv $fish_config_dir/config.fish $fish_config_dir/config.fish.backup
end
ln -s $DOTFILES/fish/config.fish $fish_config_dir/config.fish

# editorconfig
log 'Linking editorconfig...'
if [ (realpath $HOME/.editorconfig) = $DOTFILES/editorconfig/editorconfig.link ]
  log 'Found existing editorconfig link pointing to the dotfiles provided version, skipping linking...'
else if [ -e $HOME/.editorconfig ]
  log 'Found existing editorconfig, backing it up...'
  mv $HOME/.editorconfig $HOME/.editorconfig.backup
end
ln -s $DOTFILES/editorconfig/editorconfig.link $HOME/.editorconfig

# starship
if command -v starship %> /dev/null
  log 'Linking starship config...'
  if [ (realpath $HOME/.config/starship.toml) = $DOTFILES/starship/starship.toml ]
    log 'Found existing fishfile link pointing to the dotfiles provided version, skipping linking...'
  else if [ -e $HOME/.config/starship.toml ]
    log 'Found existing starship config, backing it up...'
    mv $HOME/.config/starship.toml $HOME/.config/starship.toml.backup
  end
  ln -s $DOTFILES/starship/starship.toml $HOME/.config/starship.toml
end

# node (use flag --china to configure china mirrors for npm/yarn)
if command -v node %> /dev/null
  log 'Configuring NPM&Yarn...'
  if [ -n $_flag_V ]
    npm install --verbose -g npm yarn
  else if [ -n $_flag_q ]
    npm install --silent -g npm yarn
  else
    npm install -g npm yarn
  end

  if [ -n $_flag_china ]
    if [ -n $_flag_V ]
      npm install --verbose -g mirror-config-china
    else if [ -n $_flag_q ]
      npm install --silent -g mirror-config-china
    else
      npm install -g mirror-config-china
    end
  end
end

exit 0
