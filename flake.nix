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
        pkgs.nasm
        pkgs.pkg-config
        pkgs.openssl
        pkgs.cacert
        pkgs.rustc
        pkgs.cargo
        pkgs.gcc_multi
        pkgs.gnumake
        pkgs.gdb
        pkgs.glibc_multi
      ];

      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ ];
    };
  };
}

