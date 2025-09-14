{ config, pkgs, ... }:

let
  # A helper function to package a shell script and add it to the user's path.
  mkScript = name: text: pkgs.writeShellScriptBin name text;

in
{
  # A list of packages to be installed into the user environment.
  home.packages = [
    (mkScript "launch_first_available" ''
      #!/usr/bin/env bash
      for cmd in "$@"; do
          [[ -z "$cmd" ]] && continue
          eval "command -v ''${cmd%% *}" >/dev/null 2>&1 || continue
          eval "$cmd" &
          exit
      done
    '')

    (mkScript "fuzzel-emoji" ''
      #!/bin/bash
      set -euo pipefail

      MODE="''${1:-type}"

      # The emoji data is stored in a variable and piped directly to fuzzel.
      # This is more robust than the previous method of using sed to read the script file itself.
      DATA="
      😀 grinning face face smile happy joy :D grin
      😃 grinning face with big eyes face happy joy haha :D :) smile funny
      😄 grinning face with smiling eyes face happy joy funny haha laugh like :D :) smile
      😁 beaming face with smiling eyes face happy smile joy kawaii
      😆 grinning squinting face happy joy lol satisfied haha face glad XD laugh
      😅 grinning face with sweat face hot happy laugh sweat smile relief
      🤣 rolling on the floor laughing face rolling floor laughing lol haha rofl
      😂 face with tears of joy face cry tears weep happy happytears haha
      🙂 slightly smiling face face smile
      🙃 upside down face face flipped silly smile
      😉 winking face face happy mischievous secret ;) smile eye
      😊 smiling face with smiling eyes face smile happy flushed crush embarrassed shy joy
      😇 smiling face with halo face angel heaven halo
      🥰 smiling face with hearts face love like affection valentines infatuation crush hearts adore
      😍 smiling face with heart eyes face love like affection valentines infatuation crush heart
      🤩 star struck face smile starry eyes grinning
      😘 face blowing a kiss face love like affection valentines infatuation kiss
      😗 kissing face love like face 3 valentines infatuation kiss
      ☺️ smiling face face blush massage happiness
      😚 kissing face with closed eyes face love like affection valentines infatuation kiss
      😙 kissing face with smiling eyes face affection valentines infatuation kiss
      😋 face savoring food happy joy tongue smile face silly yummy nom delicious savouring
      😛 face with tongue face prank childish playful mischievous smile tongue
      😜 winking face with tongue face prank childish playful mischievous smile wink tongue
      🤪 zany face face goofy crazy
      😝 squinting face with tongue face prank playful mischievous smile tongue
      🤑 money mouth face face rich dollar money
      🤗 hugging face face smile hug
      🤭 face with hand over mouth face whoops shock surprise
      🤫 shushing face face quiet shhh
      🤔 thinking face face hmmm think consider
      🤐 zipper mouth face face sealed zipper secret
      🤨 face with raised eyebrow face distrust scepticism disapproval disbelief surprise
      😐 neutral face indifference meh :| neutral
      😑 expressionless face face indifferent - - meh deadpan
      😶 face without mouth face hellokitty
      😏 smirking face face smile mean prank smug sarcasm
      😒 unamused face indifference bored straight face serious sarcasm unimpressed skeptical dubious side eye
      🙄 face with rolling eyes face eyeroll frustrated
      😬 grimacing face face grimace teeth
      🤥 lying face face lie pinocchio
      😌 relieved face face relaxed phew massage happiness
      😔 pensive face face sad depressed upset
      😪 sleepy face face tired rest nap
      🤤 drooling face face
      😴 sleeping face face tired sleepy night zzz
      😷 face with medical mask face sick ill disease
      🤒 face with thermometer sick temperature thermometer cold fever
      🤕 face with head bandage injured clumsy bandage hurt
      🤢 nauseated face face vomit gross green sick throw up ill
      🤮 face vomiting face sick
      🤧 sneezing face face gesundheit sneeze sick allergy
      🥵 hot face face feverish heat red sweating
      🥶 cold face face blue freezing frozen frostbite icicles
      🥴 woozy face face dizzy intoxicated tipsy wavy
      😵 dizzy face spent unconscious xox dizzy
      🤯 exploding head face shocked mind blown
      🤠 cowboy hat face face cowgirl hat
      🥳 partying face face celebration woohoo
      😎 smiling face with sunglasses face cool smile summer beach sunglass
      🤓 nerd face face nerdy geek dork
      🧐 face with monocle face stuffy wealthy
      😕 confused face face indifference huh weird hmmm :/
      😟 worried face face concern nervous :(
      🙁 slightly frowning face face frowning disappointed sad upset
      ☹️ frowning face face sad upset frown
      😮 face with open mouth face surprise impressed wow whoa :O
      😯 hushed face face woo shh
      😲 astonished face face xox surprised poisoned
      😳 flushed face face blush shy flattered sex
      🥺 pleading face face begging mercy
      😦 frowning face with open mouth face aw what
      😧 anguished face face stunned nervous
      😨 fearful face face scared terrified nervous oops huh
      😰 anxious face with sweat face nervous sweat
      😥 sad but relieved face face phew sweat nervous
      😢 crying face face tears sad depressed upset :'(
      😭 loudly crying face face cry tears sad upset depressed sob
      😱 face screaming in fear face munch scared omg
      😖 confounded face face confused sick unwell oops :S
      😣 persevering face face sick no upset oops
      😞 disappointed face face sad upset depressed :(
      😓 downcast face with sweat face hot sad tired exercise
      😩 weary face face tired sleepy sad frustrated upset
      😫 tired face sick whine upset frustrated
      🥱 yawning face tired sleepy
      😤 face with steam from nose face gas phew proud pride
      😡 pouting face angry mad hate despise
      😠 angry face mad face annoyed frustrated
      🤬 face with symbols on mouth face swearing cursing cssing profanity expletive
      😈 smiling face with horns devil horns
      👿 angry face with horns devil angry horns
      💀 skull dead skeleton creepy death
      ☠️ skull and crossbones poison danger deadly scary death pirate evil
      💩 pile of poo hankey shitface fail turd shit
      🤡 clown face face
      👹 ogre monster red mask halloween scary creepy devil demon japanese ogre
      👺 goblin red evil mask monster scary creepy japanese goblin
      👻 ghost halloween spooky scary
      👽 alien UFO paul weird outer space
      👾 alien monster game arcade play
      🤖 robot computer machine bot
      😺 grinning cat animal cats happy smile
      😸 grinning cat with smiling eyes animal cats smile
      😹 cat with tears of joy animal cats haha happy tears
      😻 smiling cat with heart eyes animal love like affection cats valentines heart
      😼 cat with wry smile animal cats smirk
      😽 kissing cat animal cats kiss
      🙀 weary cat animal cats munch scared scream
      😿 crying cat animal tears weep sad cats upset cry
      😾 pouting cat animal cats
      🙈 see no evil monkey monkey animal nature haha
      🙉 hear no evil monkey animal monkey nature
      🙊 speak no evil monkey monkey animal nature omg
      💋 kiss mark face lips love like affection valentines
      💌 love letter email like affection envelope valentines
      💘 heart with arrow love like heart affection valentines
      💝 heart with ribbon love valentines
      💖 sparkling heart love like affection valentines
      💗 growing heart like love affection valentines pink
      💓 beating heart love like affection valentines pink heart
      💞 revolving hearts love like affection valentines
      💕 two hearts love like affection valentines heart
      💟 heart decoration purple-square love like
      ❣️ heart exclamation decoration love
      💔 broken heart sad sorry break heart heartbreak
      ❤️ red heart love like valentines
      🧡 orange heart love like affection valentines
      💛 yellow heart love like affection valentines
      💚 green heart love like affection valentines
      💙 blue heart love like affection valentines
      💜 purple heart love like affection valentines
      🤎 brown heart coffee
      🖤 black heart evil
      🤍 white heart pure
      "

      # Trim leading whitespace from the DATA variable before piping to fuzzel
      emoji="$(echo -e "''${DATA}" | sed 's/^[ \t]*//' | fuzzel --match-mode fzf --dmenu | cut -d ' ' -f 1 | tr -d '\n')"

      # Exit gracefully if fuzzel was cancelled and no emoji was selected
      if [[ -z "''${emoji}" ]]; then
          exit 0
      fi

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
    '')

    (mkScript "record" ''
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
    '')

    (mkScript "start_geoclue_agent" ''
      #!/usr/bin/env bash

      # Check if GeoClue agent is already running
      if pgrep -f 'geoclue-2.0/demos/agent' > /dev/null; then
          echo "GeoClue agent is already running."
          exit 0
      fi

      # List of known possible GeoClue agent paths
      AGENT_PATHS="
      /usr/libexec/geoclue-2.0/demos/agent
      /usr/lib/geoclue-2.0/demos/agent
      "

      # Find the first valid agent path
      for path in $AGENT_PATHS; do
          if [ -x "$path" ]; then
              echo "Starting GeoClue agent from: $path"
              "$path" & # starts in the background
              exit 0
          fi
      done

      # If we got here, none of the paths worked
      echo "GeoClue agent not found in known paths."
      echo "Please install GeoClue or update the script with the correct path."
      exit 1
    '')

    (mkScript "workspace_action" ''
      #!/usr/bin/env bash
      curr_workspace="$(hyprctl activeworkspace -j | jq -r ".id")"
      dispatcher="$1"
      shift ## The target is now in $1, not $2

      if [[ -z "''${dispatcher}" || "''${dispatcher}" == "--help" || "''${dispatcher}" == "-h" || -z "$1" ]]; then
        echo "Usage: $0 <dispatcher> <target>"
        exit 1
      fi
      if [[ "$1" == *"+"* || "$1" == *"-"* ]]; then ## Is this something like r+1 or -1?
        hyprctl dispatch "''${dispatcher}" "$1" ## $1 = workspace id since we shifted earlier.
      elif [[ "$1" =~ ^[0-9]+$ ]]; then ## Is this just a number?
        # FIX: Removed extra parentheses that caused a syntax error in bash.
        target_workspace=$(( (curr_workspace - 1) / 10 * 10 + $1 ))
        hyprctl dispatch "''${dispatcher}" "''${target_workspace}"
      else
       hyprctl dispatch "''${dispatcher}" "$1" ## In case the target in a string, required for special workspaces.
       exit 1
      fi
    '')

    (mkScript "zoom" ''
      #!/usr/bin/env bash

      # Controls Hyprland's cursor zoom_factor, clamped between 1.0 and 3.0

      # Get current zoom level
      get_zoom() {
          hyprctl getoption -j cursor:zoom_factor | jq '.float'
      }

      # Clamp a value between 1.0 and 3.0
      clamp() {
          local val="$1"
          awk "BEGIN {
              v = ''$val;
              if (v < 1.0) v = 1.0;
              if (v > 3.0) v = 3.0;
              print v;
          }"
      }

      # Set zoom level
      set_zoom() {
          local value="$1"
          clamped=$(clamp "$value")
          hyprctl keyword cursor:zoom_factor "$clamped"
      }

      case "$1" in
          reset)
              set_zoom 1.0
              ;;
          increase)
              if [[ -z "$2" ]]; then
                  echo "Usage: $0 increase STEP"
                  exit 1
              fi
              current=$(get_zoom)
              new=$(awk "BEGIN { print ''$current + ''$2 }")
              set_zoom "$new"
              ;;
          decrease)
              if [[ -z "$2" ]]; then
                  echo "Usage: $0 decrease STEP"
                  exit 1
              fi
              current=$(get_zoom)
              new=$(awk "BEGIN { print ''$current - ''$2 }")
              set_zoom "$new"
              ;;
          *)
              echo "Usage: $0 {reset|increase STEP|decrease STEP}"
              exit 1
              ;;
      esac
    '')
  ];
}
