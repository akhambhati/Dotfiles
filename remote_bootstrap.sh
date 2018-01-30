[[ -x `command -v wget` ]] && CMD="wget --no-check-certificate -O -"
[[ -x `command -v curl` ]] >/dev/null 2>&1 && CMD="curl -#L"

if [ -z "$CMD" ]; then
  echo "No curl or wget available. Aborting."
else
  echo "Installing Dotfiles"
  mkdir -p "$HOME/Dotfiles" && \
  eval "$CMD https://github.com/akhambhati/Dotfiles/tarball/master | tar -xzv -C $HOME/Dotfiles --strip-components=1"
  . "$HOME/Dotfiles/bootstrap.sh"
fi
