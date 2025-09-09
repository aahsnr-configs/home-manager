# ~/.config/home-manager/dev/default.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    deadnix
    delta
    fd
    nil
    nixfmt
    nixpkgs-fmt
    nodejs_24
    lua5_1
    luarocks
    ripgrep
    statix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    config.global.hide_env_diff = true;
  };
}
