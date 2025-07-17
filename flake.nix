{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      fs = nixpkgs.lib.fileset;
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-tetex;
        inherit (pkgs.texlivePackages) titlesec enumitem;
      };
    in {
    packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
        pname = "cv";
        version = "1.0";

        src = fs.toSource {
          root = ./.;
          fileset = ./Albin_Vass_CV.tex;
        };

        dontUnpack = true;

        buildInputs = [ tex ];
        buildPhase = ''
          pdflatex \
            -interaction=nonstopmode \
            $src/Albin_Vass_CV.tex
        '';

        installPhase = ''
          mkdir $out
          mv Albin_Vass_CV.pdf $out/
        '';
      };
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [
          tex
      ];
    };
  };
}
