# gh.nix
{ pkgs, ... }:
{
  # -------------------------------------------------------------------
  # SSH Configuration for Multiple GitHub Accounts
  # -------------------------------------------------------------------
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com-aahsnr-configs" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_aahsnr_configs";
        extraOptions = {
          AddKeysToAgent = "yes";
          IdentitiesOnly = "yes";
        };
      };
      "github.com-aahsnr-personal" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_aahsnr_personal";
        extraOptions = {
          AddKeysToAgent = "yes";
          IdentitiesOnly = "yes";
        };
      };
      "github.com-aahsnr-work" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_aahsnr_work";
        extraOptions = {
          AddKeysToAgent = "yes";
          IdentitiesOnly = "yes";
        };
      };
      "github.com-aahsnr-common" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_aahsnr_common";
        extraOptions = {
          AddKeysToAgent = "yes";
          IdentitiesOnly = "yes";
        };
      };
    };
  };

  # -------------------------------------------------------------------
  # Git Configuration
  # -------------------------------------------------------------------
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    userName = "aahsnr-configs";
    userEmail = "ahsanur041@proton.me";

    extraConfig = {
      init.defaultBranch = "main";
      "url \"git@github.com-aahsnr-configs:\"" = {
        insteadOf = "git@github.com:";
      };
    };

    includes = [
      {
        condition = "gitdir:~/git-repos/personal/";
        contents = {
          user = {
            name = "aahsnr-personal";
            email = "ahsanur041@gmail.com";
          };
          # When in this directory, rewrite github.com to use the personal key
          url = {
            "git@github.com-aahsnr-personal:" = {
              insteadOf = "git@github.com:";
            };
          };
        };
      }
      {
        condition = "gitdir:~/git-repos/work/";
        contents = {
          user = {
            name = "aahsnr-work";
            email = "aahsnr041@proton.me";
          };
          # When in this directory, rewrite github.com to use the work key
          url = {
            "git@github.com-aahsnr-work:" = {
              insteadOf = "git@github.com:";
            };
          };
        };
      }
      {
        condition = "gitdir:~/git-repos/common/";
        contents = {
          user = {
            name = "aahsnr-common";
            email = "ahsan.05rahman@gmail.com";
          };
          # When in this directory, rewrite github.com to use the common key
          url = {
            "git@github.com-aahsnr-common:" = {
              insteadOf = "git@github.com:";
            };
          };
        };
      }
    ];
  };

  # -------------------------------------------------------------------
  # GitHub CLI (gh) Configuration
  # -------------------------------------------------------------------
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
      aliases = {
        "auth-configs" = "auth switch --hostname github.com --user aahsnr-configs";
        "auth-personal" = "auth switch --hostname github.com --user aahsnr-personal";
        "auth-work" = "auth switch --hostname github.com --user aahsnr-work";
        "auth-common" = "auth switch --hostname github.com --user aahsnr-common";
      };
    };
  };

  # -------------------------------------------------------------------
  # Helper Script for SSH Key Generation
  # -------------------------------------------------------------------
  home.file.".local/bin/setup-github-keys".text = ''
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Setting up SSH keys for multiple GitHub accounts..."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    generate_key() {
        local key_name="$1"
        local email="$2"
        local key_path="$HOME/.ssh/id_ed25519_$key_name"

        if [[ ! -f "$key_path" ]]; then
            echo "Generating Ed25519 SSH key for '$key_name'..."
            ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N ""
            chmod 600 "$key_path"
            chmod 644 "$key_path.pub"
            echo "-> Generated key: $key_path"
        else
            echo "-> Key for '$key_name' already exists: $key_path"
        fi
    }

    # --- IMPORTANT ---
    # Replace these with your actual GitHub account emails
    generate_key "aahsnr_configs" "ahsanur041@proton.me"
    generate_key "aahsnr_personal" "ahsanur041@gmail.com"
    generate_key "aahsnr_work" "aahsnr041@proton.me"
    generate_key "aahsnr_common" "ahsan.05rahman@gmail.com"

    echo ""
    echo "✅ Setup complete!"
    echo ""
    echo "Next Steps:"
    echo "1. Add the public keys to your respective GitHub accounts:"
    echo "   - Configs:  cat ~/.ssh/id_ed25519_aahsnr_configs.pub"
    echo "   - Personal: cat ~/.ssh/id_ed25519_aahsnr_personal.pub"
    echo "   - Work:     cat ~/.ssh/id_ed25519_aahsnr_work.pub"
    echo "   - Common:   cat ~/.ssh/id_ed25519_aahsnr_common.pub"
    echo ""
    echo "2. Authenticate each account with the GitHub CLI (run these one by one):"
    echo "   gh auth login --hostname github.com"
    echo "   (You will need to do this for each of your accounts)"
    echo ""
    echo "3. Test your SSH connections:"
    echo "   ssh -T git@github.com-aahsnr-configs"
    echo "   ssh -T git@github.com-aahsnr-personal"
    echo "   ssh -T git@github.com-aahsnr-work"
    echo "   ssh -T git@github.com-aahsnr-common"
    echo ""
    echo "4. Create your project directories:"
    echo "   mkdir -p ~/git-repos/configs ~/git-repos/personal ~/git-repos/work ~/git-repos/common"
  '';
}
