alias vim="nvim"

set PATH ~/.scripts $PATH
set PATH ~/.cargo/bin $PATH
set XDG_CONFIG_HOME ~/.config
set XDG_MUSIC_DIR ~/Music

posix-source ~/.config/fish/env

# Load wal, but refresh as little as possible (other than the terminal)
# using the most recent background, and no output.
wal -n -g -e -R -q

# Start X at login
if status --is-login
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
        exec startx -- -keeptty
    end
end

