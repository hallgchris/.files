alias vim="nvim"

set PATH ~/.scripts $PATH
set PATH ~/.cargo/bin $PATH
set XDG_CONFIG_HOME ~/.config
set XDG_MUSIC_DIR ~/Music

posix-source ~/.config/fish/env

# Start X at login
if status --is-login
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
        exec startx -- -keeptty
    end
end

