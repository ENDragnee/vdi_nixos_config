# NixOS VDI Configuration: Ephemeral Base System

This directory contains the declarative NixOS configuration for the VDI instances. It is designed to be deployed as a **Golden Template** on Proxmox and managed via GitOps.

## 1. Deployment: The Golden Template

To create a new Golden Template:
1.  Clone a base NixOS image or perform a manual ISO install.
2.  Set up the `/persist` partition (e.g., ext4 on a dedicated disk or a specific subvolume).
3.  Ensure the following files exist in `/persist/etc/nixos/`:
    - `telegraf.env`: Environment variables for InfluxDB/Kafka.
    - `vdi-agent.env`: Contains `AGENT_SECRET`, `NEXTJS_API_KEY`, and `NIXOS_CONFIG_DIR`.
4.  Copy this repository to `/etc/nixos/`.
5.  Run: `sudo nixos-rebuild switch --flake .#vdi`.
6.  **Sanitization (CRITICAL):**
    - Run `rm -f /etc/machine-id /var/lib/dbus/machine-id`.
    - Run `rm -f /etc/ssh/ssh_host_*`.
    - Shutdown and convert to a Proxmox Template (ID: 100).

## 2. Infrastructure Persistence Logic

The system utilizes the **Impermanence** module. The root (`/`) is wiped on reboot. The following paths are persistent and must exist on the `/persist` partition:

| Path | Purpose |
| :--- | :--- |
| `/etc/nixos` | Declarative system state and Flake lock. |
| `/var/log` | Persistent system logs for auditing. |
| `/var/lib/nixos` | System generations and profile metadata. |
| `/etc/ssh` | SSH Host Keys (prevents MITM warnings). |
| `/etc/machine-id` | Stable identifier for DHCP and systemd. |
| `/var/lib/docker` | Persistent container images and volumes. |
| `/var/lib/cloud` | Cloud-Init state and provisioning markers. |

## 3. Provisioning & Cloud-Init

Instances are assigned hostnames matching the `vds-host.local` convention.
- **`break-hostname-symlink.service`:** A oneshot service that removes the static `/etc/hostname` symlink. This allows Cloud-Init to inject the Proxmox-defined hostname into the live system without being overridden by the NixOS configuration.
- **SSH Keys:** The system user `vdi` is provisioned with a default SSH key during the build, but additional keys can be injected via Cloud-Init.

## 4. Maintenance

Updates to the Golden Template are handled via the `vdi-agent`. When the Control Plane triggers a sync:
1.  The agent pulls the latest commits from the Git repository.
2.  It executes `nixos-rebuild switch --flake .#vdi`.
3.  The `packages.nix` module is dynamically updated to reflect the user's requested software stack.
