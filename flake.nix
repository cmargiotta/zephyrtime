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
        nixConfig.sandbox = "relaxed";
        devShell = pkgs.devshell.mkShell {
          name = "zephyrtime";
          bash = {
            extra = ''
              export LD_INCLUDE_PATH="$DEVSHELL_DIR/include"
              export LD_LIB_PATH="$DEVSHELL_DIR/lib"
              export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
              export GNUARMEMB_TOOLCHAIN_PATH=${pkgs.gcc-arm-embedded}

              west init 2> /dev/null
              west update
              west zephyr-export

              source ./zephyr/zephyr-env.sh

              west completion bash > completion.sh
              source completion.sh
            '';
            interactive = "";
          };
          commands = [
            {
              name = "build";
              help = "Clear CMake cache and build the project";
              command = "rm build/CMakeCache.txt && west build --board=pinetime_devkit0";
            }
          ];
          env = [
          ];
          packages =
            let
              python_full = pkgs.python310.withPackages (p: with p; [
                west
                pyelftools
              ]);
            in
            with pkgs;
            [
              cmake
              ninja
              nrf5-sdk
              gcc-arm-embedded

              python_full
            ];
        };
      });
}
