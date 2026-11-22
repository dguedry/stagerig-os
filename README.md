# StageRig OS

**Turns a stock Ubuntu 26.04 LTS Desktop into a rig for playing music live.**

It is not a distribution and there is no ISO to download. You install ordinary
Ubuntu, and one package sets it up for low-latency audio and brings in
[StageRig](https://github.com/dguedry/stagerig), free instruments and effects,
soundfonts, and [VST Environment](https://github.com/dguedry/vstenv) for
Windows plugins. Fixes to the setup arrive with your normal updates.

## Install

Download [Ubuntu 26.04 LTS Desktop](https://ubuntu.com/download/desktop), write
it to a USB stick and start the computer from it. Connect to the network. Then
either way works:

**Let the installer do it.** On the page *What type of installation?*, choose
**Automated installation** and enter:

```
https://dguedry.github.io/stagerig-os/autoinstall.yaml
```

The installer still asks for your language, keyboard, network, disk, name and
time zone. It installs the minimal desktop (no office software), graphics
drivers and codecs, and StageRig OS at the end.

**Or install Ubuntu yourself**, choosing *Default selection* for the apps, and
run this after the first start:

```sh
wget -qO- https://dguedry.github.io/stagerig-os/install.sh | sudo bash
```

Either way, restart afterwards. The first time you log in, VST Environment
installs itself for your user (a few minutes, with a notice when it is done).
Then check the result:

```sh
stagerig-os-check
```

It only looks, and lists anything marked **FIX** or **LOOK**.

## What you get

| | |
|---|---|
| **StageRig** | The performance host, from its own package source, kept up to date |
| **Instruments** | Surge XT, setBfree (tonewheel organ), ZynAddSubFX, AVL Drumkits |
| **Effects** | Dragonfly Reverb, LSP, x42, Calf, Guitarix, ZamAudio |
| **Soundfonts** | FluidR3 GM and GS, MuseScore General, in `/usr/share/sounds` |
| **Windows plugins** | VST Environment, installed for each user at first login |
| **Tools** | Volume Control (pavucontrol), qpwgraph, the tablet mirror's helpers |

## What it changes

| Setting | Where | Why |
|---|---|---|
| Kernel options `preempt=full threadirqs rcu_nocbs=all` | `/etc/default/grub.d/99-stagerig.cfg` | The audio thread runs the moment it is due. These are the options Ubuntu Studio boots with |
| `usbcore.autosuspend=-1` | same file | USB audio and MIDI devices are never put to sleep |
| Realtime priority 95, unlimited locked memory, for every ordinary user | `/etc/security/limits.d/30-stagerig-audio.conf` | Small buffers only stay clean at realtime priority. No group to join |
| PipeWire fixed at 48 kHz | `/usr/share/pipewire/pipewire.conf.d/10-stagerig.conf` | Nothing resamples; no device is reopened mid-song |
| Sound devices never suspended | `/usr/share/wireplumber/wireplumber.conf.d/51-stagerig-no-suspend.conf` | Waking one costs a click and the first notes |
| PipeWire is the JACK server for every JACK program | `/etc/ld.so.conf.d/stagerig-pipewire-jack.conf` | No `pw-jack`, no second sound server |
| `vm.swappiness = 10` | `/usr/lib/sysctl.d/90-stagerig.conf` | Samples stay in memory |
| `ntsync` loaded at start | `/usr/lib/modules-load.d/stagerig-os.conf` | Windows plugins use far less CPU |
| No automatic updates (apt and snap) | `/etc/apt/apt.conf.d/99stagerig-manual-updates`, `stagerig-os-hold-snap-refresh.service` | Nothing downloads or restarts during a show |
| Screen never blanks, computer never sleeps | `/etc/dconf/db/local.d/00-stagerig` | Defaults; Settings can still change them |
| Background jobs off: the out-of-memory daemon, crash reports, printer search, modem probing, and the timers for firmware lists, the manual index, apt and the weekly disk trim | listed in `/var/lib/stagerig-os/quieted` | Each wakes when it likes, and one missed while the computer was off runs just after you switch it on. `stagerig-os-update` trims the disk and refreshes the firmware list instead |
| Wifi power saving off | `/etc/NetworkManager/conf.d/stagerig-wifi-powersave-off.conf` | The radio stays awake, so the tablet does not pause |
| File indexer off | masked in `/etc/systemd/user` | It reads whole sample libraries whenever it likes |

It also gives the computer the StageRig look. All of it is a default that
**Settings ▸ Appearance** can change:

| | |
|---|---|
| Wallpaper, on the desktop and the lock screen, cut to the shape of your screen | `/usr/share/backgrounds/stagerig-os/` |
| Dark style with the orange accent | `/usr/share/glib-2.0/schemas/90_stagerig-os.gschema.override` |
| The dock: StageRig, VST Environment, Volume Control, qpwgraph, the browser and the file manager, and no drives | same file |
| Boot, shutdown and disk-password screens: the StageRig wordmark over a spinner | Plymouth theme `stagerig` in `/usr/share/plymouth/themes` |
| The wordmark on the login screen | `/usr/share/stagerig-os/logo.svg` |

The wallpaper comes in six shapes (16:9, 16:10, 3:2, 4:3, 21:9 and 32:9), so
the wordmark sits in the corner on every screen. The one nearest your main
screen is chosen when you log in and whenever a screen is connected. Pick any
other wallpaper in Settings and yours is left alone.

The wordmark and the wallpaper's parts are in [branding/](branding/);
`scripts/make-wallpapers` cuts the shapes when the package is built. The logo
the computer's maker shows when it is switched on comes from its firmware and
is not changed.

The buffer size is not set here: StageRig sets it while it runs (**Audio...** ▸
*LEVEL AND LATENCY*, 128 samples by default) and holds the processor at full
speed.

`install.sh` also removes office, mail and games if they are installed
(`--keep-desktop-apps` leaves them) and installs the NVIDIA driver when there
is an NVIDIA card.

## Updates

Because nothing updates by itself, do it when it suits you, not before a show:

```sh
sudo stagerig-os-update
```

That updates Ubuntu, StageRig, StageRig OS, snaps and Flatpaks, and trims
the disk.
`stagerig-os-check` reminds you after thirty days.

## When your audio interface arrives

Any class-compliant USB interface works without a driver. Plug it in, open
**Volume Control** ▸ *Configuration* and give it the **Pro Audio** profile, so
every channel is available. Then choose it in StageRig's **Audio...** window.
Run `stagerig-os-check`, then play your heaviest setup while watching the ERR
column of `pw-top`; it should stay at 0. If it does not, raise the buffer one
step.

## Changing or removing it

- To change a PipeWire or WirePlumber setting, copy the file from `/usr/share`
  to the same place under `/etc` and edit the copy.
- `sudo apt purge stagerig-os` removes every setting above and restores
  automatic updates. StageRig, the plugins and VST Environment stay; remove
  them separately if you want to.

## Building it

```sh
sudo apt install build-essential debhelper plymouth-theme-spinner python3-pil
dpkg-buildpackage -b -us -uc          # ../stagerig-os_<version>_all.deb
sudo ./install.sh --deb ../stagerig-os_*_all.deb    # try it on a fresh Ubuntu
```

A release is a version in `debian/changelog` and a matching tag (`v0.1.0`).
The workflow builds the package, attaches it to the release, and publishes the
signed apt repository, `install.sh` and `autoinstall.yaml` to GitHub Pages. It
needs the repository secret `STAGERIG_REPO_SIGNING_KEY` (an armored private
GPG key with no passphrase) and Pages set to deploy from GitHub Actions. The
key is this repository's own, separate from StageRig's.

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
