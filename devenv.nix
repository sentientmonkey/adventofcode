{ pkgs, ... }:

{
  packages = [ pkgs.git ];

  languages.ruby.enable = true;
}
