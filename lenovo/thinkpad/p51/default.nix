{ nixos, pkgs, lib, config, stdenv, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia.nix
    ../../../common/pc/laptop/acpi_call.nix
    ../.
  ];

  hardware = {
    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # other opengl stuff is included via <nixos-hardware/common/cpu/intel> and
    # <nixos-hardware/common/gpu/nvidia.nix>.  I'm not sure enabling DRI here
    # is too aggressive.  Maybe try without and see what happens to steam and
    # accelerated video in Chromium/FF.
    opengl = {
      driSupport = lib.mkDefault true;
      driSupport32Bit = lib.mkDefault true;
    };
  };

  # note that the p53 profile uses throttled instead; I read
  # https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues
  # as saying that this is no longer necessary.
  services.thermald.enable = lib.mkDefault true;
}
