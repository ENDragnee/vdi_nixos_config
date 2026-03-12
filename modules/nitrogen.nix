{
  config,
  pkgs,
  ...
}: {
  # 1. Declaratively place the wallpaper file into your ~/.config/wallpapers/ directory
  xdg.configFile."wallpapers/lock.jpg".source = ./assets/wallpapers/lock.jpg;

  # 2. Configure Nitrogen's main settings (telling it where to look for wallpapers)
  xdg.configFile."nitrogen/nitrogen.cfg".text = ''
    [geometry]
    posx=1062
    posy=297
    sizex=1920
    sizey=1080

    [nitrogen]
    view=icon
    recurse=true
    sort=alpha
    icon_caps=false
    dirs=${config.xdg.configHome}/wallpapers;
  '';

  # 3. Configure the saved background state
  # When Openbox runs `nitrogen --restore`, it reads this file.
  # We define both [xin_-1] (fallback) and [xin_0] (primary monitor) to ensure it applies safely.
  xdg.configFile."nitrogen/bg-saved.cfg".text = ''
    [xin_-1]
    file=${config.xdg.configHome}/wallpapers/lock.jpg
    mode=4
    bgcolor=#000000

    [xin_0]
    file=${config.xdg.configHome}/wallpapers/lock.jpg
    mode=4
    bgcolor=#000000

    [xin_1]
    file=${config.xdg.configHome}/wallpapers/lock.jpg
    mode=4
    bgcolor=#000000
  '';
}
