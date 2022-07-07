# Sleep
# -----
#
# Without this configuration, the system will not go to sleep properly.
#
# When the system is told to sleep, it will appear to go into a
# sleep state, but within five minutes (and sometimes much more quickly; in
# my case especially if a USB hub is connected), it will wake itself.  I
# attempted to identify what was causing this to happen, but was not
# successful.
#
# The machine actually sleeps and resumes reliably when tlp is disabled fully
# or partially.  Disabling RUNTIME_PM and AHCI_RUNTIME_PM appears to be enough
# to allow it to work when tlp is active.  This will negatively effect battery
# life.  I couldn't figure out a more granular way to get it working, despite
# trying to do a per-device binary search via powertop.  Note that unlike the
# P50 and P51, the "hardware.enableAllFirmware" option must also be set to true
# to make sleep work properly on the P52.

{config, lib, ...}:

{
  services.tlp = {
    settings = {
      # DISK_DEVICES must be specified for AHCI_RUNTIME_PM settings to work right.
      DISK_DEVICES = "nvme0n1 nvme1n1 sda sdb";

      # with AHCI_RUNTIME_PM_ON_AC/BAT set to defaults in battery mode, P51
      # can't resume from sleep and P50 can't go to sleep.
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "on";

      # with RUNTIME_PM_ON_BAT/AC set to defaults, P50/P51 can't go to sleep
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "on";
    };
  };
}
