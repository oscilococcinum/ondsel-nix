{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    ondsel-appimage-x86_64-linux.url = "https://github.com/Ondsel-Development/FreeCAD/releases/download/2024.2.2/Ondsel_ES_2024.2.2.37240-Linux-x86_64.AppImage";
    ondsel-appimage-x86_64-linux.flake = false;
    ondsel-appimage-aarch64-linux.url = "https://github.com/Ondsel-Development/FreeCAD/releases/download/2024.2.2/Ondsel_ES_2024.2.2.37240-Linux-aarch64.AppImage";
    ondsel-appimage-aarch64-linux.flake = false;
    ondsel-appimage-pre-x86_64-linux.url = "https://github.com/Ondsel-Development/FreeCAD/releases/download/weekly-builds/Ondsel_ES_weekly-builds-38472-Linux-x86_64.AppImage";
    ondsel-appimage-pre-x86_64-linux.flake = false;
    ondsel-appimage-pre-aarch64-linux.url = "https://github.com/Ondsel-Development/FreeCAD/releases/download/weekly-builds/Ondsel_ES_weekly-builds-38472-Linux-aarch64.AppImage";
    ondsel-appimage-pre-aarch64-linux.flake = false;
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: 
      {
        name = system;
        value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {
          
          ondsel-appimage = appimageTools.wrapType2 {
            name = "ondsel";
            src = inputs."ondsel-appimage-${system}";
          };

          ondsel-appimage-pre = appimageTools.wrapType2 {
            name = "ondsel";
            src = inputs."ondsel-appimage-pre-${system}";
          };

          ondsel = pkgs.callPackage (import ./custompkgs/ondsel) { };
        };
      }
    )[ "x86_64-linux" "aarch64-linux" ]);
  };
}
