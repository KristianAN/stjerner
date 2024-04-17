{
  description = "stjerner-api";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShell = let

          buildDeps = with pkgs; [
            stack 
            haskell.compiler.ghc964
            zlib
          ];

        in
          pkgs.mkShell {
            name = "kvalreg-gateway-api-dev-shell";
            buildInputs =  buildDeps;
            shellHook =  "";
          };
      }
    );
}

