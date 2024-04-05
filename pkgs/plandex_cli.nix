{
  lib,
  fetchFromGitHub,
  buildGoModule
}:

buildGoModule {
  pname = "plandex-cli";
  version = "v0.8.1";
  vendorHash = lib.fakeHash;
  src = fetchFromGitHub {
    owner = "plandex-ai";
    repo = "plandex";
    rev = "cli/v0.8.1";
    hash = "sha256-+1EETcqjvyi9W+y6nhcEFbc2bv2EjFEBxoxMrWPz7Ro=";
  };
  
  modRoot = "app/cli";
  
  meta = with lib; {
    description = "An AI coding engine for complex tasks";
    homepage = "https://github.com/plandex-ai/plandex";
    license = licenses.agpl3Only;
  };
}