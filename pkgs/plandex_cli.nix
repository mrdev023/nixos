{
  lib,
  fetchFromGitHub,
  buildGoModule
}:

buildGoModule rec {
  pname = "plandex-cli";
  version = "v0.8.2";

  vendorHash = "sha256-+giOD3sB/SnyccFqoGnC2+DVR9u+MF+mqTFSoEEQqRw=";

  src = fetchFromGitHub {
    owner = "mrdev023";
    repo = "plandex";
    rev = "18da990f9cea059015b93e76420d14205a43a876";
    hash = "sha256-bHbPN8b3k4K2V5ul17U8O6RjBQdT3xT1I31Pe94Q52c=";
  };

  modRoot = "app/cli";

  ldflags = [
    "-s -w -X github.com/${src.owner}/${src.repo}/app/cli/main.version.Version=${version}"
  ];

  meta = with lib; {
    description = "An AI coding engine for complex tasks";
    homepage = "https://github.com/plandex-ai/plandex";
    license = licenses.agpl3Only;
  };
}
