#!/usr/bin/env bash

###############################################################################
# VARIABLES
###############################################################################

count=1

reset="\033[0m"
highlight="\033[41m\033[97m"
dot="\033[31m▸ $reset"
dim="\033[2m"
blue="\e[34m"
green="\e[32m"
yellow="\e[33m"
tag_green="\e[30;42m"
tag_blue="\e[30;46m"
bold=$(tput bold)
normal=$(tput sgr0)
underline="\e[37;4m"
indent="   "

# Get full directory name of this script
cwd="$(cd "$(dirname "$0")" && pwd)"


step() {
    printf "\n   ${dot}${underline}$@${reset}\n"
}

_print_in_color() {
    printf "%b" \
        "$(tput setaf "$2" 2> /dev/null)" \
        "$1" \
        "$(tput sgr0 2> /dev/null)"
}

print_in_green() {
    _print_in_color "$1" 2
}

print_success() {
    print_in_green "  [✓] $1\n"
}

# Install xcode

if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
  test -d "${xpath}" && test -x "${xpath}" ; then
  print_success_muted "Xcode already installed. Skipping."
else
  step "Installing Xcode…"
  xcode-select --install
  print_success "Xcode installed!"
fi

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

# Install NVM

step "Installing NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
print_success "NVM installed!"
print_success "Using Node $nodev!"


# -----------------------------------------------------------------------------
# Install Homebrew
# -----------------------------------------------------------------------------
if ! [ -x "$(command -v brew)" ]; then
  step "Installing Homebrew…"
  curl -fsS 'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
  export PATH="/usr/local/bin:$PATH"
  print_success "Homebrew installed!"
else
  print_success "Homebrew already installed. Skipping."
fi

if brew list | grep -Fq brew-cask; then
  step "Uninstalling old Homebrew-Cask…"
  brew uninstall --force brew-cask
  print_success "Homebrew-Cask uninstalled!"
fi
