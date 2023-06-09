{
  lib,
  stdenvNoCC,
  fetchFromSourcehut,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "iosevka-comfy";
  version = "1.3.0";

  src = fetchFromSourcehut {
    owner = "protesilaos";
    repo = pname;
    rev = version;
    sha256 = "sha256-ajzUbobNf+Je8ls9htOCLPsB0OPSiqZzrc8bO6hQvio=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 iosevka-comfy/ttf/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://protesilaos.com/emacs/iosevka-comfy-pictures";
    description = "Custom build of Iosevka font";
    longDescription = ''
      Customised build of the Iosevka typeface, with a consistent
      rounded style and overrides for almost all individual glyphs
      in both roman (upright) and italic (slanted) variants.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
