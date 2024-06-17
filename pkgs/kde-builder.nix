{
  pkgs
}:

with pkgs;
stdenv.mkDerivation rec {
  pname = "kde-builder";
  version = "50a5c745e5bc6a47779abc4e441e6a13749d9f67";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "sdk";
    repo = "kde-builder";
    rev = version;
    sha256 = "l3V9EyiOZXKMUuUvlX8awWbHiaufc9XjNhdPb1YnaKw=";
  };

  # https://invent.kde.org/sdk/kde-builder/-/blob/45eaedd70d39059a2fa94f4774b9c0642d02ec21/scripts/initial_setup.sh#L23
  buildInputs = [
    (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
      dbus-python
      pyyaml
      setproctitle
    ]))
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/
  '';
}