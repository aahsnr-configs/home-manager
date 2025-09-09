# ~/.config/home-manager/yazi/default.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [ rich-cli ouch ]; # Preview dependencies
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    plugins = with pkgs.yaziPlugins; {
      inherit full-border toggle-pane smart-enter chmod;
      inherit rich-preview ouch;
      inherit jump-to-char;
      inherit git lazygit;
      inherit starship yatline;
    };
    settings = {
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
      opener = {
        edit = [{
          run = ''${pkgs.neovim}/bin/nvim "$@"'';
          block = true;
        }];
        image = [{ run = ''${pkgs.imv}/bin/imv "$@"''; }];
        video = [{ run = ''${pkgs.mpv}/bin/mpv "$@"''; }];
        audio = [{ run = ''${pkgs.mpv}/bin/mpv "$@"''; }];
        document = [{ run = ''${pkgs.zathura}/bin/zathura "$@"''; }];
        archive =
          [{ run = ''${pkgs.file-roller}/bin/file-roller "$@"''; }];
        fallback = [{ run = ''${pkgs.xdg-utils}/bin/xdg-open "$@"''; }];
      };
      open.rules = [
        {
          name = "*/";
          use = "edit";
        }
        {
          mime = "text/*";
          use = "edit";
        }
        {
          mime = "image/*";
          use = "image";
        }
        {
          mime = "video/*";
          use = "video";
        }
        {
          mime = "audio/*";
          use = "audio";
        }
        {
          mime = "application/pdf";
          use = "document";
        }
        {
          mime = "application/*zip";
          use = "archive";
        }
        {
          mime = "application/x-tar";
          use = "archive";
        }
        {
          name = "*";
          use = "fallback";
        }
      ];
    };
    keymap = {
      manager.prepend = [
        # Navigation
        {
          on = "h";
          run = "leave";
          desc = "Go back";
        }
        {
          on = "j";
          run = "arrow 1";
          desc = "Move down";
        }
        {
          on = "k";
          run = "arrow -1";
          desc = "Move up";
        }
        {
          on = "l";
          run = "enter";
          desc = "Enter";
        }
        {
          on = "G";
          run = "arrow bot";
          desc = "Move to bottom";
        }
        # File operations
        {
          on = "y";
          run = "yank";
          desc = "Copy";
        }
        {
          on = "d";
          run = "yank --cut";
          desc = "Cut";
        }
        {
          on = "p";
          run = "paste";
          desc = "Paste";
        }
        {
          on = [ "d" "d" ];
          run = "remove";
          desc = "Remove";
        }
        {
          on = "a";
          run = "create";
          desc = "Create";
        }
        {
          on = "r";
          run = "rename";
          desc = "Rename";
        }
        # Tabs
        {
          on = "t";
          run = "tab_create --current";
          desc = "New tab";
        }
        {
          on = "w";
          run = "tab_close";
          desc = "Close tab";
        }
        {
          on = "[";
          run = "tab_switch -1 --relative";
          desc = "Previous tab";
        }
        {
          on = "]";
          run = "tab_switch 1 --relative";
          desc = "Next tab";
        }
        # Miscellaneous
        {
          on = "q";
          run = "quit";
          desc = "Quit";
        }
        {
          on = ":";
          run = "shell --interactive";
          desc = "Shell";
        }
        {
          on = "!";
          run = "shell --block";
          desc = "Shell (blocking)";
        }
        {
          on = "?";
          run = "help";
          desc = "Help";
        }
        {
          on = "<C-h>";
          run = "hidden toggle";
          desc = "Toggle hidden";
        }
        {
          on = "<C-z>";
          run = "suspend";
          desc = "Suspend";
        }
      ];
    };
  };
}
