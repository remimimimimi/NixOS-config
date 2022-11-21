{ config, lib, pkgs, stdenv, fetchFromgitHub, ... }:

with lib;

stdenv.mkDerivation rec {
  pname = "discord-screenaudio";
  version = "1.4.3";
  src = fetchFromGitHub {
    owner = "maltejur";
    repo = "discord-screenaudio";
    rev = "v${version}";
    sha256 = "sha256-lMGMt0H1G8EN/7zSVSvU1yU4BYPnSF1vWmozLdrRTQk=";
  };
  makeFlags = [ "debug=no" "PREFIX=${placeholder "out"}" ];

  preConfigure = ''
    export version="v${version}"
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kak -ui json -e "kill 0"
  '';

  postInstall = ''
    # make share/kak/autoload a directory, so we can use symlinkJoin with plugins
    cd "$out/share/kak"
    autoload_target=$(readlink autoload)
    rm autoload
    mkdir autoload
    ln -s --relative "$autoload_target" autoload
  '';

  meta = {
    homepage = "http://kakoune.org/";
    description = "A vim inspired text editor";
    license = licenses.publicDomain;
    mainProgram = "kak";
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.unix;
  };
}
