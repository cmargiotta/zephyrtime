{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils/master";
    devshell.url = "github:numtide/devshell/master";
  };
  outputs = { self, nixpkgs, flake-utils, devshell }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay ];
          config.allowUnfree = true;
        };

      in
      rec {
        devShell = pkgs.devshell.mkShell {
          name = "zephyrtime";
          bash = {
            extra = ''
              export LD_INCLUDE_PATH="$DEVSHELL_DIR/include"
              export LD_LIB_PATH="$DEVSHELL_DIR/lib"
              west init 2> /dev/null
              west update
              west zephyr-export
            '';
            interactive = "";
          };
          commands = [
          ];
          env = [
          ];
          packages = [
            pkgs.python39Packages.west
          ];
        };
      });
}
