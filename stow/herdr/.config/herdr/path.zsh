# herdr — terminal multiplexer
# Only declares the install dir the installer honours; herdr finds
# config.toml itself under $XDG_CONFIG_HOME/herdr/. $BIN_HOME is already
# on $path (see .zshenv), so nothing else is needed here.
export HERDR_INSTALL_DIR="${BIN_HOME:-$HOME/.local/bin}"
