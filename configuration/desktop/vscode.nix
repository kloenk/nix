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
      {
        name = "github-vscode-theme";
        publisher = "GitHub";
        version = "1.1.2";
        sha256 =
          "b50310ea33e319ceeb3dd1d227f7f5c006fb64e4ccb8cdacff752cc58c99908f";
      }
      {
        name = "vscode-pull-request-github";
        publisher = "GitHub";
        version = "0.17.0";
        sha256 =
          "0a3c11f4d7bb68b5ea04373cb1d53e579870706ddf59f19f06c7c338877641bd";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "10.2.2";
        sha256 =
          "ab22b88129b348fb0412615a8988d23ac0aff0be5c64fe8d34996199fe35d701";
      }
      {
        name = "todo-view";
        publisher = "wmlph";
        version = "0.1.1";
        sha256 = "sha256-g1B7KfY55SxHOmq6cbQf03Yl0zxUXHuorEqLlZ+3qU0=";
      }
      {
        name = "todoist";
        publisher = "waymondo";
        version = "0.1.1";
        sha256 = "sha256-mLTH/8Cke/t3srF/MJQdB+pTmVKEusy4/6NYDpQU7N0=";
      }
      {
        name = "vscode-trello-viewer";
        publisher = "Ho-Wan";
        version = "0.6.0";
        sha256 =
          "df8bcba3f01ac5efc8aebe870eeb46c059f75f627d98940d7d0039e906ede562";
      }
      {
        name = "sourcegraph";
        publisher = "sourcegraph";
        version = "1.1.0";
        sha256 = "sha256-LD2UBQReZ9LonXHaQfjrPRFgI+6clmPsRPCNLC117rI=";
      }
      {
        name = "licenser";
        publisher = "ymotongpoo";
        version = "1.5.0";
        sha256 = "sha256-WmWS6bi1xgug9MxGQDuhqg7vJMAbd7hpTLlqEDzOSrs=";
      }
      {
        name = "vscode-elixir";
        publisher = "mjmcloug";
        version = "1.1.0";
        sha256 = "sha256-EE4x75ljGu212gqu1cADs8bsXLaToVaDnXHOqyDlR04=";
      }
      {
        name = "swdc-vscode";
        publisher = "softwaredotcom";
        version = "2.2.42";
        sha256 = "sha256-BmKfYHTVnUfcJzR6vy4SJANQ98u99x2pCinliUb/bm8=";
      }
    ]);
  vscode-with-extensions =
    pkgs.vscode-with-extensions.override { vscodeExtensions = extensions; };
in { environment.systemPackages = [ vscode-with-extensions pkgs.clang-tools ]; }
