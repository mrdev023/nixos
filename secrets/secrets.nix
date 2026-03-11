let
  florian = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILKmziOZOXuH186ntLrUaSdKSnT4+wgiQBjFwQ4GxhHt";
in
{
  "ai_secrets.age".publicKeys = [ florian ];
}
