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

  # TODO
  # ====
  #
  # Sleep
  # -----
  #
  # In offload mode, the system will not resume from sleep properly while on
  # battery power.  When it tries to resume, it gets to a state with a cursor
  # in the top left hand side of the panel, the power LED goes from flashing to
  # solid, and thereafter cannot be interacted with (even over SSH) and must be
  # power cycled forcefully.  Sometimes it doesn't even finish going to sleep before
  # this behavior kicks in.
  #
  # When on AC, the machine either wakes up from sleep before being asked to
  # (or maybe never gets to sleep state), or it goes into a sleep state and it
  # appears consistently resume properly when it does.
  #
  # These behaviors are true whether or not the kaby-lake import above is
  # active or not.  Things are marginally improved by doing
  # "hardware.nvidia.powerManagement.enable = true", as the machine then may
  # sleep and resume even on battery the first time you try it, but second and
  # subsequent times either fail to sleep or fail to resume in the same way as
  # described above.
  #
  # In sync mode.. TBD.
  #
  # Potentially useful resource:
  # https://askubuntu.com/questions/1032633/18-04-screen-remains-blank-after-wake-up-from-suspend/1391917#1391917
  # although I do not see the same stack traces in the journalctl log as the OP.  I see no stack traces in the journalctl log at all, I just see something like this when
  #
  # The situation in which the machine seemingly goes to sleep for a couple of
  # seconds and then immediately rewakes may be related to this journalctl
  # entry Jul 03 13:55:55.186089 thinknix51 kernel: ahci 0000:00:17.0: port
  # does not support device sleep.  This is rumored by
  # https://groups.google.com/g/linux.debian.kernel/c/h6bX96m8ixc?pli=1 to be
  # related to too-aggressive "link power management."
  #
  # AHA!  It actually sleeps and resumes reliably, at least in offload mode, on
  # battery, when tlp is disabled.
  #
  # All of the above was "solved" by disabling runtime power management.
  #
  # External monitor
  # ----------------
  #
  # Connecting an external monitor via the DP port in sync mode does not seem to
  # make it available.
  #
  # throttled vs. thermald
  # -----------------------
  #
  # NB: the p53 profile currently uses throttled to prevent too-eager CPU
  # throttling.  I understand throttled to have been a workaround solution at
  # the time the p53 profile was created (throttled's original name was
  # "lenovo_fix").  thermald would have been preferred if it worked at the
  # time.
  #
  # I read
  # https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues
  # as saying that thermald is fixed under the circumstance that led to the
  # development of throttled given version 5.12+ of the kernel combined
  # with version 2.4.3+ of thermald.  At the time of this writing, the
  # stable NixOS kernel is 5.15 and 2.4.9 of thermald.
  #
  # In the meantime, I also ran the "s-tui" program which can stress test the
  # system, while eyeing up the core temps and CPU frequency under three
  # scenarios: under thermald, under throttled, and with neither.  None of the
  # scenarios seem to have massively improved fan behavior, core temps, or
  # average CPU frequency than another.  The highest core temp always seems to
  # hover around 90 degrees C, the lowest CPU Ghz around 3.4.
  #
  # I ended up choosing throttled because subjectively, the fans seem quieter
  # when it's stressed and it allows the average temps to get a degree or two
  # higher when running throttled than when running in the other two scenarios,
  # but still substantially under critical temp.

  services.throttled.enable = lib.mkDefault true;

}
