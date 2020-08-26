# with import <nixpkgs> { }; # bring all of Nixpkgs into scope
{ stdenv }:

stdenv.mkDerivation rec {
  name = "julia_13-bin";
  src = fetchurl {
    url =
      "https://github.com/JuliaLang/julia/releases/download/v1.3.1/julia-1.3.1-full.tar.gz";
  };

  installPhase = ''
    tar xvfz $src
    cd julia-*
    make
    cp -r ./ "$out/"
  '';

}

