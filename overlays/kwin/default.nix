self: super: {
  kdePackages = super.kdePackages.overrideScope (kde-self: kde-super: rec {
    kwin = kde-super.kwin.overrideAttrs (oldAttrs: rec {
      patches = oldAttrs.patches ++ [
        ./5511.patch # https://invent.kde.org/plasma/kwin/-/merge_requests/5511
      ];
    });
  });
}