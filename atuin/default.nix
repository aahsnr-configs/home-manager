# ~/.config/home-manager/atuin/default.nix
{ ... }: {
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ]; # For zsh-vi-mode compatibility
    settings = {
      log = "warn";
      sync_frequency = "10m";
    };
  };
}
