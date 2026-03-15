# VDI NixOS Configuration

This is a modular, ephemeral (stateless), and declarative NixOS configuration. It utilizes **Home Manager**, **Impermanence** (for filesystem persistence), and **Kvantum/Dracula** theming.

## Prerequisites

- A target machine with a GPT partition table.
- At least two partitions:
  1. `/boot` (FAT32, e.g., 512MB)
  2. `/persist` (EXT4, this will hold all your persistent state)

---

## Method 1: Bare Metal / VM Installation (Clone & Build)

Use this method if you are installing NixOS on a new system from a standard NixOS ISO.

### 1. Initial Setup

Clone the repository and enter the directory:

```bash
git clone https://github.com/ENDragnee/vdi_nixos_config
cd vdi_nixos_config
```

### 2. Update Hardware Configuration

You **must** update the `hardware-configuration.nix` to match your disk UUIDs.

1. Run `lsblk -f` to see your partition UUIDs.
2. Edit `hardware-configuration.nix`:
   - Replace the `boot` UUID with your `/boot` partition UUID.
   - Replace the `persist` UUID with your `/persist` partition UUID.
3. Ensure the `nix` bind-mount in `hardware-configuration.nix` correctly points to your `persist` partition.

### 3. Initialize Persistence

The system will fail to boot if the persistent directory structure is missing. Create the required folders on your `/persist` drive:

```bash
sudo mkdir -p /persist/etc/nixos /persist/home/vdi /persist/var/lib/docker
sudo chown -R vdi:users /persist/home/vdi
```

### 4. Build and Switch

Since your config is a flake, run:

```bash
# Generate the boot entry
sudo nixos-rebuild boot --flake .#vdi

# Switch to the new configuration
sudo nixos-rebuild switch --flake .#vdi
```

---

## Method 2: Proxmox (QCOW2 Image)

Use this method if you want to deploy a pre-configured, ready-to-go environment into Proxmox.

### 1. Download/Generate the Image

You can generate a QCOW2 image directly from this flake using `nixos-generators`:

```bash
# Install nixos-generators
nix-shell -p nixos-generators

# Build the qcow2 image
nixos-generate --format qcow2 --flake .#vdi
```

### 2. Import into Proxmox

1. Upload the resulting `nixos.qcow2` file to your Proxmox node (e.g., via `scp` to `/var/lib/vz/template/iso/`).
2. Create a new VM in Proxmox:
   - **OS:** Do not select an ISO.
   - **System:** UEFI, Q35 machine type.
   - **Disk:** Delete the default disk, then use `qm importdisk <vmid> /path/to/nixos.qcow2 <storage_name>` via the shell.
3. Attach the disk to the VM in the Proxmox GUI.

### 3. Post-Import Config

Once the VM starts:

1. **Login:** Log in as `vdi`.
2. **Persistence:** Since this is a pre-built image, verify `/persist` is mounted:
   ```bash
   mount | grep /persist
   ```
3. **Environment:** If you moved this to a different physical disk, you may need to update the UUIDs in `/etc/nixos/hardware-configuration.nix` and run `sudo nixos-rebuild switch --flake .#vdi`.

---

## Important Notes for Maintenance

- **Password Change:** To change your password, run `mkpasswd -m sha-512` and update the `hashedPassword` field in `configuration.nix`.
- **Dirty Git Tree:** If you get a "Git tree is dirty" warning, add your changes to the git index: `git add .`
- **Applying Themes:** Run `openbox --reconfigure` after any change to theme files to see updates instantly.
- **Telegraf:** Ensure `/persist/etc/telegraf.env` is populated with your `INFLUX_TOKEN` or the service will crash on boot.

---

This looks like a professional-grade "Golden Image" configuration. Here is an updated summary and an enhanced TODO list, incorporating the technical milestones you’ve successfully cleared.

---

# Features Summary: VDI Golden Image

- **Ephemeral & Immutable:** Root filesystem resets to a known clean state on every reboot.
- **Persistent State:** Intelligent bind-mounts via `impermanence` for personal data, VSCode, browser profiles, and SSH/GPG keys.
- **Curriculum-Ready:** Pre-configured development environment for C/C++, Java, JS/TS, Node.js, Go, PHP, Docker, Laravel, Python, and Django.
- **Performance Optimized:** Minimalist Openbox window manager with low memory/CPU footprint.
- **Modern Dracula UI:** Fully unified Kvantum/GTK/Openbox theme with automated cursor and icon handling.
- **Automated Observability:** Built-in Telegraf agent streaming system metrics to InfluxDB and Kafka.

---

# TODO List:

### Core Infrastructure

- [x] **Declarative Config:** Entire system, shell, and applications managed via Flakes.
- [x] **Impermanence & Ephemeral:** Root filesystem (tmpfs) wiped on boot with persistent `/persist` storage.
- [x] **Immutability:** System state enforced through read-only Nix store symlinks.
- [x] **User Management:** Password-protected accounts with immutable user settings.

### Observability & Integration

- [x] **Telegraf Setup:** Streaming system telemetry to InfluxDB and Apache Kafka.
- [ ] **Golang Remote Agent:** Implement agent for secure remote command execution and cluster management.

### UI/UX & Quality of Life

- [x] **Window Manager:** Cleaned and optimized Openbox configuration.
- [x] **Desktop Panel:** Tint2 panel configured for workspace and system tray management.
- [ ] **UI/UX Refinements:**
  - [ ] Align panel elements for better visual balance.
  - [ ] Synchronize icon sets between Nemo, Tint2, and Rofi.
- [ ] **Typography & Aesthetics:**
  - [ ] Harmonize Powermenu icons and font sizing.
  - [ ] Standardize Nerd Font usage across all apps.
- [ ] **Cheatsheet & Documentation:**
  - [ ] Generate an `autostart` shortcut map for users (Openbox keybinds).
  - [ ] Create a `README` for students on how to access development tools.

### Development Environment

- [x] **Toolchain Setup:** C/C++, Java, Node.js, Go, PHP, Python, Docker, and Web dev tools.
- [x] **IDE Integration:** Declarative VSCode setup with automatic extension and settings syncing.
- [ ] **Project Management:**
  - [ ] Setup `direnv` and `nix-direnv` for project-specific environment switching.

---

### Pro-Tip for your TODOs:

Since you are using `flake.nix`, you can track your "Development Environment" progress by creating a `devShells` section in your `flake.nix` that matches your curriculum requirements. This would allow students to simply type `nix develop` in a folder to get the exact tools they need for their specific assignments!
