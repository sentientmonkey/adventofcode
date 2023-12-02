{ pkgs, ... }:

{
  packages = [ pkgs.git ];

  languages.ruby.enable = true;
  languages.ruby.package = pkgs.ruby_3_2;
}
