{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
        "uasm"
      ];
    };
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.uasm
      ];
      env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ ];
    };
  };
}

