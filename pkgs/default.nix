{ pkgs, ... }:
{
  home.packages = with pkgs; [
    adw-gtk3
    delta
    lua5_1
    luarocks
    nix-prefetch-git
    nix-prefetch-github
    nil
    nixfmt
    nixpkgs-fmt
    proselint
    python313Packages.pynvim
    tectonic
    texlab
    textlint
    zeromq
  ];
}
