###########################
###  Configuration
############################

# note that the default prefix is Ctrl + b
# changing to Ctrl + a
unbind C-b
set -g prefix C-a

# force a reload of the config file
bind-key R source-file ~/.tmux.conf \; display-message "tmux.conf reloaded."

# set Zsh as your default Tmux shell
set-option -g default-shell /bin/zsh

# ensure colors display nicely
set -g default-terminal "xterm-256color"

# increase history limittmux
set-option -g history-limit 2000

# Pane switch with Alt + Arrow ------------------------------------------
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D


# Mouse support ----------------------------------------------------------
set -g mouse on
set -g mouse on
bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
bind -n WheelDownPane select-pane -t= \; send-keys -M
bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M

# bind-key -T copy-mode-vi WheelUpPane send -X scroll-up
# bind-key -T copy-mode-vi WheelDownPane send -X scroll-down

# Easy-to-remember split pane commands
bind \ split-window -h -c '#{pane_current_path}' # vertical pane
bind - split-window -v -c '#{pane_current_path}' # horizontal pane
unbind '"'
unbind %


# Status bar -------------------------------------------------------------
# set-option -g status on
set-option -g set-titles on
set -g status-interval 1

set -g status-position bottom
set -g status-bg colour237
set -g status-fg colour137
set -g status-attr dim
# set -g status-left '#[fg=colour197]#(~/bin/internet_info.sh) '
set -g status-right '#[fg=colour81]♪♫ #{spotify_status} #{spotify_artist}: #{spotify_track} | #(~/bin/battery.sh) #[fg=colour255,bg=colour241,bold] %a %d-%m #[fg=colour255,bg=colour241,bold] %H:%M:%S #[fg=colour165]#[bg=default] #H '
set -g status-right-length 100
set -g status-left-length 70


set-window-option -g aggressive-resize
setw -g window-status-current-fg colour170
setw -g window-status-current-bg colour239
setw -g window-status-current-attr bold
setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour170]#F '

set-option -g set-titles-string 'do epic shizz | #S | / #W'
setw -g window-status-current-fg colour170
setw -g window-status-current-attr bold
setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour170]#F '


# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'robhurring/tmux-spotify'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
