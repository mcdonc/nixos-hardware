{ lib, ... }:
{
  imports = [
    ../../../common/gpu/nvidia.nix
    ../../../common/cpu/intel
    #../../../common/cpu/intel/kaby-lake
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

    opengl = {
      driSupport = lib.mkDefault true;
      driSupport32Bit = lib.mkDefault true;
    };
  };

  # TODO: machine won't resume from sleep (at least when on battery).  This
  # is true whether or not the kaby-lake import above is active or not.

  # NB: the p53 profile uses throttled to prevent too-eager CPU
  # throttling instead of thermald.  I understand throttled to have been a
  # workaround solution at the time that profile was created.  Thermald would
  # have been preferred if it worked at the time. I read
  # https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues
  # as saying that throttled is no longer necessary given version 5.12+ of the
  # kernel combined with version 2.4.3+ of thermald.  At the time of this
  # writing, the stable NixOS kernel is 5.15 and 2.4.9 of thermald.  So we use
  # thermald.
  services.thermald.enable = lib.mkDefault true;
}
