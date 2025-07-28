{ ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.florian = {
    isNormalUser = true;
    description = "florian";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };

  home-manager.users.florian.imports = [ ./homes/florian.nix ];
}
