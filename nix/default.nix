{
  stdenvNoCC,
  lib,
  ...
}: {
  stdenvNoCC.mkDerivation= {
    name = "catppuccin-wallpapers";
    src = builtins.path {
      path = ../wallpapers;
    };

    preInstall = ''
      mkdir -p $out/share/wallpapers
    '';

    installPhase = ''
      runHook preInstall
      runHook postInstall
    '';

    meta = {
      description = "Reproducible and high quality Catppuccin wallpapers.";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [42willow];
    };
  };
}