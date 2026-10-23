{
  description = "n-choo's Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      mkNvimConfig =
        pkgs:
        pkgs.runCommand "nvim-config" { } ''
          mkdir -p $out/nvim
          cp ${./init.lua} $out/nvim/init.lua
          cp ${./lazy-lock.json} $out/nvim/lazy-lock.json
          cp -r ${./lua} $out/nvim/lua
        '';

      mkNvim =
        pkgs:
        pkgs.writeShellApplication {
          name = "nvim";
          runtimeInputs = with pkgs; [
            neovim
            coreutils
            git
            ripgrep
            fd
            curl
            unzip
            gzip
            gnutar
            gnumake
            stdenv.cc
          ];
          text = ''
            real_config="''${XDG_CONFIG_HOME:-$HOME/.config}"
            tmp_config="$(mktemp -d "''${TMPDIR:-/tmp}/nvim-nix.XXXXXX")"

            cleanup() {
              rm -rf "$tmp_config"
            }
            trap cleanup EXIT HUP INT TERM

            shopt -s nullglob dotglob
            for entry in "$real_config"/*; do
              name="$(basename "$entry")"
              if [ "$name" = "nvim" ]; then
                continue
              fi
              ln -s "$entry" "$tmp_config/$name"
            done

            # Writable copy so lazy.nvim can manage its lockfile at runtime.
            cp -r ${mkNvimConfig pkgs}/nvim "$tmp_config/nvim"
            chmod -R u+w "$tmp_config/nvim"

            export XDG_CONFIG_HOME="$tmp_config"

            # Keep this config's plugins separate from any other Neovim setup.
            export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}/nvim-nix"

            nvim "$@"
          '';
        };

    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = mkNvim pkgs;
          nvim = mkNvim pkgs;
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };
        nvim = {
          type = "app";
          program = "${self.packages.${system}.nvim}/bin/nvim";
        };
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
