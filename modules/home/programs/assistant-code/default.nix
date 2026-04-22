{
  config,
  lib,
  pkgs,
  ...
}:

let
  patchBin =
    package:
    pkgs.symlinkJoin {
      name = "${package.name}-with-configs";
      paths = [
        package
        pkgs.rtk
      ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${package.meta.mainProgram}
      '';
      # postBuild = ''
      #   wrapProgram $out/bin/${package.meta.mainProgram or package.pname} \
      #     --run 'set -a; source /run/agenix/my-secrets.env; set +a'
      # '';
    };
in
{
  # home.packages = [ pkgs.mcp-nixos ];
  programs.mcp = {
    enable = true;

    servers = {
      # nixos = {
      #   command = "mcp-nixos";
      #   type = "stdio";
      # };
    };
  };

  programs.claude-code = {
    package = patchBin pkgs.claude-code;
    agentsDir = ./agents;
    enableMcpIntegration = true;
  };

  programs.opencode = {
    package = patchBin pkgs.opencode;
    enableMcpIntegration = true;
  };

  programs.mistral-vibe = {
    package = patchBin pkgs.mistral-vibe;
    settings.mcp_servers = lib.mapAttrsToList (name: server: {
      inherit name;
      transport = server.type;
      command = server.command;
    }) config.programs.mcp.servers;
  };
}
