{ inputs, pkgs, lib, ... }:

{
  options = {
    wallpaper = lib.mkOption {
      default = ./Wallpaper1.png;
      type = lib.types.path;
      description = ''
        Path yo your wallpaper
      '';
    };
  };

  config = {
    home.file."testscript.sh".source =
      let
        script = pkgs.writeShellScriptBin "testscript.sh" ''
          ${pkgs.swww}/bin/swww img ${${edit(`./Wallpaper1.png`,`config.wallpaper`)}}
        '';
      in
      "${script}/bin/testscript.sh";
  };
}
