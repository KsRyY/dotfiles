# dotfiles

This is a collection of my dotfiles. They were all specifically tinkered for usage of myself, so use it with caution. The setup script does a lot of stuff, and you may not want to install some of them. An improved script is planned, but is not avaliable now.

## Prerequisites

You need following tools to install the dotfiles:

  * Git for cloning the repository
  * curl downloading external scripts (wget is unsupported due to minor problems)
  * fish for executing installation scripts

All other things all optional, the installation script will automatically detect whether these tools are installed and configure them. There are also switches to turn them on and off regardless if they are installed or not.

## Installation

Run the following command to apply the dotfiles:

```fish
set -x DOTFILES $HOME/.dotfiles # where to install those dotfiles
git clone https://github.com/KsRyY/dotfiles $DOTFILES
cd $DOTFILES
./script/bootstrap
```

To view all options of the bootstrap script, run this:

```fish
./script/bootstrap --help
```

## Dotfiles

For a full list of dotfiles included and how they work, head to [DOTFILES.md](./DOTFILES.md)

