{ compiler-nix-name ? "ghc922" }:
let
  # Read in the Niv sources
  sources = import ./nix/sources.nix {};
  # If ./nix/sources.nix file is not found run:
  #   niv init
  #   niv add input-output-hk/haskell.nix -n haskellNix

  # Fetch the haskell.nix commit we have pinned with Niv
  haskellNix = import sources.haskellNix { };
  # If haskellNix is not found run:
  #   niv add input-output-hk/haskell.nix -n haskellNix

  # Import nixpkgs and pass the haskell.nix provided nixpkgsArgs
  overlays = haskellNix.overlays ++ [
    (self: super: {
        # boost1 = super.boost.override { enableStatic = true; };
        # bucket = super.stdenv.mkDerivation {
        #     name = "bucket";
        #     src = super.lib.cleanSource ./go-src;
        #     buildInputs = [super.go];
        #     # dontConfigure = true;
        #     # dontBuild = true;
        #     # meta = with super.lib; {
        #     #     platforms = platforms.linux;
        #     # };
        # };
    })
  ];
  pkgs = import
    # haskell.nix provides access to the nixpkgs pins which are used by our CI,
    # hence you will be more likely to get cache hits when using these.
    # But you can also just use your own, e.g. '<nixpkgs>'.
    sources.nixpkgs
    # These arguments passed to nixpkgs, include some patches and also
    # the haskell.nix functionality itself as an overlay.
    (haskellNix.nixpkgsArgs // { inherit overlays; });
in pkgs.haskell-nix.cabalProject {
    # 'cleanGit' cleans a source directory based on the files known by git
    src = pkgs.haskell-nix.haskellLib.cleanGit {
      src = ./.;
      name = "simhash";
    };
    index-state = "2022-07-15T00:00:00Z";
    index-sha256 = "03b52bfba257b1106cf591fa4300abff1285735698cf532d274736ae4e394663";
    plan-sha256 = if compiler-nix-name == "ghc922" then "1i0rqy3krfcg9jlpfgjr5c47w23kqslqiaifbfv6wz4lhnj5zgkl" else null;
    materialized = if compiler-nix-name == "ghc922" then ./nix/materialized else null;
    # Specify the GHC version to use.
    compiler-nix-name = compiler-nix-name;
    # modules = [(
    #    {pkgs, ...}: {
    #      packages.simhash.configureFlags = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isMusl [
    #        "--ghc-option=-optl=-L${pkgs.boost1.out}/lib"
    #      ];
    #   })];
  }