# ~/.config/home-manager/dev/default.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    deadnix
    nixd
    nixfmt
    nixpkgs-fmt
    statix
    ripgrep
    fd
    dust
    emacs-lsp-booster
    tectonic
    texlab
    textlint
    lua5_1
    luarocks
    proselint
    tree-sitter
    wl-clipboard
    zeromq
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # not needed
    #enableFishIntegration = true;
    config.global.hide_env_diff = true;
  };
}
