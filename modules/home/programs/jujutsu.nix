{ ... }:

{
  config.programs.jujutsu.settings = {
    user = {
      name = "Florian RICHER";
      email = "florian.richer@protonmail.com";
    };

    signing = {
      behavior = "drop";
      backend = "gpg";
      key = "B19E3F4A2D806AB4793FDF2FC73D37CBED7BFC77";
    };

    git = {
      sign-on-push = true;
    };
  };
}
