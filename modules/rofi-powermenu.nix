{
  config,
  pkgs,
  ...
}: {
  # FIXED: Changed from "launchers/type-1" to "applets/type-1" to match theme.bash
  xdg.configFile."rofi/applets/type-1/style-1.rasi".text = ''
    /**
     *
     * Author : Aditya Shakya (adi1090x)
     * Github : @adi1090x
     *
     * Rofi Theme File
     * Rofi Version: 1.7.3
     **/

    /*****----- Configuration -----*****/
    configuration {
        modi:                       "drun,run,filebrowser";
        show-icons:                 false;
        display-drun:               " Apps";
        display-run:                " Run";
        display-filebrowser:        " Files";
        display-window:             " Windows";
        drun-display-format:        "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
        window-format:              "{w} · {c} · {t}";
    }

    /*****----- Global Properties -----*****/
    /* FIXED: Using absolute paths so Rofi doesn't get confused */
    @import                          "~/.config/rofi/applets/shared/colors.rasi"
    @import                          "~/.config/rofi/applets/shared/fonts.rasi"

    * {
        border-colour:               var(selected);
        handle-colour:               var(selected);
        background-colour:           var(background);
        foreground-colour:           var(foreground);
        alternate-background:        var(background-alt);
        normal-background:           var(background);
        normal-foreground:           var(foreground);
        urgent-background:           var(urgent);
        urgent-foreground:           var(background);
        active-background:           var(active);
        active-foreground:           var(background);
        selected-normal-background:  var(selected);
        selected-normal-foreground:  var(background);
        selected-urgent-background:  var(active);
        selected-urgent-foreground:  var(background);
        selected-active-background:  var(urgent);
        selected-active-foreground:  var(background);
        alternate-normal-background: var(background);
        alternate-normal-foreground: var(foreground);
        alternate-urgent-background: var(urgent);
        alternate-urgent-foreground: var(background);
        alternate-active-background: var(active);
        alternate-active-foreground: var(background);
    }

    /*****----- Main Window -----*****/
    window {
        transparency:                "real";
        location:                    center;
        anchor:                      center;
        fullscreen:                  false;
        width:                       800px;
        x-offset:                    0px;
        y-offset:                    0px;

        enabled:                     true;
        margin:                      0px;
        padding:                     0px;
        border:                      0px solid;
        border-radius:               20px;
        border-color:                @border-colour;
        cursor:                      "default";
        background-color:            @background-colour;
    }

    /*****----- Main Box -----*****/
    mainbox {
        enabled:                     true;
        spacing:                     10px;
        margin:                      0px;
        padding:                     40px;
        border:                      0px solid;
        border-radius:               0px 0px 0px 0px;
        border-color:                @border-colour;
        background-color:            transparent;
        children:                    [ "inputbar", "message", "listview", "mode-switcher" ];
    }

    /*****----- Inputbar -----*****/
    inputbar {
        enabled:                     true;
        spacing:                     10px;
        margin:                      0px;
        padding:                     0px;
        border:                      0px solid;
        border-radius:               0px;
        border-color:                @border-colour;
        background-color:            transparent;
        text-color:                  @foreground-colour;
        children:                    [ "prompt", "textbox-prompt-colon", "entry" ];
    }

    prompt {
        enabled:                     true;
        background-color:            inherit;
        text-color:                  inherit;
    }
    textbox-prompt-colon {
        enabled:                     true;
        expand:                      false;
        str:                         "::";
        background-color:            inherit;
        text-color:                  inherit;
    }
    entry {
        enabled:                     true;
        background-color:            inherit;
        text-color:                  inherit;
        cursor:                      text;
        placeholder:                 "Search...";
        placeholder-color:           inherit;
    }
    num-filtered-rows {
        enabled:                     true;
        expand:                      false;
        background-color:            inherit;
        text-color:                  inherit;
    }
    textbox-num-sep {
        enabled:                     true;
        expand:                      false;
        str:                         "/";
        background-color:            inherit;
        text-color:                  inherit;
    }
    num-rows {
        enabled:                     true;
        expand:                      false;
        background-color:            inherit;
        text-color:                  inherit;
    }
    case-indicator {
        enabled:                     true;
        background-color:            inherit;
        text-color:                  inherit;
    }

    /*****----- Listview -----*****/
    listview {
        enabled:                     true;
        columns:                     2;
        lines:                       10;
        cycle:                       true;
        dynamic:                     true;
        scrollbar:                   true;
        layout:                      vertical;
        reverse:                     false;
        fixed-height:                true;
        fixed-columns:               true;

        spacing:                     5px;
        margin:                      0px;
        padding:                     0px;
        border:                      0px solid;
        border-radius:               0px;
        border-color:                @border-colour;
        background-color:            transparent;
        text-color:                  @foreground-colour;
        cursor:                      "default";
    }
    scrollbar {
        handle-width:                10px ;
        handle-color:                @handle-colour;
        border-radius:               10px;
        background-color:            @alternate-background;
    }

    /*****----- Elements -----*****/
    element {
        enabled:                     true;
        spacing:                     10px;
        margin:                      0px;
        padding:                     5px 10px;
        border:                      0px solid;
        border-radius:               20px;
        border-color:                @border-colour;
        background-color:            transparent;
        text-color:                  @foreground-colour;
        cursor:                      pointer;
    }
    element normal.normal {
        background-color:            var(normal-background);
        text-color:                  var(normal-foreground);
    }
    element normal.urgent {
        background-color:            var(urgent-background);
        text-color:                  var(urgent-foreground);
    }
    element normal.active {
        background-color:            var(active-background);
        text-color:                  var(active-foreground);
    }
    element selected.normal {
        background-color:            var(selected-normal-background);
        text-color:                  var(selected-normal-foreground);
    }
    element selected.urgent {
        background-color:            var(selected-urgent-background);
        text-color:                  var(selected-urgent-foreground);
    }
    element selected.active {
        background-color:            var(selected-active-background);
        text-color:                  var(selected-active-foreground);
    }
    element alternate.normal {
        background-color:            var(alternate-normal-background);
        text-color:                  var(alternate-normal-foreground);
    }
    element alternate.urgent {
        background-color:            var(alternate-urgent-background);
        text-color:                  var(alternate-urgent-foreground);
    }
    element alternate.active {
        background-color:            var(alternate-active-background);
        text-color:                  var(alternate-active-foreground);
    }
    element-icon {
        background-color:            transparent;
        text-color:                  inherit;
        size:                        24px;
        cursor:                      inherit;
    }
    element-text {
        background-color:            transparent;
        text-color:                  inherit;
        highlight:                   inherit;
        cursor:                      inherit;
        vertical-align:              0.5;
        horizontal-align:            0.0;
    }

    /*****----- Mode Switcher -----*****/
    mode-switcher{
        enabled:                     true;
        spacing:                     10px;
        margin:                      0px;
        padding:                     0px;
        border:                      0px solid;
        border-radius:               0px;
        border-color:                @border-colour;
        background-color:            transparent;
        text-color:                  @foreground-colour;
    }
    button {
        padding:                     5px 10px;
        border:                      0px solid;
        border-radius:               20px;
        border-color:                @border-colour;
        background-color:            @alternate-background;
        text-color:                  inherit;
        cursor:                      pointer;
    }
    button selected {
        background-color:            var(selected-normal-background);
        text-color:                  var(selected-normal-foreground);
    }

    /*****----- Message -----*****/
    message {
        enabled:                     true;
        margin:                      0px;
        padding:                     0px;
        border:                      0px solid;
        border-radius:               0px 0px 0px 0px;
        border-color:                @border-colour;
        background-color:            transparent;
        text-color:                  @foreground-colour;
    }
    textbox {
        padding:                     5px 10px;
        border:                      0px solid;
        border-radius:               20px;
        border-color:                @border-colour;
        background-color:            @alternate-background;
        text-color:                  @foreground-colour;
        vertical-align:              0.5;
        horizontal-align:            0.0;
        highlight:                   none;
        placeholder-color:           @foreground-colour;
        blink:                       true;
        markup:                      true;
    }
    error-message {
        padding:                     10px;
        border:                      2px solid;
        border-radius:               20px;
        border-color:                @border-colour;
        background-color:            @background-colour;
        text-color:                  @foreground-colour;
    }
  '';

  xdg.configFile."rofi/colors/onedark.rasi".text = ''
    /**
     *
     * Author : Aditya Shakya (adi1090x)
     * Github : @adi1090x
     *
     * Colors
     **/

    * {
        background:     #1E2127FF;
        background-alt: #282B31FF;
        foreground:     #FFFFFFFF;
        selected:       #61AFEFFF;
        active:         #98C379FF;
        urgent:         #E06C75FF;
    }
  '';

  xdg.configFile."rofi/applets/shared/colors.rasi".text = ''
    /**
     *
     * Author : Aditya Shakya (adi1090x)
     * Github : @adi1090x
     *
     * Colors
     *
     **/

    /* Import color-scheme from `colors` directory */

    @import "~/.config/rofi/colors/onedark.rasi"
  '';

  xdg.configFile."rofi/applets/shared/fonts.rasi".text = ''
    /**
     *
     * Author : Aditya Shakya (adi1090x)
     * Github : @adi1090x
     *
     * Fonts
     *
     **/

    * {
        font: "RobotoMono Nerd Font 10";
    }
  '';

  xdg.configFile."rofi/applets/shared/theme.bash".text = ''
    ## Current Theme

    type="$HOME/.config/rofi/applets/type-1"
    style='style-1.rasi'
  '';

  xdg.configFile."rofi/applets/bin/powermenu.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      ## Author  : Aditya Shakya (adi1090x)
      ## Github  : @adi1090x
      #
      ## Applets : Power Menu

      # Import Current Theme
      source "$HOME"/.config/rofi/applets/shared/theme.bash
      theme="$type/$style"

      # Theme Elements
      prompt="`hostname`"
      mesg="Uptime : `uptime -p | sed -e 's/up //g'`"

      if [[ ( "$theme" == *'type-1'* ) || ( "$theme" == *'type-3'* ) || ( "$theme" == *'type-5'* ) ]]; then
              list_col='1'
              list_row='6'
      elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
              list_col='6'
              list_row='1'
      fi

      # Options
      # FIXED: Escaped ''${theme} so Nix ignores it
      layout=`cat ''${theme} | grep 'USE_ICON' | cut -d'=' -f2`

      if [[ "$layout" == 'NO' ]]; then
              option_1=" Lock"
              option_2=" Logout"
              option_3=" Suspend"
              option_4=" Hibernate"
              option_5=" Reboot"
              option_6=" Shutdown"
              yes=' Yes'
              no=' No'
      else
              option_1=""
              option_2=""
              option_3=""
              option_4=""
              option_5=""
              option_6=""
              yes=''
              no=''
      fi

      # Rofi CMD
      rofi_cmd() {
              rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
                      -theme-str 'textbox-prompt-colon {str: "";}' \
                      -dmenu \
                      -p "$prompt" \
                      -mesg "$mesg" \
                      -markup-rows \
                      -theme ''${theme} # FIXED
      }

      # Pass variables to rofi dmenu
      run_rofi() {
              echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
      }

      # Confirmation CMD
      confirm_cmd() {
              rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
                      -theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
                      -theme-str 'listview {columns: 2; lines: 1;}' \
                      -theme-str 'element-text {horizontal-align: 0.5;}' \
                      -theme-str 'textbox {horizontal-align: 0.5;}' \
                      -dmenu \
                      -p 'Confirmation' \
                      -mesg 'Are you Sure?' \
                      -theme ''${theme} # FIXED
      }

      # Ask for confirmation
      confirm_exit() {
              echo -e "$yes\n$no" | confirm_cmd
      }

      # Confirm and execute
      confirm_run () {
              selected="$(confirm_exit)"
              if [[ "$selected" == "$yes" ]]; then
              ''${1} && ''${2} && ''${3} # FIXED
          else
              exit
          fi
      }

      # Execute Command
      run_cmd() {
              if [[ "$1" == '--opt1' ]]; then
                      betterlockscreen -l
              elif [[ "$1" == '--opt2' ]]; then
                      confirm_run 'kill -9 -1'
              elif [[ "$1" == '--opt3' ]]; then
                      confirm_run 'mpc -q pause' 'amixer set Master mute' 'systemctl suspend'
              elif [[ "$1" == '--opt4' ]]; then
                      confirm_run 'systemctl hibernate'
              elif [[ "$1" == '--opt5' ]]; then
                      confirm_run 'systemctl reboot'
              elif [[ "$1" == '--opt6' ]]; then
                      confirm_run 'systemctl poweroff'
              fi
      }

      # Actions
      # FIXED: Escaped ''${chosen}
      chosen="$(run_rofi)"
      case ''${chosen} in
          $option_1)
                      run_cmd --opt1
              ;;
          $option_2)
                      run_cmd --opt2
              ;;
          $option_3)
                      run_cmd --opt3
              ;;
          $option_4)
                      run_cmd --opt4
              ;;
          $option_5)
                      run_cmd --opt5
              ;;
          $option_6)
                      run_cmd --opt6
              ;;
      esac
    '';
  };
}
