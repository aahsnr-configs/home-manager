# ~/.config/home-manager/pay-respects/default.nix
{ ... }:
let
  settingsPy = ''
    # The Fuck configuration file, managed by Home Manager.
    rules = [
        "cd_correction", "cd_mkdir", "git_add", "git_branch_delete", "git_checkout",
        "git_push", "grep_recursive", "history", "man", "mkdir_p", "nix_no_such_file",
        "no_command", "no_such_file", "pip_unknown_command", "sudo", "systemctl",
        "unknown_command" # A curated, extensive list of rules
    ]
    exclude_rules = []
    require_confirmation = True
    history_limit = 2000
    priority = "no_command=9999:sudo=100"
    env = {"LC_ALL": "C", "LANG": "C"}
  '';
in {
  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--alias" "f" ];
  };
  xdg.configFile."pay-respects/settings.py".text = settingsPy;
}
