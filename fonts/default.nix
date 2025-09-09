{ pkgs, ... }:
{
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Rubik Medium" ];
        serif = [
          "Noto Serif"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };

  };

  home.packages = with pkgs; [
    corefonts
    dina-font
    (google-fonts.override { fonts = [ "Inter" ]; })
    jetbrains-mono
    liberation_ttf
    material-symbols
    mplus-outline-fonts.githubRelease
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.caskaydia-mono
    noto-fonts-color-emoji
    powerline-fonts
    terminus_font
    twemoji-color-font
    ubuntu_font_family
    ubuntu-sans
    vistafonts
  ];

}
