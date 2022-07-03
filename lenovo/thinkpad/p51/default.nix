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
      # marked as "experimental" in the source
      # powerManagement.enable = true;
    };

    # other opengl stuff is included via <nixos-hardware/common/cpu/intel> and
    # <nixos0hardware/common/gpu/nvidia.nix>
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  
  services.thermald.enable = lib.mkDefault true;
}
