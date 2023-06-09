{
  config,
  pkgs,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-516843a3-ab3d-4e2e-9591-d3f29484f5f7".device = "/dev/disk/by-uuid/516843a3-ab3d-4e2e-9591-d3f29484f5f7";
  boot.initrd.luks.devices."luks-516843a3-ab3d-4e2e-9591-d3f29484f5f7".keyFile = "/crypto_keyfile.bin";

  # Define hostname.
  networking.hostName = "hp";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;
  users.users.remi.extraGroups = ["networking"];
}
