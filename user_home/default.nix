{ pkgs, system, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    alacritty
    any-nix-shell
    dmenu
    firefox
    font-awesome_4
    git
    google-chrome
    grim
    htop
    i3status-rust
    jq
    kanshi
    kitty
    libnotify
    mako
    nerdfonts
    pasystray
    pavucontrol
    slack
    slurp
    swayidle
    swaylock
    vim
    wdisplays
    wf-recorder
    wl-clipboard
    wl-mirror 
    xwayland
  ];
  
  fonts.fontconfig.enable = true;

  programs.nushell = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      set tabstop=2
      set shiftwidth=2
      set expandtab
    '';
    plugins =
      with pkgs.vimPlugins; [
        vim-surround
        zenburn

        # Basics
        vim-sensible
        # File Tree
        nvim-web-devicons
        nvim-tree-lua
        # Git info
        gitsigns-nvim
        # Indent lines
        indent-blankline-nvim
        # Auto close
        nvim-autopairs
        # Notify window
        nvim-notify
        # Commenting
        comment-nvim

      ];

    extraLuaConfig = ''
      require("nvim-tree").setup()

      require('nvim-web-devicons').setup{}
      require('nvim-autopairs').setup{}
    '';
    extraPackages = with pkgs; [
      # Language Servers
      # Bash
      nodePackages.bash-language-server
      # Nix
      nixpkgs-fmt
      ripgrep
      fd
    ];

  };


  programs.tmux = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = { vim = "nvim"; dc = "docker-compose"; };
    initExtra = ''
            any-nix-shell zsh --info-right | source /dev/stdin
            #source ~/.zshrc_functions
            export PATH=$PATH:~/bin:~/bin/bats/bin:~/.mix/escripts
            alias create-typescript-react=npx create-react-app --template typescript
            test -r /home/nico/.opam/opam-init/init.zsh && . /home/nico/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
            PROMPT='%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%X]}%{$reset_color%} %{$fg[white]%}[%~]%{$reset_color%} $(git_prompt_info)
      %{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} '
    '';
    envExtra = ''
      GOPATH='/home/nico/.gopath'
    '';
  };


  # Enable Oh-my-zsh
  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "candy";
    plugins = [ "git" "sudo" "docker" "mix" "jump" "golang" ];
  };


  programs.git = {
    enable = true;
    userName = "Nicolas Savois";
    userEmail = "nicolas.savois@gmail.com";
    extraConfig = {
      push = {
        default = "current";
      };
      credential.helper = "cache";
      init.defaultBranch = "main";

    };
    #extraConfig = ''
    #[push]
    #default = current
    #'';
  };


  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      shell = {
        program = "/home/nico/.nix-profile/bin/zsh";
      };

      window.dimensions = {
        lines = 3;
        columns = 200;
      };

      colors = {
        primary = {
          background = "#2e3440";
          foreground = "#d8dee9";
          dim_foreground = "#a5abb6";
        };
        cursor = {
          text = "#2e3440";
          cursor = "#d8dee9";
        };
        vi_mode_cursor = {
          text = "#2e3440";
          cursor = "#d8dee9";
        };
        selection = {
          text = "CellForeground";
          background = "#4c566a";
        };
        search = {
          matches = {
            foreground = "CellBackground";
            background = "#88c0d0";
          };
        };
        normal = {
          black = "#3b4252";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#88c0d0";
          white = "#e5e9f0";
        };
        bright = {
          black = "#4c566a";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#8fbcbb";
          white = "#eceff4";
        };
        dim = {
          black = "#373e4d";
          red = "#94545d";
          green = "#809575";
          yellow = "#b29e75";
          blue = "#68809a";
          magenta = "#8c738c";
          cyan = "#6d96a5";
          white = "#aeb3bb";
        };
      };
    };
  };



  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "alacritty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
      bars = [
        {
          statusCommand = "i3status-rs ~/.config/i3status-rust/config.toml";
        }
      ];

    };
    extraConfig = ''
        # Keyboard Layout
        input "type:keyboard" {
          xkb_file ~/.config/xkb/custom.xkb
        }

        # Brightness
        bindsym XF86MonBrightnessDown exec light -U 10
        bindsym XF86MonBrightnessUp exec light -A 10

        # Default Workspace with 3 different keyboard layout.
        bindcode Mod4+10 workspace 1
        bindcode Mod4+11 workspace 2
        bindcode Mod4+12 workspace 3
        bindcode Mod4+13 workspace 4
        bindcode Mod4+14 workspace 5
        bindcode Mod4+15 workspace 6
        bindcode Mod4+16 workspace 7
        bindcode Mod4+17 workspace 8
        bindcode Mod4+18 workspace 9
        bindcode Mod4+19 workspace 10

        bindcode Mod4+Shift+10 move container to workspace 1
        bindcode Mod4+Shift+11 move container to workspace 2
        bindcode Mod4+Shift+12 move container to workspace 3
        bindcode Mod4+Shift+13 move container to workspace 4
        bindcode Mod4+Shift+14 move container to workspace 5
        bindcode Mod4+Shift+15 move container to workspace 6
        bindcode Mod4+Shift+16 move container to workspace 7
        bindcode Mod4+Shift+17 move container to workspace 8
        bindcode Mod4+Shift+18 move container to workspace 9
        bindcode Mod4+Shift+19 move container to workspace 10

        bindsym Mod4+m move workspace to output right
        bindsym Mod4+shift+m move workspace to output left

        # Volume
        bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
        bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
        bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
        bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle

        bindsym Mod4+Print exec grim -g "$(slurp -d)" - | wl-copy
        bindsym Mod4+Shift+Print exec grim - | wl-copy
        bindsym Mod4+Ctrl+Print exec grim -g "$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" - | wl-copy

        set $mode_system System (Ctrl+l) lock, (Ctrl+e) logout, (Ctrl+s) suspend, (Ctrl+h) hibernate, (Ctrl+r) reboot, (Ctrl+Shift+s) shutdown
        mode "$mode_system" {
            bindsym l mode "default"; exec 'notify-send "lock"'
            bindsym e mode "default"; exec 'notify-send "logout"'
            bindsym s mode "default"; exec '${pkgs.systemd}/bin/systemctl suspend'
            bindsym h mode "default"; exec 'notify-send "hibernate"'
            bindsym r mode "default"; exec 'shutdown -r now'
            bindsym Shift+s mode "default"; exec 'shutdown -P now'
            # back to normal: Enter or Escape
            bindsym Return mode "default"
            bindsym Escape mode "default"
        }
        bindsym Mod4+End mode "$mode_system"

        set $present Present: Mirror (m), Set-output (o), Set-region (r), Unset Region (Shit+r), Set Scaling (s), Freeze (f), Custom (c)
        mode "$present" {
            # command starts mirroring
            bindsym m mode "default"; exec wl-present mirror
            # these commands modify an already running mirroring window
            bindsym o mode "default"; exec wl-present set-output
            bindsym r mode "default"; exec wl-present set-region
            bindsym Shift+r mode "default"; exec wl-present unset-region
            bindsym s mode "default"; exec wl-present set-scaling
            bindsym f mode "default"; exec wl-present toggle-freeze
            bindsym c mode "default"; exec wl-present custom

            # return to default mode
            bindsym Return mode "default"
            bindsym Escape mode "default"
        }
        bindsym Mod4+p mode "$present"

      '';
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
    '';
    wrapperFeatures.gtk = true;
  };

  programs.swaylock = {
    enable = true;
  };


 services.copyq.enable = true;

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
      { event = "lock"; command = "lock"; }
      { event = "after-resume"; command = "swaymsg 'output * dpms on'"; }
    ];
    timeouts = [
      { timeout = 30; command = "swaymsg 'output * dpms off'"; }
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
      { timeout = 450; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];


  };


  home.file.".config/xkb/custom.xkb".source = ./layout/custom.xkb;
  home.file.".config/i3status-rust/config.toml".source = ./i3status-rust.toml;


  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.home-manager = {
    enable = true;
    path = "…";
  };
}
