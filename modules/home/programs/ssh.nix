{ ... }:

{
  programs.ssh = {
    enableDefaultConfig = false;
    matchBlocks = {
      "ssh.mrdev023.fr" = {
        port = 7943;
        user = "florian";
        identityFile = "~/.ssh/lattepanda_delta_3_ssh.pub";
        identitiesOnly = true;
      };
      "git.mrdev023.fr" = {
        port = 22;
        user = "git";
        identityFile = "~/.ssh/forgejo_ssh.pub";
        identitiesOnly = true;
      };
      "invent.kde.org" = {
        port = 22;
        user = "git";
        identityFile = "~/.ssh/kde_ssh.pub";
        identitiesOnly = true;
      };
    };
  };
}
