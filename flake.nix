{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            openssl
            pkg-config
            cargo-watch
            rust-analyzer
            (rust-bin.nightly.latest.default.override {
              extensions = [ "rust-src" ];
            })
            trunk
            postgresql
          ] ++ lib.optionals pkgs.stdenv.isDarwin (with darwin.apple_sdk.frameworks;
            [
              SystemConfiguration
              Security
            ]);
          shellHook = ''
            ### Environment variables
            export RUST_LOG=debug
            export PATH=$PATH:/Users/v3lix/.cargo/bin
          '';
        };
      }
    );
}
