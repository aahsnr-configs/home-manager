# ~/.config/home-manager/starship/default.nix
{ ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # Theme palette is managed by the catppuccin module.
    settings = {
      add_newline = false;
      continuation_prompt = "[>>](bold mauve) ";
      format = "$character";
      right_format =
        "$directory$git_branch$git_status$package$rust$nodejs$python$nix_shell$time";

      character = {
        success_symbol = "[◎](bold yellow)";
        error_symbol = "[○](bold subtext0)";
        vimcmd_symbol = "[■](bold green)";
      };

      directory = {
        use_os_path_sep = true;
        style = "bold blue";
        format = "[□ $path]($style) ";
        truncation_symbol = "…/";
        home_symbol = "⌂";
        read_only = " ◈";
        repo_root_style = "bold blue";
        repo_root_format =
          "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [△](bold blue)";
      };

      time = {
        disabled = false;
        format = "[⌂ $time]($style) ";
        time_format = "%R";
        style = "mauve";
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = "△ ";
        style = "bold blue";
      };

      git_status = {
        style = "bold blue";
        format = "[|$all_status$ahead_behind|]($style) ";
        staged = "▪\${count}";
        modified = "●\${count}";
        untracked = "○\${count}";
        deleted = "✕\${count}";
        conflicted = "[◪◦](italic pink)";
        ahead = "[▴│[\${count}](bold text)│](italic green)";
        behind = "[▿│[\${count}](bold text)│](italic red)";
        diverged =
          "[◇ ▴┤[\${ahead_count}](regular text)│▿┤[\${behind_count}](regular text)│](italic pink)";
        stashed = "[◃◈](italic text)";
      };

      nix_shell = {
        style = "bold italic dimmed blue";
        symbol = "✶";
        format = "[$symbol nix shell]($style)";
      };

      package = {
        format = "[pkg $symbol$version]($style) ";
        symbol = "◨ ";
        style = "bold yellow";
      };

      rust = {
        format = "[rs $symbol$version]($style) ";
        symbol = "⊃ ";
        style = "bold red";
      };

      nodejs = {
        format = "[node $symbol$version]($style) ";
        symbol = "◫ ";
        style = "bold green";
      };

      python = {
        format = "[py $symbol$version]($style) ";
        symbol = "⌊ ";
        style = "bold yellow";
      };
    };
  };
}
