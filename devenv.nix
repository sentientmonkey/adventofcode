{ pkgs, ... }:

{
  packages = [ pkgs.git ];

  languages.ruby = {
    enable = true;
    package = pkgs.ruby_3_3;
  };
  languages.racket = { enable = true; };
}
