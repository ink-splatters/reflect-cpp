{ common, mkShell, llvmPackages_17, pre-commit-check, ... }:

mkShell.override { inherit (llvmPackages_17) stdenv; } {
  name = "cpp-shell";

  inherit (common)
    buildInputs nativeBuildInputs LDFLAGS CONAN_BUILD_PROFILE
    CONAN_HOST_PROFILE;

  shellHook = pre-commit-check.shellHook + ''
    export PS1="\n\[\033[01;36m\]‹⊂˖˖› \\$ \[\033[00m\]"
    echo -e "\nto install pre-commit hooks:\n\x1b[1;37mnix develop .#install-hooks\x1b[00m"
  '';
}

