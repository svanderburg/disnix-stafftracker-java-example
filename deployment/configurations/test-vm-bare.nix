{pkgs, ...}:

{
  services = {
    openssh = {
      enable = true;
    };

    disnix = {
      enable = true;
    };
  };

  networking.firewall.enable = false;
  virtualisation.memorySize = 4096;

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.lynx
    ];
  };

  dysnomia = {
    extraModulePaths = [ "/nix/var/nix/profiles/disnix/containers/libexec/dysnomia" ];
    extraContainerPaths = [ "/nix/var/nix/profiles/disnix/containers/etc/dysnomia/containers" ];
  };
}
