# tatr-mac tmux bindings. Add to ~/.tmux.conf:
#   source-file ~/path/to/tatr-mac/tmux/tatr-mac.tmux
# Requires tt, git-dash, tmux-git-status on PATH (run install.sh), plus fzf and lazygit.

# prefix T: task picker popup (enter edit, ctrl-x close, ctrl-n new, ctrl-s cycle state)
bind T display-popup -E -w 85% -h 80% -d "#{pane_current_path}" "tt pick"
# prefix g: lazygit popup
bind g display-popup -E -w 92% -h 92% -d "#{pane_current_path}" "lazygit"
# prefix G: toggle the live git dashboard pane
bind G run-shell "git-dash --toggle '#{pane_current_path}'"
# prefix B: fuzzy branch checkout
bind B display-popup -E -w 60% -h 60% -d "#{pane_current_path}" \
  "git branch -a --sort=-committerdate --format='%(refname:short)' | fzf --reverse --prompt='checkout> ' | sed 's|^origin/||' | xargs -r git checkout"

# git + open-task segment on the right of the status bar
set -g status-interval 5
set -g status-right-length 150
set -g status-right "#(tmux-git-status '#{pane_current_path}') #[fg=#565f89]│ %H:%M "
