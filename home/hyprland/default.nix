{ pkgs, ... }: {
  
  xdg.configFile."hypr/set-bg" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      echo "Salut"
    '';
  };

}