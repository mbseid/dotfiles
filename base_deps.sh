#!/usr/bin/env bash


step() {
    printf "\n   ${dot}${underline}$@${reset}\n"
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
step "Installing latest Node…"
nvm install node
nvm use node
nvm run node --version
nodev=$(node -v)
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
