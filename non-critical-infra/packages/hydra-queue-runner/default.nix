{
  rustPackages,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  protobuf,
  lib,
  makeWrapper,
  nix,
}:
rustPackages.rustPlatform.buildRustPackage rec {
  name = "hydra-queue-runner";
  version = "unstable-2025-07-07";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "hydra-queue-runner";
    rev = "7b1b4872a6b786d0080e6951c6a61e6da21c0401";
    hash = "sha256-C/jePC2yhAD62XuaZ0n3/sXnZwlmLpMMnvkWwYjGe3E=";
  };

  cargoDeps = rustPackages.rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-4nE2reDksPV3KyJ7T93hO6zBoeg6+pswe/KWdoBDjdw=";
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
    makeWrapper
  ];
  buildInputs = [
    openssl
    zlib
    protobuf
  ];

  postInstall = ''
    wrapProgram $out/bin/queue-runner \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
    wrapProgram $out/bin/builder \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  meta = {
    description = "Hydra Queue-Runner implemented in rust";
    homepage = "https://github.com/helsinki-systems/queue-runner";
    license = [ lib.licenses.gpl3 ];
    maintainers = [ lib.maintainers.conni2461 ];
    platforms = lib.platforms.all;
  };
}
