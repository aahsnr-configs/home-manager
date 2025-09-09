# ~/.config/home-manager/bat/default.nix
{ pkgs, ... }: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batdiff batman prettybat ];
    config = {
      style = "numbers,changes,header";
      "show-all" = true;
      "italic-text" = "always";
      color = "always";
    };
  };
}
