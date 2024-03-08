{ buildPlatform, writeText, cmake, conan, gnumake, fd, lib, llvmPackages_17
, ninja, system, xcodebuild, ... }:

let
  inherit (llvmPackages_17) clang bintools libcxx libcxxabi;
  inherit (lib) splitString take;

  arch = let arch = builtins.toString (take 1 (splitString "-" "${system}"));
  in if "${arch}" == "aarch64" then "armv8" else arch; # ¯\_(ツ)_/¯
  compiler.version = builtins.toString (take 1 (splitString "." clang.version));
in {
  name = "pdf-engine";

  buildInputs = [ libcxx libcxxabi ];
  nativeBuildInputs = [ cmake ninja bintools clang gnumake fd ]
    ++ [ (conan.overridePythonAttrs (_: { pytestCheckPhase = null; })) ]
    ++ lib.optional buildPlatform.isDarwin [ xcodebuild ];

  CONAN_BUILD_PROFILE = writeText "conan_build_profile" ''
    [settings]
    arch=${arch}
    build_type=Release
    compiler=clang
    compiler.cppstd=gnu20
    compiler.libcxx=libc++
    compiler.version=${compiler.version}
    os=Macos
  '';

  CONAN_HOST_PROFILE = writeText "conan_host_profile" ''
    [settings]
    arch=${arch}
    build_type=Release
    compiler=clang
    compiler.cppstd=gnu20
    compiler.libcxx=libc++
    compiler.version=${compiler.version}
    os=Macos
    os.version=11.0
    [conf]
    tools.build:compiler_executables={'c': '${clang}/bin/clang', 'cpp': '${clang}/bin/clang++'}
    tools.cmake.cmaketoolchain:generator=Ninja
  '';

  LDFLAGS = "-fuse-ld=lld";
}
