# ~/.config/home-manager/zsh/default.nix
{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableVteIntegration = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      save = 50000;
      size = 50000;
      share = true;
      ignoreDups = true;
    };
    completionInit = "autoload -U compinit && compinit";
    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      ZSH_AUTOSUGGEST_USE_ASYNC = "true";
    };
    dirHashes = {
      docs = "$HOME/Documents";
      notes = "$HOME/Documents/Notes";
      dots = "$HOME/Dev/nix-dots";
      dl = "$HOME/Download";
      vids = "$HOME/Videos";
      music = "$HOME/Music";
      media = "/run/media/$USER";
    };
    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
      }
      {
        name = "zsh-autopair";
        src = pkgs.zsh-autopair;
      }
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
      }
    ];
    shellAliases = {
      rmi = "sudo rm -rf";
      vi = "nvim";
      du = "dust";
      grep = "rg";
      cat = "bat --paging=never";
      nrs = "sudo nixos-rebuild switch";
      nrb = "sudo nixos-rebuild boot";
      nixs = "nix-shell -p";
      hm-switch = "home-manager switch";
      sctl = "systemctl";
      sctle = "sudo systemctl enable";
      sctls = "sudo systemctl start";
      gg = "lazygit";
    };
    initContent = ''
            # ===== Zsh Options =====
            setopt EXTENDED_HISTORY HIST_VERIFY PUSHD_IGNORE_DUPS

            # ===== fzf-tab configuration =====
            zstyle ':fzf-tab:complete:*' fzf-preview \
              '[[ -f $realpath ]] && bat --color=always --style=numbers $realpath || eza --tree --level=2 $realpath'

            # ===== zsh-vi-mode configuration =====
            ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

            # ===== Helper Functions =====

            # Atuin search widget keybindings
            bindkey -M vicmd '^R' _atuin_search_widget
            bindkey -M viins '^R' _atuin_search_widget

            # Yazi cd on quit
            function yy() {
              local tmp="$ (mktemp -t "yazi-cwd.XXXXXX")"
              yazi "$@" --cwd-file="$tmp"
              if cwd="$(< "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                cd -- "$cwd"
              fi
              rm -f -- "$tmp"
            }
            compdef yy=yazi

            # Ripgrep with fzf
            function rgfzf() {
              rg --color=always --line-number "$@" | fzf --ansi \
                --preview 'bat --style=numbers --color=always --line-range :500 {1}' \
                --preview-window 'right:60%:wrap'
            }

            # tldr with fzf
            function tldr-fzf() {
              tldr --list | fzf --preview 'tldr {1}' --preview-window right:70%
            }

      if uwsm check may-start && uwsm select; then
      	exec uwsm start default
      fi
    '';
  };
}
