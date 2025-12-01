{ pkgs, ... }:

{
  packages = [ pkgs.git ];

  languages.ruby = {
    enable = true;
    package = pkgs.ruby_3_3;
  };
  languages.racket = {
    enable = false; # Disable for now
  };
  languages.rust = {
    enable = true;
  };
}
