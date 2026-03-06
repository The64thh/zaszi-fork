# ╔══════════════════════════════════════════════════════╗
# ║           fish config — gruvbox theme                ║
# ╚══════════════════════════════════════════════════════╝

# ── Environment ─────────────────────────────────────────
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# ── Path extras ─────────────────────────────────────────
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

# ── Gruvbox color palette ────────────────────────────────
set -g gruvbox_bg      282828
set -g gruvbox_bg1     3c3836
set -g gruvbox_bg2     504945
set -g gruvbox_fg      ebdbb2
set -g gruvbox_fg4     a89984
set -g gruvbox_red     cc241d
set -g gruvbox_green   98971a
set -g gruvbox_yellow  d79921
set -g gruvbox_blue    458588
set -g gruvbox_purple  b16286
set -g gruvbox_aqua    689d6a
set -g gruvbox_orange  d65d0e

# Bright variants
set -g gruvbox_bred    fb4934
set -g gruvbox_bgreen  b8bb26
set -g gruvbox_byellow fabd2f
set -g gruvbox_bblue   83a598
set -g gruvbox_bpurple d3869b
set -g gruvbox_baqua   8ec07c
set -g gruvbox_borange fe8019

# ── Fish colors ──────────────────────────────────────────
set -g fish_color_normal            $gruvbox_fg
set -g fish_color_command           $gruvbox_bblue
set -g fish_color_keyword           $gruvbox_bred
set -g fish_color_quote             $gruvbox_bgreen
set -g fish_color_redirection       $gruvbox_borange
set -g fish_color_end               $gruvbox_borange
set -g fish_color_error             $gruvbox_bred --bold
set -g fish_color_param             $gruvbox_fg
set -g fish_color_comment           $gruvbox_fg4
set -g fish_color_operator          $gruvbox_byellow
set -g fish_color_escape            $gruvbox_baqua
set -g fish_color_autosuggestion    $gruvbox_bg2
set -g fish_color_cancel            $gruvbox_bred
set -g fish_color_search_match      --background=$gruvbox_bg2

set -g fish_pager_color_prefix      $gruvbox_byellow --bold
set -g fish_pager_color_completion  $gruvbox_fg
set -g fish_pager_color_description $gruvbox_fg4
set -g fish_pager_color_progress    $gruvbox_fg4

# ── Greeting ─────────────────────────────────────────────
function fish_greeting
    # silent — no greeting clutter
end

# ── Prompt ───────────────────────────────────────────────
function fish_prompt
    set -l last_status $status
    set -l cwd (prompt_pwd --full-length-dirs 2 2>/dev/null; or basename (pwd))

    # status indicator
    if test $last_status -ne 0
        set_color $gruvbox_bred --bold
        echo -n "[$last_status] "
    end

    # user@host — only when SSH'd in
    if set -q SSH_TTY
        set_color $gruvbox_bgreen
        echo -n (whoami)
        set_color $gruvbox_fg4
        echo -n "@"
        set_color $gruvbox_byellow
        echo -n (hostname -s)
        set_color $gruvbox_fg4
        echo -n " "
    end

    # cwd
    set_color $gruvbox_bblue --bold
    echo -n $cwd

    # git branch
    set -l branch (git branch --show-current 2>/dev/null)
    if test -n "$branch"
        set_color $gruvbox_fg4
        echo -n " on "
        set_color $gruvbox_bpurple
        echo -n " $branch"

        # dirty indicator
        if not git diff --quiet 2>/dev/null
            set_color $gruvbox_byellow
            echo -n "*"
        end

        # untracked indicator
        if test -n "$(git ls-files --others --exclude-standard 2>/dev/null)"
            set_color $gruvbox_borange
            echo -n "?"
        end
    end

    echo

    # prompt char
    if fish_is_root_user
        set_color $gruvbox_bred --bold
        echo -n "# "
    else
        set_color $gruvbox_bgreen --bold
        echo -n "❯ "
    end

    set_color normal
end

# right prompt — execution time for slow commands
function fish_right_prompt
    set -l cmd_dur $CMD_DURATION
    if test $cmd_dur -ge 5000
        set_color $gruvbox_fg4
        set -l secs (math "$cmd_dur / 1000")
        echo -n "took $(math --scale=1 $secs)s"
        set_color normal
    end
end

# ── Abbreviations ────────────────────────────────────────
abbr -a -- - 'cd -'
abbr -a ... '../..'
abbr -a .... '../../..'

# git
abbr -a g    git
abbr -a ga   'git add'
abbr -a gaa  'git add -A'
abbr -a gc   'git commit -m'
abbr -a gca  'git commit --amend'
abbr -a gco  'git checkout'
abbr -a gd   'git diff'
abbr -a gl   'git log --oneline --graph --decorate'
abbr -a gp   'git push'
abbr -a gpl  'git pull'
abbr -a gs   'git status -sb'
abbr -a gst  'git stash'
abbr -a gsp  'git stash pop'

# system
abbr -a q    exit
abbr -a c    clear
abbr -a e    $EDITOR
abbr -a v    $VISUAL

# ls → eza/lsd fallback
if command -q eza
    abbr -a ls  'eza --icons --group-directories-first'
    abbr -a ll  'eza -l --icons --group-directories-first --git'
    abbr -a la  'eza -la --icons --group-directories-first --git'
    abbr -a lt  'eza --tree --icons -L 2'
else if command -q lsd
    abbr -a ls  'lsd --group-dirs first'
    abbr -a ll  'lsd -l --group-dirs first'
    abbr -a la  'lsd -la --group-dirs first'
    abbr -a lt  'lsd --tree --depth 2'
else
    abbr -a ls  'ls --color=auto --group-directories-first'
    abbr -a ll  'ls -lh --color=auto --group-directories-first'
    abbr -a la  'ls -lha --color=auto --group-directories-first'
end

# pacman / xbps (Void)
if command -q xbps-install
    abbr -a xi   'sudo xbps-install -S'
    abbr -a xr   'sudo xbps-remove -R'
    abbr -a xu   'sudo xbps-install -Su'
    abbr -a xq   'xbps-query -Rs'
end
if command -q pacman
    abbr -a pac   'sudo pacman -S'
    abbr -a pacr  'sudo pacman -Rns'
    abbr -a pacu  'sudo pacman -Syu'
    abbr -a pacq  'pacman -Ss'
end

# ── Keybindings ──────────────────────────────────────────
# Ctrl+F to accept autosuggestion word by word
bind \cf forward-word

# ── fzf integration (if installed) ───────────────────────
if command -q fzf
    set -gx FZF_DEFAULT_OPTS "
        --color=bg+:#3c3836,bg:#282828,spinner:#fb4934,hl:#928374
        --color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
        --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934
        --border=sharp
        --height=40%
        --layout=reverse
        --inline-info
    "
    # Ctrl+R for fzf history
    if command -q fzf_configure_bindings
        fzf_configure_bindings --history=\cr --directory=\cf
    end
end

# ── zoxide (smarter cd) ──────────────────────────────────
if command -q zoxide
    zoxide init fish | source
    abbr -a cd z
end

# ── direnv ───────────────────────────────────────────────
if command -q direnv
    direnv hook fish | source
end

# ── starship (opt-in override) ───────────────────────────
# Uncomment to replace the prompt above with starship.
# Make sure starship.toml has a gruvbox theme set.
# if command -q starship
#     starship init fish | source
# end
