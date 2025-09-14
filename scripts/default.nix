# scripts/default.nix
{ config, pkgs, lib, ... }:

let
  cfg = config.home.aahsnr.scripts;

  # A helper to read scripts from a file and make them executable packages
  mkScript = name: text: pkgs.writeShellScriptBin name text;

  # Define all the scripts to be packaged
  scripts = {
    launch_first_available = mkScript "launch_first_available" ''
      #!/usr/bin/env bash
      for cmd in "$@"; do
          [[ -z "$cmd" ]] && continue
          eval "command -v ''${cmd%% *}" >/dev/null 2>&1 || continue
          eval "$cmd" &
          exit
      done
    '';

    fuzzel-emoji = mkScript "fuzzel-emoji" ''
      #!/bin/bash
      set -euo pipefail

      MODE="''${1:-type}"

      emoji="$(sed '1,/^### DATA ###$/d' "$0" | fuzzel --match-mode fzf --dmenu | cut -d ' ' -f 1 | tr -d '\n')"

      case "$MODE" in
          type)
              wtype "''${emoji}" || wl-copy "''${emoji}"
              ;;
          copy)
              wl-copy "''${emoji}"
              ;;
          both)
              wtype "''${emoji}" || true
              wl-copy "''${emoji}"
              ;;
          *)
              echo "Usage: $0 [type|copy|both]"
              exit 1
              ;;
      esac
      exit
      ### DATA ###
      # ... (emoji data is embedded in the script) ...
    '';

    record = mkScript "record" ''
      #!/usr/bin/env bash

      getdate() {
          date '+%Y-%m-%d_%H.%M.%S'
      }
      getaudiooutput() {
          pactl list sources | grep 'Name' | grep 'monitor' | cut -d ' ' -f2
      }
      getactivemonitor() {
          hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
      }

      xdgvideo="$(xdg-user-dir VIDEOS)"
      if [[ $xdgvideo = "$HOME" ]]; then
        unset xdgvideo
      fi
      mkdir -p "''${xdgvideo:-$HOME/Videos}"
      cd "''${xdgvideo:-$HOME/Videos}" || exit

      if pgrep wf-recorder > /dev/null; then
          notify-send "Recording Stopped" "Stopped" -a 'Recorder' &
          pkill wf-recorder &
      else
          if [[ "$1" == "--fullscreen-sound" ]]; then
              notify-send "Starting recording" 'recording_'"$(getdate)"'.mp4' -a 'Recorder' & disown
              wf-recorder -o "$(getactivemonitor)" --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --audio="$(getaudiooutput)"
          elif [[ "$1" == "--fullscreen" ]]; then
              notify-send "Starting recording" 'recording_'"$(getdate)"'.mp4' -a 'Recorder' & disown
              wf-recorder -o "$(getactivemonitor)" --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t
          else
              if ! region="$(slurp 2>&1)"; then
                  notify-send "Recording cancelled" "Selection was cancelled" -a 'Recorder' & disown
                  exit 1
              fi
              notify-send "Starting recording" 'recording_'"$(getdate)"'.mp4' -a 'Recorder' & disown
              if [[ "$1" == "--sound" ]]; then
                  wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --geometry "$region" --audio="$(getaudiooutput)"
              else
                  wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --geometry "$region"
              fi
          fi
      fi
    '';

    start_geoclue_agent = mkScript "start_geoclue_agent" ''
      #!/usr/bin/env bash
      if pgrep -f 'geoclue-2.0/demos/agent' > /dev/null; then
          echo "GeoClue agent is already running."
          exit 0
      fi
      AGENT_PATHS="
      /usr/libexec/geoclue-2.0/demos/agent
      /usr/lib/geoclue-2.0/demos/agent
      "
      for path in $AGENT_PATHS; do
          if [ -x "$path" ]; then
              echo "Starting GeoClue agent from: $path"
              "$path" &
              exit 0
          fi
      done
      echo "GeoClue agent not found in known paths."
      exit 1
    '';

    workspace_action = mkScript "workspace_action" ''
      #!/usr/bin/env bash
      curr_workspace="$(hyprctl activeworkspace -j | jq -r ".id")"
      dispatcher="$1"
      shift
      if [[ -z "''${dispatcher}" || "''${dispatcher}" == "--help" || "''${dispatcher}" == "-h" || -z "$1" ]]; then
        echo "Usage: $0 <dispatcher> <target>"
        exit 1
      fi
      if [[ "$1" == *"+"* || "$1" == *"-"* ]]; then
        hyprctl dispatch "''${dispatcher}" "$1"
      elif [[ "$1" =~ ^[0-9]+$ ]]; then
        target_workspace=$(((($curr_workspace - 1) / 10 ) * 10 + $1))
        hyprctl dispatch "''${dispatcher}" "''${target_workspace}"
      else
       hyprctl dispatch "''${dispatcher}" "$1"
       exit 1
      fi
    '';

    zoom = mkScript "zoom" ''
      #!/usr/bin/env bash
      get_zoom() {
          hyprctl getoption -j cursor:zoom_factor | jq '.float'
      }
      clamp() {
          local val="$1"
          awk "BEGIN {
              v = $val;
              if (v < 1.0) v = 1.0;
              if (v > 3.0) v = 3.0;
              print v;
          }"
      }
      set_zoom() {
          local value="$1"
          clamped=$(clamp "$value")
          hyprctl keyword cursor:zoom_factor "$clamped"
      }
      case "$1" in
          reset) set_zoom 1.0 ;;
          increase)
              [[ -z "$2" ]] && echo "Usage: $0 increase STEP" && exit 1
              current=$(get_zoom)
              new=$(awk "BEGIN { print $current + $2 }")
              set_zoom "$new"
              ;;
          decrease)
              [[ -z "$2" ]] && echo "Usage: $0 decrease STEP" && exit 1
              current=$(get_zoom)
              new=$(awk "BEGIN { print $current - $2 }")
              set_zoom "$new"
              ;;
          *) echo "Usage: $0 {reset|increase STEP|decrease STEP}" && exit 1 ;;
      esac
    '';
  };
in
{
  options.home.aahsnr.scripts = {
    enable = lib.mkEnableOption "Enable custom scripts module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with scripts; [
      launch_first_available
      fuzzel-emoji
      record
      start_geoclue_agent
      workspace_action
      zoom
    ];
  };
}
