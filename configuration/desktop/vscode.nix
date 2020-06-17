{ pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions;
    [
      vscodevim.vim
      #ms-vscode.cpptools # using clangd
      llvm-org.lldb-vscode
      bbenoist.Nix
      justusadam.language-haskell
      matklad.rust-analyzer
      redhat.vscode-yaml
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-clangd";
        publisher = "llvm-vs-code-extensions";
        version = "0.1.6";
        sha256 =
          "07bf54f19b5c9385014dfeee47015c73b6d3bac7f95db6d005f91bd5e7123c07";
      }
      {
        name = "crates";
        publisher = "serayuzgur";
        version = "0.5.0";
        sha256 =
          "d6afdaab02729ee2251d67c21a456e47069c26ef3b1897bdc1a6c4e766180dbc";
      }
    ]);
  vscode-with-extensions =
    pkgs.vscode-with-extensions.override { vscodeExtensions = extensions; };
in { environment.systemPackages = [ vscode-with-extensions pkgs.clang-tools ]; }
