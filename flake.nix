{
  description = "pdf engine";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  nixConfig = {
    extra-substituters = "https://cachix.cachix.org";
    extra-trusted-public-keys =
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  };

  outputs = { nixpkgs, flake-utils, pre-commit-hooks, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) nixfmt callPackage;

        shared = { inherit pre-commit-hooks system; };
        common = callPackage ./nix/common.nix shared // { };

      in {
        checks = { pre-commit-check = callPackage ./nix/checks.nix shared; };

        formatter = nixfmt;
        devShells = {
          default = callPackage ./nix/shells.nix {
            inherit (self.checks.${system}) pre-commit-check;
            inherit common;
          };
        };
      });
}
