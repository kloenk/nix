{ pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions;
    [
      vscodevim.vim
      #ms-vscode.cpptools # using clangd
      llvm-org.lldb-vscode
      bbenoist.Nix
      justusadam.language-haskell
      #matklad.rust-analyzer
      redhat.vscode-yaml
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "vscode-clangd";
      publisher = "llvm-vs-code-extensions";
      version = "0.1.6";
      sha256 =
        "07bf54f19b5c9385014dfeee47015c73b6d3bac7f95db6d005f91bd5e7123c07";
    }]);
  vscode-with-extensions =
    pkgs.vscode-with-extensions.override { vscodeExtensions = extensions; };
in { environment.systemPackages = [ vscode-with-extensions pkgs.clang-tools ]; }
