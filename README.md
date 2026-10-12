# tatr-mac

A tiny task tracker for macOS (works on Linux too) that reads and writes
[tsoding/tatr](https://github.com/tsoding/tatr)'s on-disk format, plus a tmux
kit for keeping tasks and git state one keystroke away while you code.

Not affiliated with tatr. No tatr code is used; tatr itself is Linux-only for
now, this is an independent Python implementation of its file layout. Tasks
created here remain valid tatr tasks.

## Task format

```
tasks/
  20261012-143000/          # HUID: UTC timestamp, one folder per task
    TASK.md
```

```markdown
# Fix the flaky upload test
- STATUS: OPEN
- PRIORITY: 10
- TAGS: bug, ci
- STATE: doing

Free-form description, links, notes...
```

`STATUS`, `PRIORITY` and `TAGS` are tatr's properties. `STATE`
(todo/doing/blocked/review) is an extra property tatr ignores.

## Install

```sh
brew install tmux fzf lazygit   # python3 ships with macOS
./install.sh                    # symlinks tt, git-dash, tmux-git-status into ~/.local/bin
```

## `tt`

```sh
tt                          # open tasks, sorted by priority
tt ls all | tt ls closed    # include / only closed
tt ls :bug :ci              # filter by tags (all must match)
tt new "title" -p 10 -t bug,ci
tt show ID | tt edit ID     # edit opens $EDITOR (default vim)
tt close ID | tt reopen ID
tt state ID blocked
tt prio ID 10               # lower sorts first
tt note ID "found the root cause"
tt pick                     # fzf picker
```

`ID` is any unique piece of the HUID or title.

### Where tasks show up
Tasks belong to the directory that holds `tasks/`. They are visible there and in
every directory below it, never above it: from a parent or unrelated directory
`tt` lists nothing and `tt new` refuses. Resolution order: `$TT_DIR`, then the
nearest `tasks/` in the current directory or a parent, then `$TT_DEFAULT_DIR`
(`~/.tasks`) only while global mode is on.

```sh
tt init              # start tasks/ in the current directory
tt global on|off     # global fallback; ctrl-g toggles it in the popup
```

The popup prompt shows `[here: <project>]` or `[global: <project>]`, and the
status bar marks global mode with a `g`.

Only tag filtering is implemented, not the full Tatr Query Language.

## tmux kit

Add to `~/.tmux.conf`:

```tmux
source-file /path/to/tatr-mac/tmux/tatr-mac.tmux
```

| Key        | What                                                            |
|------------|-----------------------------------------------------------------|
| prefix `T` | task popup: enter edit, ctrl-x close, ctrl-n new, ctrl-s cycle state, ctrl-a show all, ctrl-g global mode |
| prefix `g` | lazygit popup                                                   |
| prefix `G` | toggle a live git dashboard pane (branch, upstream, remotes, worktrees, stashes, changes, log graph, tasks). Outside a repo it uses the single repo one level down, or lists them all |
| prefix `B` | fuzzy branch checkout                                           |

The status bar shows branch, upstream, ahead/behind, staged/changed/untracked
counts, worktree count and open task count for the focused pane's directory.

### Ghostty (optional)

`ghostty/keybinds.conf` maps Alt+d / Alt+g / Alt+b / Alt+c to the bindings
above (assumes a `Ctrl-a` prefix), and makes the left Option key act as Alt.

## Keeping tasks out of a repo

If tasks live inside a git repo you contribute to but shouldn't be committed,
add `tasks/` to `.git/info/exclude`, or keep `tasks/` in a parent directory;
`tt` finds it by walking up.

## License

MIT
