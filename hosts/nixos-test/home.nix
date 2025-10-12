{ ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.florian = {
    isNormalUser = true;
    description = "florian";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    initialPassword = "password"; # Unsafe but not important because it's just a VM to test configuration
  };

  home-manager.users.florian.imports = [ ./homes/florian.nix ];
}
