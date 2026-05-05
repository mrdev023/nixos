{ ... }:

{
  programs.ssh = {
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        identitiesOnly = true;
      };
      "ssh.mrdev023.fr" = {
        port = 7943;
        user = "florian";
        identityFile = "~/.ssh/lattepanda_delta_3_ssh.pub";
      };
      "git.mrdev023.fr" = {
        port = 22;
        user = "git";
        identityFile = "~/.ssh/forgejo_ssh.pub";
      };
      "invent.kde.org" = {
        port = 22;
        user = "git";
        identityFile = "~/.ssh/kde_ssh.pub";
      };
    };
  };
}
