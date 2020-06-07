{ pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
    vscodevim.vim
    ms-vscode.cpptools
    llvm-org.lldb-vscode
    bbenoist.Nix
    justusadam.language-haskell
    #matklad.rust-analyzer
    redhat.vscode-yaml
  ]);
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in {
  environment.systemPackages = [
    vscode-with-extensions
  ];
}
